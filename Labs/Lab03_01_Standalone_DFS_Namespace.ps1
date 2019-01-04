# Lab 03 Add Referral Server

# Install DFS Namespace feature on DFS-FS-LA
Install-WindowsFeature FS-DFS-Namespace -ComputerName DFS-FS-LA

# Add secondary server as DFS Referral Server
New-DfsnRootTarget -Path \\dfs.lab\Software -TargetPath \\DFS-FS-LA\Software