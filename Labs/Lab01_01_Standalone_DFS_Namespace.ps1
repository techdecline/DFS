# LAB 1 Standalone DFS

# Install Windows Feature "DFS Namespaces"
Install-WindowsFeature -Name FS-DFS-Namespace -IncludeManagementTools -Restart

# Create New Namespace 
New-DfsnRoot -Type Standalone -Path \\DFS-FS-NY\Software -TargetPath C:\DFSRoots\Software

# Add local Example Folders
"Adobe","Microsoft","Google" | ForEach-Object {
    New-DfsnFolder -Path (Join-Path \\DFS-FS-NY\Software -ChildPath $_) -TargetPath "\\DFS-FS-NY\$_"
}

# Add remote example folder
New-DfsnFolder -Path \\dfs-fs-ny\Software\Apple -TargetPath \\DFS-FS-LA\Apple