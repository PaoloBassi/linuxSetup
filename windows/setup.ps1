#Requires -Version 5.1

. "$PSScriptRoot\install_scripts\declarations.ps1"

. "$PSScriptRoot\install_scripts\install_glazewm.ps1"
. "$PSScriptRoot\install_scripts\install_zebar.ps1"
. "$PSScriptRoot\install_scripts\deploy_configs.ps1"

Write-Host ""
if ($global:ErrorCounter -ne 0) {
    Log-Error "There were $($global:ErrorCounter) error(s) during setup (see log at $global:LOG_FILE)"
} else {
    Log-Success "All packages installed and configured successfully."
    Log-Info "Log file: $global:LOG_FILE"
}
