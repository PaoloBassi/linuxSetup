If WScript.Arguments.Count > 0 Then
    WScript.CreateObject("WScript.Shell").Run _
        "powershell -NonInteractive -NoProfile -WindowStyle Hidden -File """ & WScript.Arguments(0) & """", _
        0, False
End If
