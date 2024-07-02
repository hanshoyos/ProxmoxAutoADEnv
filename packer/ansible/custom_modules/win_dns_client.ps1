#!/usr/bin/env pwsh

param (
    [string[]]$adapter_names,
    [string[]]$ipv4_addresses
)

foreach ($adapter in $adapter_names) {
    Set-DnsClientServerAddress -InterfaceAlias $adapter -ServerAddresses $ipv4_addresses
}
