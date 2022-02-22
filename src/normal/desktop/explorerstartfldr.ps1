Write-Host -ForegroundColor Cyan "Set Explorer to open on This PC"
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -Value 1 -Type DWord -Force
Start-Sleep -Seconds 1
Stop-Process -Name "explorer"
Start-Sleep -Seconds 1
Start-Process "explorer.exe"