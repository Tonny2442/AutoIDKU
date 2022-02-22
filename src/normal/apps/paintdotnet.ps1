Write-Host "Install Paint.NET 4.0.19" -ForegroundColor Cyan
Start-BitsTransfer -Source 'https://github.com/Tonny2442/idkuauto/raw/main/utils/paintdotnet462.exe' -Destination $workdir\paintdotnet462.exe
Start-Process $workdir\paintdotnet462.exe -NoNewWindow -Wait -ArgumentList "/AUTO"