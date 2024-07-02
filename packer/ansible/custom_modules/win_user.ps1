#!/usr/bin/env pwsh
param (
    [string]$name,
    [string]$password,
    [string[]]$groups,
    [string]$state
)

$secure_password = ConvertTo-SecureString $password -AsPlainText -Force

if ($state -eq 'present') {
    New-LocalUser -Name $name -Password $secure_password -PasswordNeverExpires
    foreach ($group in $groups) {
        Add-LocalGroupMember -Group $group -Member $name
    }
} else {
    Remove-LocalUser -Name $name
}
