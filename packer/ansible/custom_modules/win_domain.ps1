param (
    [string]$dns_domain_name,
    [string]$domain_netbios_name,
    [string]$safe_mode_password,
    [bool]$reboot = $false
)

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

$secure_password = ConvertTo-SecureString $safe_mode_password -AsPlainText -Force

Install-ADDSForest -DomainName $dns_domain_name -DomainNetbiosName $domain_netbios_name -SafeModeAdministratorPassword $secure_password -Force:$true

if ($reboot) {
    Restart-Computer -Force
}
