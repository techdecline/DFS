$addressHash = @{
    "DFS-FS-LA" = "192.168.0.87"
    "DFS-FS-VA" = "192.168.0.44"
    "DFS-FS-MX" = "192.168.0.68"
    "DFS-FS-NY" = "192.168.0.19"
    "DFS-CL-NY" = "192.168.0.251"
}

$leaseArr = Get-DhcpServerv4Lease -ScopeId 192.168.0.0


foreach ($lease in $leaseArr) {
    $hostName = ($lease.hostName -split '\.')[0]
    Add-DhcpServerv4Reservation -ScopeId 192.168.0.0 -IPAddress $addressHash.Item($hostName) `
        -ClientId $lease.ClientId -Name $hostName
    Invoke-Command -ScriptBlock {ipconfig /release; ipconfig /renew} -ComputerName $hostName
}