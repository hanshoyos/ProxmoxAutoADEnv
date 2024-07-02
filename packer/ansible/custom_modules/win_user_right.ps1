#!/usr/bin/env pwsh
param (
    [string]$name,
    [string[]]$users
)

foreach ($user in $users) {
    $sid = (New-Object System.Security.Principal.NTAccount($user)).Translate([System.Security.Principal.SecurityIdentifier]).Value
    secedit /export /cfg C:\Windows\Temp\secedit.inf
    (Get-Content C:\Windows\Temp\secedit.inf) -replace ('SeRemoteInteractiveLogonRight = \*') { "SeRemoteInteractiveLogonRight = *$sid" } | Set-Content C:\Windows\Temp\secedit.inf
    secedit /configure /db secedit.sdb /cfg C:\Windows\Temp\secedit.inf
}
