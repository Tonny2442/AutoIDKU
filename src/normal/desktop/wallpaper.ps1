


Write-Host "Set Wallpaper" -ForegroundColor Cyan
Start-BitsTransfer -Source 'https://github.com/Tonny2442/idkuauto/raw/main/utils/background.png' -Destination $workdir\background.png
Set-WallPaper -Image $workdir\background.png