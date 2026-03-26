Add-Type @"
using System.Runtime.InteropServices;
public class KeySend {
    [DllImport("user32.dll")]
    public static extern void keybd_event(byte vk, byte scan, uint flags, System.UIntPtr extra);
}
"@
[KeySend]::keybd_event(0x5B, 0, 0, [System.UIntPtr]::Zero)
[KeySend]::keybd_event(0x5B, 0, 2, [System.UIntPtr]::Zero)
