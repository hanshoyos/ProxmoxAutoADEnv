#!/usr/bin/env pwsh
param (
    [string]$name
)

Rename-Computer -NewName $name -Force -Restart
