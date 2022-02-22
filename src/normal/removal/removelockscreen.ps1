Write-Host "Remove lock screen" -ForegroundColor Cyan
takeown.exe /F C:\Windows\system32\Windows.UI.Logon.dll
icacls.exe C:\Windows\system32\Windows.UI.Logon.dll /grant Administrators:F
Rename-Item -LiteralPath "C:\Windows\system32\Windows.UI.Logon.dll" -NewName 'Windows.UI.Logon.dll.old'