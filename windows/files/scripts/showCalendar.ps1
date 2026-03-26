Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text            = "CalendarPopup"
$form.StartPosition   = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.BackColor       = [System.Drawing.ColorTranslator]::FromHtml("#11111b")
$form.TopMost         = $true
$form.KeyPreview      = $true
$form.Add_KeyDown({ if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Escape) { $form.Close() } })
$form.Add_Deactivate({ $form.Close() })

$cal = New-Object System.Windows.Forms.MonthCalendar
$cal.Location          = New-Object System.Drawing.Point(0, 0)
$cal.MaxSelectionCount = 1
$cal.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#313244")
$cal.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#cdd6f4")
$cal.TitleBackColor    = [System.Drawing.ColorTranslator]::FromHtml("#cba6f7")
$cal.TitleForeColor    = [System.Drawing.ColorTranslator]::FromHtml("#1e1e2e")
$cal.TrailingForeColor = [System.Drawing.ColorTranslator]::FromHtml("#585b70")
$form.Controls.Add($cal)
$form.ClientSize = $cal.Size

$form.ShowDialog() | Out-Null
