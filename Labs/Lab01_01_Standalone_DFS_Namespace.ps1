# LAB 1 Standalone DFS

function Add-DFSExampleFolder {
    param (
        [String]$DfsPath,
        [String]$TargetName,
        [String]$RootFolder
    )

    # Prepare Example folder
    $newFolder = New-Item (Join-Path -Path $RootFolder -ChildPath $TargetName) -ItemType Directory -Force
    $newShare = New-SmbShare -Path $newFolder.FullName -Name $TargetName -ReadAccess Everyone
    $SharedName = "\\" + $env:COMPUTERNAME + "\$TargetName"
    New-Item (Join-Path -Path $newFolder.FullName -ChildPath "install-$targetName.bat") -ItemType File -Value "placeholder"
    # Add Target server to DFS Namespace
    New-DfsnFolder -Path (Join-Path $DfsPath -ChildPath $TargetName) -TargetPath $SharedName
}

# Install Windows Feature "DFS Namespaces"
Install-WindowsFeature -Name FS-DFS-Namespace -IncludeManagementTools -Restart

# Create New Namespace
New-Item -ItemType Directory -Path C:\DFSRoots\Software -Force
New-SmbShare -Name Software -ReadAccess Everyone -Path C:\DFSRoots\Software  
New-DfsnRoot -Type Standalone -Path \\DFS-FS-NY\Software -TargetPath C:\DFSRoots\Software

# Add local Example Folders
"Adobe","Microsoft","Google" | ForEach-Object {
    Add-DFSExampleFolder -DfsPath \\DFS-FS-NY\Software -TargetName $_ -RootFolder C:\Shares
}

# Add remote example folder
Invoke-Command -computerName DFS-FS-LA -ScriptBlock {
    New-Item C:\Shares\Apple -ItemType Directory
    New-SmbShare -Path C:\Shares\Apple -Name Apple -ReadAccess Everyone
    New-Item -Path C:\Shares\Apple -Name "install-apple.bat" -ItemType File
}
New-DfsnFolder -Path \\dfs-fs-ny\Software\Apple -TargetPath \\DFS-FS-LA\Apple