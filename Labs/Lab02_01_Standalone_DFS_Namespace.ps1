# LAB 2 Domain DFS

# Install Windows Feature "DFS Namespaces"
Install-WindowsFeature -Name FS-DFS-Namespace -IncludeManagementTools -Restart

# Create New Namespace 
New-DfsnRoot -Type DomainV2 -Path \\dfs.lab\Software -TargetPath \\dfs-fs-ny\Software

# Add local Example Folders
"Adobe","Microsoft","Google" | ForEach-Object {
    New-DfsnFolder -Path (Join-Path \\dfs.lab\Software -ChildPath $_) -TargetPath "\\DFS-FS-NY\$_"
}

# Add remote example folder
New-DfsnFolder -Path \\dfs.lab\Software\Apple -TargetPath \\DFS-FS-LA\Apple