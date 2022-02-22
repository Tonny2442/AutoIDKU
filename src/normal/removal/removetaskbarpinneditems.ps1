Write-Host -ForegroundColor Cyan "Remove pinned items from taskbar"
Stop-Process -Name "explorer" -Force 
Remove-Item "$env:appdata\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*" -Force -Recurse
Start-Process explorer.exe
Write-Host -ForegroundColor Cyan "Please unpin Microsoft Edge. Press Enter to continue."
Read-Host