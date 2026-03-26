$configPath = "$env:USERPROFILE\.glzr\glazewm\config.yaml"
$glazewmCli = "C:\Program Files\glzr.io\GlazeWM\cli\glazewm.exe"

$content = Get-Content $configPath -Raw

$outerPattern = "(outer_gap:\r?\n\s+top: )'\d+px'(\r?\n\s+right: )'\d+px'(\r?\n\s+bottom: )'\d+px'(\r?\n\s+left: )'\d+px'"

if ($content -match "inner_gap: '0px'") {
    $content = $content -replace "inner_gap: '0px'", "inner_gap: '10px'"
    $content = $content -replace $outerPattern, "`${1}'50px'`${2}'10px'`${3}'10px'`${4}'10px'"
} else {
    $content = $content -replace "inner_gap: '\d+px'", "inner_gap: '0px'"
    $content = $content -replace $outerPattern, "`${1}'40px'`${2}'0px'`${3}'0px'`${4}'0px'"
}

Set-Content $configPath $content -NoNewline
& $glazewmCli command wm-reload-config
