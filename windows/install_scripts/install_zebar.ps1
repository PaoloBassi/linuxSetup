. "$PSScriptRoot\declarations.ps1"

Log-Info "Checking Zebar..."
$installed = winget list --id glzr-io.Zebar 2>$null | Select-String "Zebar"
if ($installed) {
    Log-Info "Zebar is already installed, skipping."
} else {
    Invoke-Step "Installing Zebar via winget" {
        winget install --id glzr-io.Zebar -e --accept-source-agreements --accept-package-agreements
    }
}
