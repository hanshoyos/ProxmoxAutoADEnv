#!/usr/bin/env pwsh

param (
    [string[]]$name,
    [bool]$include_management_tools = $false,
    [bool]$include_sub_features = $false,
    [string]$state
)

foreach ($feature in $name) {
    if ($state -eq 'present') {
        Install-WindowsFeature -Name $feature -IncludeManagementTools:$include_management_tools -IncludeAllSubFeature:$include_sub_features
    } else {
        Remove-WindowsFeature -Name $feature
    }
}
