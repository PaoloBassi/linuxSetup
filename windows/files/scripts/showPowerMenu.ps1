Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$crust    = [System.Drawing.ColorTranslator]::FromHtml('#11111b')
$mantle   = [System.Drawing.ColorTranslator]::FromHtml('#181825')
$surf0    = [System.Drawing.ColorTranslator]::FromHtml('#313244')
$surf1    = [System.Drawing.ColorTranslator]::FromHtml('#45475a')
$blue     = [System.Drawing.ColorTranslator]::FromHtml('#89b4fa')
$subtext  = [System.Drawing.ColorTranslator]::FromHtml('#a6adc8')

$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds

$script:closing = $false

$form = New-Object System.Windows.Forms.Form
$form.Text            = 'PowerMenu'
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.Bounds          = $screen
$form.BackColor       = $crust
$form.Opacity         = 0.92
$form.TopMost         = $true
$form.KeyPreview      = $true
$form.Add_KeyDown({
    if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Escape) {
        $script:closing = $true; $form.Close()
    }
})
$form.Add_Click({ if (-not $script:closing) { $script:closing = $true; $form.Close() } })
$form.Add_Deactivate({ if (-not $script:closing) { $script:closing = $true; $form.Close() } })

# --- Center panel ---
$btnW = 90; $btnH = 90; $gap = 16; $count = 4
$padX = 32; $padY = 28
$panelW = $count * $btnW + ($count - 1) * $gap + 2 * $padX
$panelH = $btnH + 2 * $padY

$panel = New-Object System.Windows.Forms.Panel
$panel.BackColor = $mantle
$panel.Size      = New-Object System.Drawing.Size($panelW, $panelH)
$panel.Location  = New-Object System.Drawing.Point(
    [int](($screen.Width  - $panelW) / 2),
    [int](($screen.Height - $panelH) / 2)
)

$r = 16
$gp = New-Object System.Drawing.Drawing2D.GraphicsPath
$gp.AddArc(0, 0, $r*2, $r*2, 180, 90)
$gp.AddArc($panelW - $r*2, 0, $r*2, $r*2, 270, 90)
$gp.AddArc($panelW - $r*2, $panelH - $r*2, $r*2, $r*2, 0, 90)
$gp.AddArc(0, $panelH - $r*2, $r*2, $r*2, 90, 90)
$gp.CloseFigure()
$panel.Region = New-Object System.Drawing.Region($gp)

# --- Action items ---
$items = @(
    [pscustomobject]@{ icon = [char]0xE72E; label = 'lock';     action = 'lock'     }
    [pscustomobject]@{ icon = [char]0xE946; label = 'sleep';    action = 'sleep'    }
    [pscustomobject]@{ icon = [char]0xE72C; label = 'restart';  action = 'restart'  }
    [pscustomobject]@{ icon = [char]0xE7E8; label = 'shutdown'; action = 'shutdown' }
)

$clickHandler = {
    param($sender, $e)
    $ctrl = $sender
    while ($ctrl -ne $null -and $ctrl.Tag -eq $null) { $ctrl = $ctrl.Parent }
    if ($ctrl -ne $null) {
        $script:closing = $true
        $form.Close()
        switch ($ctrl.Tag) {
            'lock'     { Start-Process rundll32 -ArgumentList 'user32.dll,LockWorkStation' -WindowStyle Hidden }
            'sleep'    {
                Add-Type -AssemblyName System.Windows.Forms
                [System.Windows.Forms.Application]::SetSuspendState(
                    [System.Windows.Forms.PowerState]::Suspend, $false, $false) | Out-Null
            }
            'restart'  { Start-Process cmd -ArgumentList '/c shutdown /r /t 0' -WindowStyle Hidden }
            'shutdown' { Start-Process cmd -ArgumentList '/c shutdown /s /t 0' -WindowStyle Hidden }
        }
    }
}

$hoverEnter = {
    param($sender, $e)
    $ctrl = $sender
    while ($ctrl -ne $null -and $ctrl.Tag -eq $null) { $ctrl = $ctrl.Parent }
    if ($ctrl) { $ctrl.BackColor = [System.Drawing.ColorTranslator]::FromHtml('#45475a'); $ctrl.Invalidate($true) }
}
$hoverLeave = {
    param($sender, $e)
    $ctrl = $sender
    while ($ctrl -ne $null -and $ctrl.Tag -eq $null) { $ctrl = $ctrl.Parent }
    if ($ctrl) { $ctrl.BackColor = [System.Drawing.ColorTranslator]::FromHtml('#313244'); $ctrl.Invalidate($true) }
}

for ($i = 0; $i -lt $items.Count; $i++) {
    $item = $items[$i]
    $x = $padX + $i * ($btnW + $gap)

    $btn = New-Object System.Windows.Forms.Panel
    $btn.Size      = New-Object System.Drawing.Size($btnW, $btnH)
    $btn.Location  = New-Object System.Drawing.Point($x, $padY)
    $btn.BackColor = $surf0
    $btn.Cursor    = [System.Windows.Forms.Cursors]::Hand
    $btn.Tag       = $item.action

    $br = 12
    $bp = New-Object System.Drawing.Drawing2D.GraphicsPath
    $bp.AddArc(0, 0, $br*2, $br*2, 180, 90)
    $bp.AddArc($btnW - $br*2, 0, $br*2, $br*2, 270, 90)
    $bp.AddArc($btnW - $br*2, $btnH - $br*2, $br*2, $br*2, 0, 90)
    $bp.AddArc(0, $btnH - $br*2, $br*2, $br*2, 90, 90)
    $bp.CloseFigure()
    $btn.Region = New-Object System.Drawing.Region($bp)

    $iconLbl = New-Object System.Windows.Forms.Label
    $iconLbl.Text      = $item.icon
    $iconLbl.Font      = New-Object System.Drawing.Font('Segoe MDL2 Assets', 22)
    $iconLbl.ForeColor = $blue
    $iconLbl.AutoSize  = $false
    $iconLbl.Size      = New-Object System.Drawing.Size($btnW, 52)
    $iconLbl.Location  = New-Object System.Drawing.Point(0, 6)
    $iconLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $iconLbl.BackColor = [System.Drawing.Color]::Transparent

    $textLbl = New-Object System.Windows.Forms.Label
    $textLbl.Text      = $item.label
    $textLbl.Font      = New-Object System.Drawing.Font('Segoe UI', 8)
    $textLbl.ForeColor = $subtext
    $textLbl.AutoSize  = $false
    $textLbl.Size      = New-Object System.Drawing.Size($btnW, 22)
    $textLbl.Location  = New-Object System.Drawing.Point(0, 60)
    $textLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $textLbl.BackColor = [System.Drawing.Color]::Transparent

    $btn.Controls.Add($iconLbl)
    $btn.Controls.Add($textLbl)

    foreach ($ctrl in @($btn, $iconLbl, $textLbl)) {
        $ctrl.Add_Click($clickHandler)
        $ctrl.Add_MouseEnter($hoverEnter)
        $ctrl.Add_MouseLeave($hoverLeave)
    }

    $panel.Controls.Add($btn)
}

$form.Controls.Add($panel)
$form.ShowDialog() | Out-Null
