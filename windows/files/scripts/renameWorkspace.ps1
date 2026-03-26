Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$glazewm = 'C:\Program Files\glzr.io\GlazeWM\cli\glazewm.exe'

$wsJson = (& $glazewm query workspaces) | ConvertFrom-Json
$ws     = $wsJson.data.workspaces | Where-Object { $_.hasFocus } | Select-Object -First 1
if (-not $ws) { exit }

$wsName    = $ws.name
$wsDisplay = if ($ws.displayName) { $ws.displayName } else { $ws.name }

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="RenameWorkspace"
    WindowStyle="None"
    AllowsTransparency="True"
    Background="Transparent"
    Topmost="True"
    WindowStartupLocation="CenterScreen"
    Width="400"
    SizeToContent="Height"
    ResizeMode="NoResize">
  <Window.Resources>
    <Style x:Key="Btn" TargetType="Button">
      <Setter Property="FontFamily"  Value="Iosevka Nerd Font, Segoe UI"/>
      <Setter Property="FontSize"    Value="11"/>
      <Setter Property="Padding"     Value="22,7"/>
      <Setter Property="Cursor"      Value="Hand"/>
      <Setter Property="Background"  Value="#cba6f7"/>
      <Setter Property="Foreground"  Value="#11111b"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="{TemplateBinding Background}"
                    CornerRadius="8" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Opacity" Value="0.82"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="BtnCancel" BasedOn="{StaticResource Btn}" TargetType="Button">
      <Setter Property="Background" Value="#313244"/>
      <Setter Property="Foreground" Value="#a6adc8"/>
    </Style>
  </Window.Resources>

  <Border Background="#181825" CornerRadius="14"
          BorderBrush="#cba6f7" BorderThickness="1.5"
          Padding="24,20,24,22">
    <StackPanel>
      <TextBlock x:Name="TitleLabel"
                 Foreground="#a6adc8"
                 FontFamily="Iosevka Nerd Font, Segoe UI"
                 FontSize="14"
                 Margin="0,0,0,14"/>

      <Border CornerRadius="8" BorderBrush="#cba6f7" BorderThickness="1.5" Margin="0,0,0,18">
        <TextBox x:Name="InputBox"
                 Background="#181825"
                 Foreground="#cdd6f4"
                 CaretBrush="#cba6f7"
                 SelectionBrush="#7c5fa8"
                 SelectionTextBrush="#cdd6f4"
                 FontFamily="Iosevka Nerd Font, Segoe UI"
                 FontSize="13"
                 BorderThickness="0"
                 Padding="12,9"
                 VerticalContentAlignment="Center"/>
      </Border>

      <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
        <Button x:Name="BtnOk"     Content="Rename" Style="{StaticResource Btn}"       Margin="0,0,8,0"/>
        <Button x:Name="BtnCancel" Content="Cancel" Style="{StaticResource BtnCancel}"/>
      </StackPanel>
    </StackPanel>
  </Border>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader($xaml)
$window = [System.Windows.Markup.XamlReader]::Load($reader)

$titleLabel = $window.FindName('TitleLabel')
$inputBox   = $window.FindName('InputBox')
$btnOk      = $window.FindName('BtnOk')
$btnCancel  = $window.FindName('BtnCancel')

$titleLabel.Text = "Rename workspace '$wsName'"
$inputBox.Text   = $wsDisplay

$script:confirmed = $false

$window.Add_KeyDown({
    if ($_.Key -eq [System.Windows.Input.Key]::Return) { $script:confirmed = $true; $window.Close() }
    if ($_.Key -eq [System.Windows.Input.Key]::Escape) { $window.Close() }
})
$btnOk.Add_Click({     $script:confirmed = $true; $window.Close() })
$btnCancel.Add_Click({ $window.Close() })
$window.Add_Deactivated({ $window.Close() })
$window.Add_Loaded({
    $inputBox.Focus()
    $inputBox.CaretIndex = $inputBox.Text.Length
})

$window.ShowDialog() | Out-Null

if ($script:confirmed) {
    $newName = $inputBox.Text.Trim()
    if ($newName) {
        & $glazewm command update-workspace-config --workspace $wsName --display-name $newName
    }
}
