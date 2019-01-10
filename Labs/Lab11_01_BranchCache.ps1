# Lab 11 Branch Cache (Setup on DFS-DC1)

# Install Content Server
Install-WindowsFeature FS-BranchCache -IncludeManagementTools -ComputerName dfs-fs-ny
Install-WindowsFeature FS-Data-Deduplication -IncludeManagementTools -ComputerName dfs-fs-ny

# Configure BranchCache settings for example share
New-PSSession -Name CONTENTCACHE -ComputerName DFS-FS-NY
Invoke-Command -Session (Get-PSSession -Name CONTENTCACHE) -ScriptBlock {
    Get-SmbShare Microsoft | Set-SmbShare -CachingMode BranchCache -Force -Confirm:$false
    Get-ChildItem C:\Windows\System32 | Sort-Object -Descending -Property Length | Select-Object -First 25 | ForEach-Object {
        Copy-Item $_.FullName -Destination C:\Shares\Microsoft -ErrorAction SilentlyContinue
    }
}
Remove-PSSession -Name CONTENTCACHE

# Configure Host Cache Server
New-PSSession -Name HOSTCACHE -ComputerName DFS-FS-LA
Invoke-Command -Session (Get-PSSession -Name HOSTCACHE) -ScriptBlock {
    Install-WindowsFeature BranchCache -IncludeManagementTools
}

# Enable Hosted Cache Mode
Invoke-Command -Session (Get-PSSession -Name HOSTCACHE) -ScriptBlock {
    Enable-BCHostedServer -RegisterSCP
}
Remove-PSSession -Name HOSTCACHE

# Enable BC on clients

## Create GP Object and Link to AD Site "LosAngeles"
New-GPO -Name BCClient -Domain DFS.lab
New-GPLink -Name BCClient -Target "LosAngeles"

## edit GPO in gpmc.msc
# gpmc.msc --> Comp Cfg --> Adm Templ --> Network --> BranchCache --> Turn on Branch Cache; Enable Automatic Hosted Cache Discovery by SCP
# example client: DFS-CL-NY (Reconfigure for Site: LosAngeles)