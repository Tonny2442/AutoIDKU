Write-Host "Install ShareX 13.1.0" -ForegroundColor Cyan
Start-BitsTransfer -Source 'https://github.com/ShareX/ShareX/releases/download/v13.1.0/ShareX-13.1.0-setup.exe' -Destination $workdir\sharex462.exe
Start-Process $workdir\sharex462.exe -NoNewWindow -ArgumentList "/SILENT"
Write-Host "Waiting 10 seconds for ShareX to install..." -ForegroundColor Cyan
Start-Sleep -Seconds 10