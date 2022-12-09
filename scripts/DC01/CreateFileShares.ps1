<#
Creates sample file shares.

TODO: Add checking to confirm permissions are what they are supposed to be, so this can be re-ran.
#>

function Create-TestFiles {
    param(
        $Path,
        $Depth,
        $FileNamesPath,
        $FolderNamesPath,
        $MaxFiles = 20,
        $MaxFolders = 20
    )
    
    $FileNames = Get-Content -Path $FileNamesPath
    $FolderNames = Get-Content -Path $FolderNamesPath
    
    if(-not (Test-Path -Path $Path)) {
        Write-Output "Creating root folder $($Path)"
        New-Item -Path $Path -ItemType Directory | Out-Null
    }
    
    function Fill-Directory {
        param(
            $Path,
            $CurrentDepth
        )
    
        # Number of files and folders to create at this level
        $FileCount = Get-Random -Minimum 1 -Maximum $MaxFiles
        $FolderCount = Get-Random -Minimum 1 -Maximum $MaxFolders
    
        # Create files
        1..$FileCount | ForEach-Object {
            $FileName = $FileNames | Get-Random
            $FilePath = Join-Path -Path $Path -ChildPath $FileName
            if(-not (Test-Path -Path $FilePath)) {
                New-Item -Path $FilePath -ItemType File -Value (New-Guid).Guid | Out-Null
            }
        }
    
        # Create subfolders if needed
        if($CurrentDepth -lt $Depth) {
            1..$FolderCount | ForEach-Object {
                $FolderName = $FolderNames | Get-Random
                $FolderPath = Join-Path -Path $Path -ChildPath $FolderName
    
                if(-not (Test-Path -Path $FolderPath)) {
                    New-Item -Path $FolderPath -ItemType Directory | Out-Null
                    Fill-Directory -Path $FolderPath -CurrentDepth ($CurrentDepth + 1)
                }
            }
        }
    }
    
    Fill-Directory -Path $Path -CurrentDepth 0
}

$ShareCsv = "C:\Vagrant\Scripts\DC01\FileShares.csv"
$PermissionsMap = @{
    "FC" = "FullControl"
    "R" = "ReadAndExecute, Synchronize"
    "RW" = "Modify, Synchronize"
}

if(-not (Test-Path -Path $ShareCsv)) {
    Write-Host "File Share CSV file not found!"
    exit
}

$Shares = ConvertFrom-Csv (Get-Content -Path $ShareCsv)

$Shares.Path | ForEach-Object {
    New-Item -Path $_ -ItemType Directory | Out-Null
}

# Set NTFS Permissions
$Shares | ForEach-Object {

    # Fill share with dummy files before we adjust permissions.
    Create-TestFiles -Path $_.Path -Depth (Get-Random -Minimum 2 -Maximum 5) `
        -FileNamesPath "C:\Vagrant\Scripts\DC01\filenames.txt" -FolderNamesPath "C:\Vagrant\Scripts\DC01\foldernames.txt" `
        -MaxFiles 20 -MaxFolders 8

    $Acl = Get-Acl -Path $_.Path

    # Clear inheritence
    $Acl.SetAccessRuleProtection($true, $false)

    # Add each rule from csv
    $_.NtfsPermissions | ForEach-Object {
        $Groups = $_.Split('|')

        $Groups | ForEach-Object {
            $Group, $Permission = $_.Split(':')
            $Acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule($Group, $PermissionsMap[$Permission], 'ObjectInherit, ContainerInherit', 'None', 'Allow')))
        }

    }

    # Apply ACL
    (Get-Item -Path $_.Path).SetAccessControl($Acl)

    # Create smb share
    if(-not (Get-SmbShare -Name $_.ShareName -ErrorAction SilentlyContinue)) {
        $SharePermissions = @{}
        $_.SharePermissions.Split('|') | ForEach-Object {
            $AccessLevel, $Group = $_.Split(':')
            $SharePermissions.$AccessLevel = $Group.Replace('.', ',') #Replace periods with comma's, to allow comma seperated list of groups within the csv
        }

        $ShareParameters = @{
            Name = $_.ShareName
            Path = $_.Path
        }

        if($SharePermissions.FullControl) {
            $ShareParameters.FullControl = $SharePermissions.FullControl
        }

        if($SharePermissions.ChangeAccess) {
            $ShareParameters.ChangeAccess = $SharePermissions.ChangeAccess
        }

        if($SharePermissions.ReadAccess) {
            $ShareParameters.ReadAccess = $SharePermissions.ReadAccess
        }

        if($SharePermissions.NoAccess) {
            $ShareParameters.NoAccess = $SharePermissions.NoAccess
        }

        New-SmbShare @ShareParameters | Out-Null
    }

}