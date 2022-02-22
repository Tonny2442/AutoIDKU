##[Ps1 To Exe]
##
##NcDBCIWOCzWE8paP3wFk4Fn9fmQkY8CPhZKox5Sx+uT4qBnPWpkbTVFLvw3XMWqoTf0uRucWiN8eRxArI5I=
##NcDBCIWOCzWE8paP3wFk4Fn9fmQkY8CPhZKox5Sx+uT4qBnPWpkbTVFLvw3XMWqoTf0uRucWiMISRxQ6O5I=
##NcDBCIWOCzWE8paP3wFk4Fn9fmQkY8CPhZKox5Sx+uT4qBnPWpkbTVFLvw3XMWqoTf0uRucWiMYeRxYuJuBr
##Kd3HDZOFADWE8uO1
##Nc3NCtDXTlGDjofG5iZk2UfhT20/UuGUuqOqwY+o7Nb6qCbWTZ8oYHBcowjpEESBTOYbWeYpvdIeW1MjLP1r
##Kd3HFJGZHWLWoLaVvnQnhQ==
##LM/RF4eFHHGZ7/K1
##K8rLFtDXTiS5
##OsHQCZGeTiiZ4NI=
##OcrLFtDXTiS5
##LM/BD5WYTiiZ4tI=
##McvWDJ+OTiiZ4tI=
##OMvOC56PFnzN8u+Vs1Q=
##M9jHFoeYB2Hc8u+Vs1Q=
##PdrWFpmIG2HcofKIo2QX
##OMfRFJyLFzWE8uK1
##KsfMAp/KUzWJ0g==
##OsfOAYaPHGbQvbyVvnQX
##LNzNAIWJGmPcoKHc7Do3uAuO
##LNzNAIWJGnvYv7eVvnQX
##M9zLA5mED3nfu77Q7TV64AuzAgg=
##NcDWAYKED3nfu77Q7TV64AuzAgg=
##OMvRB4KDHmHQvbyVvnQX
##P8HPFJGEFzWE8tI=
##KNzDAJWHD2fS8u+Vgw==
##P8HSHYKDCX3N8u+Vgw==
##LNzLEpGeC3fMu77Ro2k3hQ==
##L97HB5mLAnfMu77Ro2k3hQ==
##P8HPCZWEGmaZ7/K1
##L8/UAdDXTlGDjofG5iZk2UfhT20/UuGUuqOqwY+o7Nb6qCbWTZ8oYHBcowjpEESBW/scadQAoN44cTYfb+RbrOaeSamsXadq
##Kc/BRM3KXxU=
##
##
##fd6a9f26a06ea3bc99616d4851b372ba
### IDKU Automatic Configuration Script
Set-ExecutionPolicy unrestricted

# Set Working Directory
$workdir = "$PSScriptRoot\..\workdir"

# Create Registry Folder
$autoidku = Test-Path -Path 'HKCU:\SOFTWARE\AutoIDKU'
if ($autoidku -eq $false) {New-Item -Path 'HKCU:\SOFTWARE' -Name AutoIDKU}

### ------ System Variables ------
Write-Host -ForegroundColor Cyan "Finding your Windows Build and your update build revision"

$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
$ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR
$battery = (Get-WmiObject Win32_Battery)

if ($build -le 17134 -and $build -ge 10240) {
    $tls1 = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319').SchUseStrongCrypto
    $tls2 = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319').SchUseStrongCrypto
    if ($tls1 -eq 0 -or $tls2 -eq 0 -or $null -eq $tls1 -or $null -eq $tls2) {
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
        Write-Host -ForegroundColor Green "This version of Windows requires certain TLS settings. Please restart the script for them to take effect. Enter to exit."
        Read-Host
        exit
    }
}

### ------ Import Required Dependencies ------
Write-Host -ForegroundColor Cyan "Importing required modules"

Install-PackageProvider -Name "NuGet" -Verbose -Force

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

Add-Type -AssemblyName presentationCore

switch ($build) {
    10240 {
        Invoke-Expression (new-object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/PrateekKumarSingh/MusicPlayer/master/Install.ps1')
    }
    {$_ -ge 10240} {
        $pendingreboot = (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending')
        if ($pendingreboot -eq $true -and $build -ge 10240) {
            Write-Host -ForegroundColor Cyan "Your PC has a pending restart. You have to restart before running this script. Enter to exit."
            Read-Host
            exit
        }
    Install-Module MusicPlayer -scope CurrentUser -Verbose -Repository 'PSGallery'
    Import-Module MusicPlayer -Verbose
    }
    {$_ -ge 15063} {
        Install-Module PSWindowsUpdate
        Import-Module PSWindowsUpdate -Verbose
    }
}

Import-Module BitsTransfer -Verbose

##### -----PreChecks------######

# Your version must be between 10240 and 19044. If it is not, not supported.
Write-Host -ForegroundColor Cyan "Determining your Windows Build"
switch ($build) {
    {$_ -ge 10240 -and $_ -le 19044} {Write-Host "Supported version of Windows 10 detected" -ForegroundColor Green}
    default {
        Write-Host "You're not running a supported version of Windows for this script." -ForegroundColor Red
        Write-Host "Press Enter to exit" -ForegroundColor Red
        Read-Host
        exit
    }
}

Write-Host "You're running Windows 10"$build"."$ubr

# If you're running something less than 1703, then you cannot use PSWindowsUpdate.
if ($build -lt 15063) {
    Write-Host -ForegroundColor Cyan "Your build does not support Windows Update through PowerShell. Have you fully updated yet? (yes/no)"
    $fullyupdated = Read-Host
    switch ($fullyupdated) {
        {$fullyupdated -like "yes"} {
            Write-Host -ForegroundColor Cyan "Alright, we will PROCEED."
        }
        {$fullyupdated -like "no"} {
            Write-Host -ForegroundColor Cyan "Then the script fell into darkness."
            Start-Sleep -Seconds 4
            exit
        }
        {$fullyupdated -like '*fuck*'} {
            Write-Host -ForegroundColor Red "No need to swear at me. HAVE YOU FUCKING UPDATED IT?"
            Start-Sleep -Seconds 2
            exit
        }
    }
}

###############################################################
### ------- MODIFYABLE VARIABLES -------

# This section is for changing what you want the script to do.
# Please only modify this if you know what you're doing!

$setupmusic =           $true

$requiredprograms =     $true
$hidetaskbaricons =     $true
$replaceneticon =       $true
$removeedge =           $true
$windowsupdate =        $true
$setwallpaper =         $true
$dotnet35 =             $true 
$dotnet462 =            $true
$sharex462 =            $true
$paintdotnet462 =       $true 
$desktopshortcuts =     $true 
#$removelockscreen =    $true 
$removeudpassistant =   $true 
$removewaketimers =     $true 
$deleteWU =             $true 
$removeUWPapps =        $true 
$openshellconfig =      $true 
$explorericon =         $true
$classicapps =          $true 
$taskbarpins =          $true
$removeemojifont =      $true 
$defaultapps =          $true 
$disablesettings =      $true 
$blockapps =            $true 
$gpomodifs =            $true 
$fixthispcdetails =     $true
$disableaddressbar =    $true
$removeonedrive =       $true
$removehomegroup =      $true
$disabledefender =      $true 
$explorerstartfldr =    $true 
$netflyoutwin8 =        $true 
$oldbatteryflyout =     $true 
$customsounds =         $true

# Below are registry-applied tweaks. You can disable all of them,
# or you can disable a specific one.

$registrytweaks =       $true 

$disablestartupitems =  $true
$disablenotifs =        $true 
$disablegamebar =       $true 
$disableautoplay =      $true 
$disablemultitaskbar =  $true
$transparencydisable =  $true 
$disableanimations =    $true 
$disablewinink =        $true 
$removedownloads =      $true 
$applookupinstore =     $true
$contextmenuentries =   $true
$1709peoplebar =        $true
$1511locationicon =     $true
$removequickaccess =    $true
$disablelocationicon =  $true 
$disableuac =           $true
$activatephotoviewer =  $true 
$registeredowner =      $true 
$classicpaint =         $true 
$disableedgeprelaunch = $true
$disablecortana =       $true 
$disablestoreautoupd =  $true
$balloonnotifs =        $true 
$disablelockscrn =      $true
$darkmodeoff =          $true 
$classicalttab =        $true
$oldvolcontrol =        $true
$defaultcolor =         $true
$remove3Dobjects =      $true
$hidebluetoothicon =    $true
$disablelogonbg =       $true

##############################################################

### ------- Functions ------
Write-Host -ForegroundColor Cyan "Importing Functions"
Function Set-WallPaper($Image) {
Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}

function Take-Permissions {
    # Developed for PowerShell v4.0
    # Required Admin privileges
    # Links:
    #   http://shrekpoint.blogspot.ru/2012/08/taking-ownership-of-dcom-registry.html
    #   http://www.remkoweijnen.nl/blog/2012/01/16/take-ownership-of-a-registry-key-in-powershell/
    #   https://powertoe.wordpress.com/2010/08/28/controlling-registry-acl-permissions-with-powershell/

    param($rootKey, $key, [System.Security.Principal.SecurityIdentifier]$sid = 'S-1-5-32-545', $recurse = $true)

    switch -regex ($rootKey) {
        'HKCU|HKEY_CURRENT_USER'    { $rootKey = 'CurrentUser' }
        'HKLM|HKEY_LOCAL_MACHINE'   { $rootKey = 'LocalMachine' }
        'HKCR|HKEY_CLASSES_ROOT'    { $rootKey = 'ClassesRoot' }
        'HKCC|HKEY_CURRENT_CONFIG'  { $rootKey = 'CurrentConfig' }
        'HKU|HKEY_USERS'            { $rootKey = 'Users' }
    }

    ### Step 1 - escalate current process's privilege
    # get SeTakeOwnership, SeBackup and SeRestore privileges before executes next lines, script needs Admin privilege
    $import = '[DllImport("ntdll.dll")] public static extern int RtlAdjustPrivilege(ulong a, bool b, bool c, ref bool d);'
    $ntdll = Add-Type -Member $import -Name NtDll -PassThru
    $privileges = @{ SeTakeOwnership = 9; SeBackup =  17; SeRestore = 18 }
    foreach ($i in $privileges.Values) {
        $null = $ntdll::RtlAdjustPrivilege($i, 1, 0, [ref]0)
    }

    function Take-KeyPermissions {
        param($rootKey, $key, $sid, $recurse, $recurseLevel = 0)

        ### Step 2 - get ownerships of key - it works only for current key
        $regKey = [Microsoft.Win32.Registry]::$rootKey.OpenSubKey($key, 'ReadWriteSubTree', 'TakeOwnership')
        $acl = New-Object System.Security.AccessControl.RegistrySecurity
        $acl.SetOwner($sid)
        $regKey.SetAccessControl($acl)

        ### Step 3 - enable inheritance of permissions (not ownership) for current key from parent
        $acl.SetAccessRuleProtection($false, $false)
        $regKey.SetAccessControl($acl)

        ### Step 4 - only for top-level key, change permissions for current key and propagate it for subkeys
        # to enable propagations for subkeys, it needs to execute Steps 2-3 for each subkey (Step 5)
        if ($recurseLevel -eq 0) {
            $regKey = $regKey.OpenSubKey('', 'ReadWriteSubTree', 'ChangePermissions')
            $rule = New-Object System.Security.AccessControl.RegistryAccessRule($sid, 'FullControl', 'ContainerInherit', 'None', 'Allow')
            $acl.ResetAccessRule($rule)
            $regKey.SetAccessControl($acl)
        }

        ### Step 5 - recursively repeat steps 2-5 for subkeys
        if ($recurse) {
            foreach($subKey in $regKey.OpenSubKey('').GetSubKeyNames()) {
                Take-KeyPermissions $rootKey ($key+'\'+$subKey) $sid $recurse ($recurseLevel+1)
            }
        }
    }
Take-KeyPermissions $rootKey $key $sid $recurse
}

##################### Begin Script ###########################
switch ($true) {
    default {
        Write-Host "You did not select anything to do. Press enter to exit" -ForegroundColor Red
        Read-Host
    }

    $setupmusic {
        & $PSScriptRoot\..\script\main\setupmusic.ps1
    }

    $setwallpaper {
        & $PSScriptRoot\..\normal\desktop\wallpaper.ps1
    }

    {$windowsupdate -eq $true -and $build -ge 15063} {
        & $PSScriptRoot\..\script\main\windowsupdate.ps1
    }

    $hidetaskbaricons {
        & $PSScriptRoot\..\normal\taskbar\hidetaskbaricons.ps1
    }

    {$replaceneticon -eq $true -and $build -ge 18362} {
        & $PSScriptRoot\..\normal\taskbar\1903neticon.ps1
    }

    $removeonedrive {
        & $PSScriptRoot\..\normal\removal\removeonedrive.ps1
    }  

    {$removehomegroup -eq $true -and $build -lt 17134} {
        & $PSScriptRoot\..\normal\removal\removehomegroup.ps1
    }

    $desktopshortcuts {
        & $PSScriptRoot\..\normal\desktop\desktopshortcuts.ps1
    }

    $dotnet462 {
        & $PSScriptRoot\..\normal\apps\dotnet462install.ps1
    }

    $requiredprograms {
        & $PSScriptRoot\..\normal\apps\requiredprograms.ps1
    }

    $disabledefender {
        & $PSScriptRoot\..\normal\removal\disabledefender.ps1
    } 

    $netflyoutwin8 {
        & $PSScriptRoot\..\normal\taskbar\netflyoutwin8.ps1
    }

    $sharex462 {
        & $PSScriptRoot\..\normal\apps\sharex462.ps1
    }

    $paintdotnet462 {
        & $PSScriptRoot\..\normal\apps\paintdotnet.ps1
    }

    $removeedge {
        & $PSScriptRoot\..\normal\removal\removeedge.ps1
    }

    $removelockscreen {
        & $PSScriptRoot\..\normal\removal\removelockscreen.ps1
    }

    $removewaketimers {
        & $PSScriptRoot\..\normal\removal\removewaketimers.ps1
    }
    
    $removeUWPapps {
        Write-Host -ForegroundColor Cyan "Remove UWP apps"
        Get-AppxPackage | Remove-AppxPackage
        Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
    }

    $taskbarpins {
        & $PSScriptRoot\..\normal\removal\removetaskbarpinneditems.ps1
    }

    $explorerstartfldr {
        & $PSScriptRoot\..\normal\desktop\explorerstartfldr.ps1
    }

    $fixthispcdetails {
        & $PSScriptRoot\..\normal\desktop\thispcdetails.ps1
    }

    {$explorericon -eq $true -and $build -lt 18362} {
        & $PSScriptRoot\..\normal\taskbar\explorericon.ps1
    }

    $disableaddressbar {
        & $PSScriptRoot\..\normal\apps\addressbar.ps1
    }

    $oldbatteryflyout {
        Write-Host -ForegroundColor Cyan "Enable old battery flyout"
        if ($null -ne $battery) {Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Name 'UseWin32BatteryFlyout' -Value 1 -Type DWord -Force}
    }

    $classicapps {
        Write-Host -ForegroundColor Cyan "Install classic Taskmgr and msconfig"
        Start-BitsTransfer -Source 'https://github.com/Tonny2442/idkuauto/raw/main/utils/tm_cfg_win8-win10.zip' -Destination $workdir\tm.zip
        Expand-Archive -Path $workdir\tm.zip -DestinationPath $workdir 
        Start-Process $workdir\tm_cfg_win8-win10.exe -NoNewWindow -Wait -ArgumentList "/SILENT"
    }

    $openshellconfig {
        Write-Host -ForegroundColor Cyan "Import OpenShell configuration"
        Start-BitsTransfer -Source 'https://github.com/Tonny2442/idkuauto/raw/main/utils/menu.xml' -Destination $workdir\menu.xml
        Start-Process "$env:ProgramFiles\Open-Shell\StartMenu.exe" -NoNewWindow -ArgumentList "-xml $workdir\menu.xml"
    }

    $registrytweaks {
        & $PSScriptRoot\..\normal\simplereg\simpleregistry.ps1
    }

    $customsounds {
        & $PSScriptRoot\..\normal\desktop\customsounds.ps1
    }

    $removeudpassistant {

    }

    $defaultapps {
        
    }

    $disablesettings {
        
    }

    $blockapps {
        
    }

    $gpomodifs {
        
    }

    $dotnet35 {
        Write-Host "Enable .NET 3.5" -ForegroundColor Cyan
        Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3"
    }

    $deleteWU {
        Write-Host -ForegroundColor Cyan "Disable Windows Update"
        Set-Service -Name wuauserv -StartupType Disabled
    }

    $removeemojifont {
        & $PSScriptRoot\..\normal\removal\removeemojifont.ps1
    }
}
Write-Host "This was the final step of AutoIDKU. After the reboot, the IDKU will be fully setup!" -ForegroundColor White
Read-Host
shutdown -r -t 2