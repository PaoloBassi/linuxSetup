. "$PSScriptRoot\declarations.ps1"

$FILES_DIR = "$PSScriptRoot\..\files"

# --- GlazeWM config ---
Log-Info "Deploying GlazeWM config..."

$glazewmDir = "$env:USERPROFILE\.glzr\glazewm"
$glazewmConfig = "$glazewmDir\config.yaml"

if (-not (Test-Path $glazewmDir)) {
    New-Item -ItemType Directory -Path $glazewmDir -Force | Out-Null
}

if (Test-Path $glazewmConfig) {
    $backup = "$glazewmConfig.bak"
    Log-Info "Backing up existing config to $backup"
    Copy-Item $glazewmConfig $backup -Force
}

try {
    Copy-Item "$FILES_DIR\glazewm\config.yaml" $glazewmConfig -Force
    Log-Success "GlazeWM config deployed to $glazewmConfig"
} catch {
    Log-Error "Failed to deploy GlazeWM config: $_"
}

# --- Zebar styles ---
Log-Info "Deploying Zebar styles..."

$zebarPackDir = Get-ChildItem "$env:APPDATA\zebar\downloads" -Directory -Filter "glzr-io.starter@*" `
    -ErrorAction SilentlyContinue | Select-Object -First 1

if ($zebarPackDir) {
    try {
        Copy-Item "$FILES_DIR\zebar\styles.css" "$($zebarPackDir.FullName)\styles.css" -Force
        Log-Success "Zebar styles deployed to $($zebarPackDir.FullName)"
    } catch {
        Log-Error "Failed to deploy Zebar styles: $_"
    }
} else {
    Log-Error "Zebar starter pack not found under $env:APPDATA\zebar\downloads. Run Zebar at least once before deploying configs."
}
