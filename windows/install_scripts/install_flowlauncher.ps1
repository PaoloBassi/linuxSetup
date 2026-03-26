. "$PSScriptRoot\declarations.ps1"

Log-Info "Checking Flow Launcher..."
$installed = winget list --id Flow-Launcher.Flow-Launcher 2>$null | Select-String "FlowLauncher"
if ($installed) {
    Log-Info "Flow Launcher is already installed, skipping."
} else {
    Invoke-Step "Installing Flow Launcher via winget" {
        winget install --id Flow-Launcher.Flow-Launcher -e --accept-source-agreements --accept-package-agreements
    }
}
