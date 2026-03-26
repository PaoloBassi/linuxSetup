# Initialize globals only once (safe to dot-source multiple times)
if ($null -eq $global:ErrorCounter) { $global:ErrorCounter = 0 }
if ($null -eq $global:LOG_FILE) {
    $global:LOG_FILE = "$env:TEMP\windows_setup_$(Get-Date -Format 'yyyyMMddHHmmss').log"
}
if ($null -eq $global:VERBOSE) { $global:VERBOSE = $false }

function Log-Info($msg)    { Write-Host $msg -ForegroundColor Yellow }
function Log-Error($msg)   { Write-Host "x $msg" -ForegroundColor Red; $global:ErrorCounter++ }
function Log-Success($msg) { Write-Host "v $msg" -ForegroundColor Green }

function Invoke-Step {
    param([string]$Label, [scriptblock]$Block)
    Log-Info "$Label..."
    try {
        if ($global:VERBOSE) {
            & $Block
        } else {
            & $Block 2>&1 | Out-File -Append $global:LOG_FILE
        }
        if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) { throw "exit code $LASTEXITCODE" }
        Log-Success $Label
    } catch {
        Log-Error "$Label`: $_"
    }
}
