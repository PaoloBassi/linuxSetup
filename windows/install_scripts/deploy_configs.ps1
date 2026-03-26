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

# --- Wallpaper ---
Log-Info "Deploying wallpaper..."

$picturesDir = "$env:USERPROFILE\Pictures"
if (-not (Test-Path $picturesDir)) {
    New-Item -ItemType Directory -Path $picturesDir -Force | Out-Null
}

try {
    $wallpaperDest = "$picturesDir\catpuccinWallpaper.jpg"
    Copy-Item "$FILES_DIR\wallpaper\catpuccinWallpaper.jpg" $wallpaperDest -Force
    Add-Type @'
using System; using System.Runtime.InteropServices;
public class W {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int SystemParametersInfo(int a, int b, string c, int d);
}
'@
    [W]::SystemParametersInfo(20, 0, $wallpaperDest, 3) | Out-Null
    Log-Success "Wallpaper set to $wallpaperDest"
} catch {
    Log-Error "Failed to set wallpaper: $_"
}

# --- Custom scripts ---
Log-Info "Deploying custom scripts..."

$scriptsDir = "$env:USERPROFILE\scripts"
if (-not (Test-Path $scriptsDir)) {
    New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
}

try {
    Copy-Item "$FILES_DIR\scripts\toggleGaps.ps1" "$scriptsDir\toggleGaps.ps1" -Force
    Log-Success "toggleGaps.ps1 deployed to $scriptsDir"
} catch {
    Log-Error "Failed to deploy toggleGaps.ps1: $_"
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
