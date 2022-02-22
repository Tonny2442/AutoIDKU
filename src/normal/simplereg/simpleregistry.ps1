switch ($true) {
    $applookupinstore {
        Write-Host -ForegroundColor Cyan "Disabling App Lookup in Microsoft Store"
        $ifexist = (Test-Path -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer')
        if ($ifexist -eq $false) {New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name "Explorer" -ItemType Directory}
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name "NoUseStoreOpenWith" -Value 1 -Type DWord -Force
    }

    $removequickaccess {
        Write-Host "Remove Quick Access"
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'HubMode' -Value 1 -Type DWord -Force
    }

    {$disablestartupitems -eq $true -and $build -ge 14393} {
        Write-Host "Disable Windows Defender on startup" -ForegroundColor Cyan
        Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run' -Name 'SecurityHealth' -Value ([byte[]](0x33,0x32,0xFF))
    }

    $disablenotifs {
        Write-Host -ForegroundColor Cyan "Disable Notifications" 
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'ToastEnabled' -Value 0 -Type DWord -Force
    }

    {$disablegamebar -eq $true -and $build -ge 15063} {
        Write-Host -ForegroundColor Cyan "Disable Game Bar"
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -Value 0 -Type DWord -Force
    }

    $disableautoplay {
        Write-Host -ForegroundColor Cyan "Disable AutoPlay"
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoDriveTypeAutoRun' -Value 255 -Type DWord -Force
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers' -Name 'DisableAutoplay' -Value 1 -Type DWord -Force
    }

    $disablemultitaskbar {
        Write-Host -ForegroundColor Cyan "Disable Multi-monitor taskbar"
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'MMTaskbarEnabled' -Value 0 -Type DWord -Force
    }

    $transparencydisable {
        Write-Host -ForegroundColor Cyan "Disable Transparency"
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'EnableTransparency' -Value 0 -Type DWord -Force
    }

    {$disablewinink -eq $true -and $build -ge 14393} {
        Write-Host -ForegroundColor Cyan "Disable Windows Ink Workspace"
        New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft' -Name 'WindowsInkWorkspace' -Force
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace' -Name 'AllowWindowsInkWorkspace' -Value 0 -Type DWord -Force
    }

    $removedownloads {
        Write-Host -ForegroundColor Cyan "Remove Downloads Folder"
        Write-Host "WARNING! Your downloads folder is going to be DELETED as you specified. Press Enter to continue." -ForegroundColor Red
        Read-Host
        Remove-Item -Path "$env:USERPROFILE\Downloads" -Force -Recurse
        Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}' -Force
        Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}' -Force 
        Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}' -Force
        Remove-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}' -Force
    }

    {$classicpaint -eq $true -and $build -ge 15063} {
        Write-Host -ForegroundColor Cyan "Enabling Classic Paint"
        New-item -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Applets\Paint' -Name "Settings"
        Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Applets\Paint' -Name "DisableModernPaintBootstrap" -Value 1 -Type DWord -Force
    }

    $contextmenuentries {
        New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
        Remove-Item -LiteralPath "HKCR:\*\ShellEx\ContextMenuHandlers\ModernSharing" -Force -Recurse
        Remove-Item -Path "HKCR:\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" -Force -Recurse
    }

    $disableanimations {
        Write-Host -ForegroundColor Cyan "Disable Animations"
        Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Type String -Value '0'
    }

    {$remove3Dobjects -eq $true -and $build -ge 16299} {
        Write-Host -ForegroundColor Cyan "Remove 3D Objects from This PC"
        Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}' -Force
    }

    $defaultcolor {
        Write-Host -ForegroundColor Cyan "Set default color to Default Blue"
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'AccentColor' -Value 4292311040 -Type DWord -Force
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'ColorizationAfterglow' -Value 3288365271 -Type DWord -Force
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'ColorizationColor' -Value 3288365271 -Type DWord -Force
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\DWM' -Name 'ColorPrevalence' -Value 0 -Type DWord -Force
    }

    $hidebluetoothicon {
        Write-Host -ForegroundColor Cyan "Hide Bluetooth Icon"
        Set-ItemProperty -Path 'HKCU:\Control Panel\Bluetooth' -Name 'Notification Area Icon' -Value 0 -Type DWord -Force
    }

    $activatephotoviewer {
        Write-Host -ForegroundColor Cyan "Activate Windows Photo Viewer"
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".bmp" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".dib" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".gif" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jfif" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jpe" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jpeg" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jpg" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".jxr" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".png" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".tif" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations' -Name ".tiff" -Value "PhotoViewer.FileAssoc.Tiff" -Type String -Force
    }

    $registeredowner {
        Write-Host -ForegroundColor Cyan "Set Registered owner"
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'RegisteredOwner' -Value 'IDKU' -Type String -Force
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'RegisteredOrganization' -Value 'AutoIDKU' -Type String -Force
    }

    $disableedgeprelaunch {
        Write-Host -ForegroundColor Cyan "Disable Edge Prelaunch"
        New-Item -Path 'HKCU:\SOFTWARE\Policies\Microsoft' -Name 'MicrosoftEdge' -Force
        New-Item -Path 'HKCU:\SOFTWARE\Policies\Microsoft\MicrosoftEdge' -Name 'Main' -Force
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\MicrosoftEdge' -Name 'AllowPrelaunch' -Value 0 -Type DWord -Force
    }

    $disablecortana {
        Write-Host -ForegroundColor Cyan "Disable Cortana"
        New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Windows Search'
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -Value 0 -Type DWord -Force
    }

    $disablestoreautoupd {
        Write-Host -ForegroundColor Cyan "Disable Microsoft Store Automatic App Updates"
        New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft' -Name 'WindowsStore'
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore' -Name 'AutoDownload' -Value 2 -Type DWord -Force
    }

    $oldvolcontrol {
        Write-Host -ForegroundColor Cyan "Enable old volume control"
        New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'MTCUVC'
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC' -Name 'EnableMtcUvc' -Value 0 -Type DWord -Force
    }

    $balloonnotifs {
        Write-Host -ForegroundColor Cyan "Enable Balloon notificatons"
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'EnableLegacyBalloonNotifications' -Value 1 -Type DWord -Force
    }

    $disablelockscrn {
        Write-Host -ForegroundColor Cyan "Disable Lock Screen"
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData' -Name 'AllowLockScreen' -Value 0 -Type DWord -Force
    }

    $darkmodeoff {
        Write-Host -ForegroundColor Cyan "Disable App Dark Mode"
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value 1 -Type DWord -Force
    }

    $classicalttab {
        Write-Host -ForegroundColor Cyan "Enable Classic Alt+Tab"
        Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'AltTabSettings' -Value 1 -Type DWord -Force
    }

    $disableuac {
        Write-Host -ForegroundColor Cyan "Disabling UAC"
        Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name ConsentPromptBehaviorAdmin -Value 0
    }

    $disablelocationicon {
        Write-Host -ForegroundColor Cyan "Disabling the Location icon"
        Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -Name Value -Value "Deny" -Type String -Force
    }

    $disablelogonbg {
        Write-Host -ForegroundColor Cyan "Disabling login screen background image"
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name "DisableLogonBackgroundImage" -Value 1 -Type DWord -Force
    }

    $svchostslimming {
        Write-Host -ForegroundColor Cyan "Setting svchost.exe max ram"
        $svchostvalue = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1kb
        Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name "SvcHostSplitThresholdInKB" -Value $svchostvalue -Type DWord -Force
    }
}