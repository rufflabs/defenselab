#Requires -Modules ActiveDirectory
<#
.SYNOPSIS
Creates the user accounts and AD groups for the Defense.local domain.

#>
param(
    [switch]$Uninstall
)


function New-OrganizationalUnitFromDN
{
    # From: https://serverfault.com/a/624388
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [string]$DN
    )

    # A regex to split the DN, taking escaped commas into account
    $DNRegex = '(?<![\\]),'

    # Array to hold each component
    [String[]]$MissingOUs = @()

    # We'll need to traverse the path, level by level, let's figure out the number of possible levels 
    $Depth = ($DN -split $DNRegex).Count

    # Step through each possible parent OU
    for($i = 1;$i -le $Depth;$i++)
    {
        $NextOU = ($DN -split $DNRegex,$i)[-1]
        if($NextOU.IndexOf("OU=") -ne 0 -or [ADSI]::Exists("LDAP://$NextOU"))
        {
            break
        }
        else
        {
            # OU does not exist, remember this for later
            $MissingOUs += $NextOU
        }
    }

    # Reverse the order of missing OUs, we want to create the top-most needed level first
    [array]::Reverse($MissingOUs)

    # Prepare common parameters to be passed to New-ADOrganizationalUnit
    $PSBoundParameters.Remove('DN')

    # Now create the missing part of the tree, including the desired OU
    foreach($OU in $MissingOUs)
    {
        $newOUName = (($OU -split $DNRegex,2)[0] -split "=")[1]
        $newOUPath = ($OU -split $DNRegex,2)[1]

        New-ADOrganizationalUnit -Name $newOUName -Path $newOUPath @PSBoundParameters
    }
}


# Location of the Users.csv file
$UserList = "C:\Vagrant\Scripts\AD\AD_Users.csv"
$ComputerList = "C:\Vagrant\Scripts\AD\AD_Computers.csv"

if(-not (Test-Path -Path $UserList)) {
    Write-Host "Users CSV file not found!"
    exit
}

if(-not (Test-Path -Path $ComputerList)) {
    Write-Host "Computers CSV file not found!"
    exit
}

# Collect items that need to be created.
$Users = ConvertFrom-Csv (Get-Content $UserList)
$Computers = ConvertFrom-Csv (Get-Content $ComputerList)

# Gather all groups to be created
$Groups = $Users.Department
$Groups += $Users.Groups | ForEach-Object { 
    if($_ -like "*|*") { 
        $_.Split("|")
    }else{
        $_
    }
}
$Groups += $Computers.Groups | ForEach-Object {
    if($_ -like "*|*") {
        $_.Split("|")
    }else{
        $_
    }
}
$Groups = $Groups.GetEnumerator() | Select-Object -Unique | Where-Object {$_ -ne ''}

# Gather all OU's to be created, adding Groups explicitly
$OrganizationalUnits += $Users.OhYou
$OrganizationalUnits += $Computers.OhYou
$OrganizationalUnits += "OU=Groups,DC=defense,DC=local"
$OrganizationalUnits = $OrganizationalUnits.GetEnumerator() | Select-Object -Unique | Where-Object {$_ -ne ''}

Write-Host "Creating OU's"
# Create OU's
$OrganizationalUnits | ForEach-Object {
    New-OrganizationalUnitFromDN -DN $_ | Out-Null
}

Write-Host "Creating Groups"
# Create groups
$Groups | ForEach-Object {
    New-ADGroup -Name $_ -GroupScope Global -Path "OU=Groups,DC=defense,DC=local" -ErrorAction SilentlyContinue | Out-Null
}

Write-Host "Creating AD Accounts"
# Create computers
# ComputerName,PasswordNotRequired,Groups,OhYou
$Computers | ForEach-Object {
    $SamAccountName = $_.ComputerName
    if($_.PasswordNotRequired -eq 'true') {
        $PasswordNotRequired = $true
    }else{
        $PasswordNotRequired = $false
    }
    $ComputerOptions = @{
        "Name" = $_.ComputerName
        "SamAccountName" = $_.ComputerName
        "Path" = $_.OhYou
        "PasswordNotRequired" = $PasswordNotRequired
    }

    New-ADComputer @ComputerOptions | Out-Null

    if($_.Groups) {
        $_.Groups.Split('|') | ForEach-Object {
            Add-ADGroupMember -Identity $_ -Members (Get-ADComputer -Identity $SamAccountName) -ErrorAction SilentlyContinue | Out-Null
        }
    }
}

# Create users
$Users | ForEach-Object {
    # Determine randomly weak passwords. Roughly a third will be weak.
    if((Get-Random -Maximum 4) -eq 0) {
        $Password = $_.WeakPassword
    }else{
        $Password = $_.Password
    }

    # Make sure SamAccountName isn't longer than 20, or convert it to f.last
    $SamAccountName = "$($_.FirstName).$($_.LastName)"
    if($SamAccountName.Length -gt 20){
        $SamAccountName = "$($_.FirstName.SubString(0, 1))$($_.LastName)"
    }

    $UserOptions = @{
        "AccountPassword" = (ConvertTo-SecureString -AsPlainText $Password -Force)
        "ChangePasswordAtLogon" = $false
        "Department" = $_.Department
        "Description" = $_.Description
        "DisplayName" = "$($_.FirstName) $($_.LastName)"
        "EmailAddress" = "$($_.FirstName).$($_.LastName)@defense.local"
        "Enabled" = $true
        "GivenName" = $_.FirstName
        "Name" = "$($_.FirstName) $($_.LastName)"
        "Path" = $_.OhYou
        "SamAccountName" = $SamAccountName
        "Surname" = $_.LastName
        "Title" = $_.Title
        "ErrorAction" = "SilentlyContinue"
    } 

    New-ADUser @UserOptions | Out-Null

    if($_.Groups) {
        $_.Groups.Split('|') | ForEach-Object {
            Add-ADGroupMember -Identity $_ -Members (Get-ADUser -Identity $SamAccountName) -ErrorAction SilentlyContinue | Out-Null
        }
    }
}

# TODO: Apply GPO's
# Import GPO's into the domain.
