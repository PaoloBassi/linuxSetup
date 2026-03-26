. "$PSScriptRoot\declarations.ps1"

Log-Info "Checking GlazeWM..."
$installed = winget list --id glzr-io.GlazeWM 2>$null | Select-String "GlazeWM"
if ($installed) {
    Log-Info "GlazeWM is already installed, skipping."
} else {
    Invoke-Step "Installing GlazeWM via winget" {
        winget install --id glzr-io.GlazeWM -e --accept-source-agreements --accept-package-agreements
    }
}
