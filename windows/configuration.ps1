#Requires -Version 5.1

. "$PSScriptRoot\install_scripts\declarations.ps1"

while ($true) {
    Write-Host ""
    Write-Host "==================================================="
    Write-Host "Windows setup — press a number to run a step, or q to quit."
    Write-Host "1. Install GlazeWM"
    Write-Host "2. Install Zebar"
    Write-Host "3. Deploy config files"
    Write-Host "4. Full setup (all of the above)"
    Write-Host "==================================================="

    $choice = Read-Host "Choice"

    switch ($choice) {
        "1" { . "$PSScriptRoot\install_scripts\install_glazewm.ps1" }
        "2" { . "$PSScriptRoot\install_scripts\install_zebar.ps1" }
        "3" { . "$PSScriptRoot\install_scripts\deploy_configs.ps1" }
        "4" {
            . "$PSScriptRoot\install_scripts\install_glazewm.ps1"
            . "$PSScriptRoot\install_scripts\install_zebar.ps1"
            . "$PSScriptRoot\install_scripts\deploy_configs.ps1"
        }
        "q" { break }
        default { Log-Info "Invalid choice." }
    }

    if ($choice -eq "q") { break }
}

Write-Host ""
if ($global:ErrorCounter -ne 0) {
    Log-Error "There were $($global:ErrorCounter) error(s) (see log at $global:LOG_FILE)"
} else {
    Log-Success "Done."
}
