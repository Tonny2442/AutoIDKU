Write-Host "1903 Network Icon Replacement" -ForegroundColor Cyan

Start-BitsTransfer -Source 'https://github.com/Tonny2442/idkuauto/raw/main/utils/pnidui.dll' -Destination $workdir\pnidui.dll
Stop-Process -Name "explorer" -Force
takeown /f C:\windows\system32\pnidui.dll
icacls C:\windows\system32\pnidui.dll /grant Administrators:F
Rename-Item -Path C:\windows\system32\pnidui.dll -NewName pnidui.dll.backup
Copy-Item -Path $workdir\pnidui.dll -Destination 'C:\Windows\system32\pnidui.dll' -Force
Start-Sleep -Seconds 5
Start-Process "C:\Windows\explorer.exe"