Write-Host -ForegroundColor Cyan "Set Explorer icon to 1903+"
Start-BitsTransfer -Source 'https://github.com/Tonny2442/idkuauto/raw/main/utils/explorer.zip' -Destination $workdir\explorer.zip
Start-BitsTransfer -Source 'https://github.com/Tonny2442/idkuauto/raw/main/utils/explorer.ico' -Destination C:\Windows\explorer.ico
Expand-Archive -Path $workdir\explorer.zip -DestinationPath $workdir 
Copy-Item -Path $workdir\explorer.lnk -Destination "$env:appdata\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk"