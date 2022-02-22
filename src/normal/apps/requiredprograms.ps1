Write-Host "Install Winaero Tweaker, OpenShell, AutoHotKey, and T-Clock" -ForegroundColor Cyan

$dl1 = "https://github.com/Open-Shell/Open-Shell-Menu/releases/download/v4.4.160/OpenShellSetup_4_4_160.exe"
$dl2 = "https://winaerotweaker.com/download/winaerotweaker.zip"
$dl3 = "https://github.com/Lexikos/AutoHotkey_L/releases/download/v1.1.33.10/AutoHotkey_1.1.33.10_setup.exe"
$dl4 = "https://github.com/White-Tiger/T-Clock/releases/download/v2.4.4%23492-rc/T-Clock.zip"
$dl5 = "https://github.com/Tonny2442/idkuauto/raw/main/utils/tclock.reg"

Start-BitsTransfer -Source $dl1 -Destination $workdir\openshellinstaller.exe 
Start-BitsTransfer -Source $dl2 -Destination $workdir\winaero.zip 
Start-BitsTransfer -Source $dl3 -Destination $workdir\ahksetup.exe
Start-BitsTransfer -Source $dl4 -Destination $workdir\tclock.zip
Start-BitsTransfer -Source $dl5 -Destination $workdir\tclock.reg

New-Item -Path $env:USERPROFILE -Name "tclock" -ItemType Directory

Expand-Archive -Path $workdir\winaero.zip -DestinationPath $workdir 
Expand-Archive -Path $workdir\tclock.zip -DestinationPath $env:USERPROFILE\tclock

Start-Process $workdir\openshellinstaller.exe -Wait -NoNewWindow -ArgumentList "/qn ADDLOCAL=StartMenu"
Start-Process "$workdir\WinaeroTweaker-1.33.0.0-setup.exe" -Wait -NoNewWindow -ArgumentList "/SP- /VERYSILENT"
Start-Process $workdir\ahksetup.exe -Wait -NoNewWindow -ArgumentList "/S"

reg.exe import $workdir\tclock.reg

$WScriptObj = New-Object -ComObject ("WScript.Shell")
$tclock = "$env:USERPROFILE\tclock\Clock64.exe"
$ShortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\tclock.lnk"
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $tclock
$shortcut.WindowStyle = 1
$shortcut.Save()