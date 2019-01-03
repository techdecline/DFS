# Rename Default Site
Get-ADObject -SearchBase (Get-ADRootDSE).ConfigurationNamingContext -filter "objectclass -eq 'site'" | Rename-ADObject -NewName Default -Confirm:$false

# Add Default Subnet
New-ADReplicationSubnet -Site Default -Name 192.168.0.0/24

# Add Site NewYork
New-ADReplicationSite NewYork

# Add Site LosAngeles
New-ADReplicationSite LosAngeles

# Add Single IP Subnets
New-ADReplicationSubnet -Site NewYork -Name 192.168.0.251/32
New-ADReplicationSubnet -Site NewYork -Name 192.168.0.19/32
New-ADReplicationSubnet -Site LosAngeles -Name 192.168.0.87/32
New-ADReplicationSubnet -Site LosAngeles -Name 192.168.0.44/32
New-ADReplicationSubnet -Site LosAngeles -Name 192.168.0.68/32