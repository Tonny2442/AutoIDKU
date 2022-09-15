#region ###################### BEGIN                        ######################
$root = "$PSScriptRoot\.."

# Start Transcript
$date = Get-Date -Format "yyyy-MM-dd-H-mm-ss-LOG"
Start-Transcript -Path "C:\AutoIDKU-$date.txt"

# Enable Script Execution
Set-ExecutionPolicy Unrestricted -Force
#endregion

#region ###################### FUNCTIONS                    ######################
function ASCW {
    # Apps:
    # 0 = ShareX
    # 1 = Paint.NET
    # 2 = Classic win32 Apps
    param (
        $disableAll,
        $enableAll
    )

    $installApps = @(
        "ShareX",
        "Paint.NET",
        "Classic Apps"
    )

    $configOptions = [ordered]@{
        "Setup Music"                   = $setupMusic
        "Required Programs"             = $requiredDeps
        "Hide Taskbar Icons"            = $hideTaskbarIcons
        "Replace Network Icon"          = $replaceNetIcon
        "Remove Microsoft Edge"         = $removeMSE
        "Run Windows Update"            = $runWU
        "Set Desktop Background"        = $setBG
        "Install .NET 3.5"              = $dotNET35
        "Install .NET 4.6.2"            = $dotNET462
        "Install ShareX"                = $installApps[0]
        "Install Paint.NET"             = $installApps[1]
        "Add Desktop Shortcuts"         = $desktopShortcuts
        "Remove Update Assistant"       = $removeUPDA
        "Disable Wake Timers"           = $disableWakeTimers
        "Delete Windows Update"         = $deleteWU
        "Delete All UWP Apps"           = $removeUWP 
        "Apply OpenShell Config"        = $opnshlConfig
        "Change Explorer Icon"          = $explrIcon
        "Install WIN32 Classic Apps"    = $installApps[2]
        "Remove Taskbar Pins"           = $taskbarPins
        "Remove Emoji Font"             = $emojiFont
        "Set Default Apps"              = $defaultApps
        "Disable Immsersive CP"         = $disableICP
        "Block Exposing Applications"   = $blockApps
        "Set Group Policy"              = $applyGPO
        "Set This PC view mode"         = $tpcViewMode
        "Disable Address Bar"           = $disableAB
        "Delete OneDrive"               = $deleteOD
        "Delete HomeGroup"              = $deleteHG
        "Disable Windows Defender"      = $disableWD
        "Set Explorer Starting Folder"  = $startFolder
        "Set Win8 Net Flyout"           = $win8NetFlyout
        "Set Old Battery Flyout"        = $oldBattFlyout
        "Custom Windows Sounds"         = $customSoundScheme
        "Take Ownership"                = $takeOwn
    }

    $warningEntries = @(
        2,6,13,15,16
    )

    ## Applied Settings Configuration Wizard
    $counter = 0
    foreach ($Option in $configOptions.Keys) {
        $valid = $false
        Clear-Host
        $counter++
        Write-Host "================================="
        Write-Host "$counter. $Option" -ForegroundColor Green 
        if ($counter -In $warningEntries) {Write-Host "WARNING: THIS OPTION IS RECOMMENDED TO BE ENABLED" -ForegroundColor Red}
        Write-Host "Please specify to Enable (y) or Disable (n) this action"
        while ($valid -eq $false) {
            switch ($true) {
                $disableAll {
                    $wait = 0
                    $answer = "n"
                }
                $enableAll {
                    $wait = 0
                    $answer = "y"
                }
                default {
                    $wait = 1
                    $answer = Read-Host "================================="
                }
            }
            switch -Regex ($answer){
                '^y$|yes$' {
                    $valid = $true
                    Write-Host "`n $Option set to True `n" -ForegroundColor Cyan
                }
                '^n$|no$' {
                    $valid = $true
                    Write-Host "`n $Option set to False `n" -ForegroundColor Cyan
                }
                default {
                    $valid = $false
                    Write-Host "`n Please choose Y or N. `n" -ForegroundColor Cyan
                }
            }
            Start-Sleep -Seconds $wait
            }   
        }
}

Function Enable-Privilege {
  param($Privilege)
  $Definition = @'
using System;
using System.Runtime.InteropServices;
public class AdjPriv {
  [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
  internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall,
    ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr rele);
  [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
  internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);
  [DllImport("advapi32.dll", SetLastError = true)]
  internal static extern bool LookupPrivilegeValue(string host, string name,
    ref long pluid);
  [StructLayout(LayoutKind.Sequential, Pack = 1)]
  internal struct TokPriv1Luid {
    public int Count;
    public long Luid;
    public int Attr;
  }
  internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
  internal const int TOKEN_QUERY = 0x00000008;
  internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;
  public static bool EnablePrivilege(long processHandle, string privilege) {
    bool retVal;
    TokPriv1Luid tp;
    IntPtr hproc = new IntPtr(processHandle);
    IntPtr htok = IntPtr.Zero;
    retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY,
      ref htok);
    tp.Count = 1;
    tp.Luid = 0;
    tp.Attr = SE_PRIVILEGE_ENABLED;
    retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
    retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero,
      IntPtr.Zero);
    return retVal;
  }
}
'@
  $ProcessHandle = (Get-Process -id $pid).Handle
  $type = Add-Type $definition -PassThru
  $type[0]::EnablePrivilege($processHandle, $Privilege)
}

function Get-Error {
    param(
        $Position,
        $ErrorText
    )
    Write-Host "An error has occurred in AutoIDKU @ $Position `n $ErrorText | The program will exit in 30 seconds." -ForegroundColor Red
    Start-Sleep -Seconds 30
    Stop-Transcript
    Stop-Process -Name "powershell" -Force
}

function Get-PSWURequired {
    $supportedPSWUs     = 15063..19045

    if ($osBuild -NotIn $supportedPSWUs) {
        if ($uptoDate -eq $false) {
            $intBuild = [int]$osBuild
            $updateUBR = $latestUBR[$intBuild]
            Get-Error -Position $scriptProgs["Init"] -ErrorText "Your OS is not up to date, and does not support PSWU. Please update to the latest build of your OS, which would be $osName build $updateUBR."
        }
    } elseif ($osBuild -In $supportedPSWUs) {
        if ($uptoDate -eq $false) {
            $pswuRequired = $true
        } elseif ($uptoDate -eq $true) {
            $pswuRequired = $false
        }
    } else {
        Get-Error -Position $scriptProgs["Init"] -ErrorText "An unknown error has occurred while determining update capability. Please report this error to the developers."
    }
}

function Install-RequiredModules {
    $musicPlayerReqs    = 10240
    $supportedPSWUs     = 15063..19045

    # Check if NuGet is installed, if not, install it
    Get-PackageProvider -Name "NuGet" -ErrorAction SilentlyContinue -Force

    # Check if PSGallery is set to Trusted, if not, trust it
    if ((Get-PSRepository -Name PSGallery).InstallationPolicy -notlike "Trusted") {
        Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
    }

    # Add PresentationCore
    Add-Type -AssemblyName presentationCore

    # Import BitsTransfer Module
    Import-Module BitsTransfer -ea Stop

    switch ($osBuild) {
        {$osBuild -ge $musicPlayerReqs} {     
            switch ($osBuild) {
                $musicPlayerReqs {Invoke-Expression (new-object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/PrateekKumarSingh/MusicPlayer/master/Install.ps1')}
                default {
                    Install-Module MusicPlayer -scope CurrentUser -Repository 'PSGallery' -ea Stop
                    Import-Module MusicPlayer -ea Stop
                }
            }
        }
        {$osBuild -In $supportedPSWUs} {
            Install-Module PSWindowsUpdate -ea Stop
            Import-Module PSWindowsUpdate -ea Stop
        }
    }
}

function MainMenu {
    param(
        $userHeader,
        $optionsArray,
        $choices
    )
    while ($success -ne $true) {
        Clear-Host
        Write-Host "================================================================="
        Write-Host $userHeader
        Write-Host "Please choose an option:`n"
        foreach ($Option in $optionsArray.Values) {
            Write-Host $Option
        }
        $answer = Read-Host "================================================================="
        if ($answer -In $choices.Keys) {
            Invoke-Command -ScriptBlock $choices["$answer"]
        } 
    }
}

function Set-TLSSettings {
    $tlsBuildReqs       = 17763

    $tlsKeys = @(
        (Get-ItemProperty -ErrorAction SilentlyContinue -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto').SchUseStrongCrypto
        (Get-ItemProperty -ErrorAction SilentlyContinue -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto').SchUseStrongCrypto
    )

    if ($osBuild -lt $tlsBuildReqs) {
        if ($tlsKeys[0] -ne 1) {
            Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord -ea Stop
            $tlsApplied[0] = $true
        }
        if ($tlsKeys[1] -ne 1) {
            Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord -ea Stop
            $tlsApplied[1] = $true
        }
        if (($tlsApplied[0] -eq $true) -and ($tlsApplied[1] -eq $true)) {
            Get-Error -Position $scriptProgs["Init"] -ErrorText "TLS Settings had to be applied for your OS. As of now, the script cannot restart itself. Please relaunch the script after it closes."
        }
    }
}

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

function Text {
    param($text)
    Write-Host $text"..." -ForegroundColor Cyan
}
#endregion

#region ###################### DYNAMIC VARIABLES            ######################
# AutoIDKU Version
$ver =                  "0.6.0"

# Working Directory
$workdir =              "$root\workdir"

# Gather System Inventory
$osBuild =              [System.Environment]::OSVersion.Version.Build
$osUBR =                (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR
$fullBuild =            "$osBuild.$osUBR"
$osVersion =            if ($osBuild -ge 19042) {
    (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion
} else {
    (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ReleaseId
}
$osName =               (Get-WmiObject Win32_OperatingSystem).Caption
$batteryPresent =       if ($null -eq (Get-WmiObject Win32_Battery)) {$false} else {$true}

# Latest Build UBRs
$latestUBR = @{
    10240 = '10240.17394'
    10586 = '10586.1540'
    14393 = '14393.2214'
    15063 = '15063.1418'
    16299 = '16299.1087'
    17134 = '17134.1184'
    17763 = '17763.1577'
    18362 = '18362.1256'
    18363 = '18363.1556'
    19041 = '19041.1415'
    19042 = '19042.1706'
    19043 = '19043.2006'
    19044 = '19044.2006'
    19045 = '19045.2006'
}

# Script Progress Markers
$scriptProgs = [ordered]@{
    "Init" = "Initialization"
    "PreConf" = "Pre-Configuration"
    "Operate" = "Script Operation"
    "Validate" = "Validating Settings"
}

# Supported Builds
$supportedBuilds    = 10240..19045
#endregion

#region ###################### INIT                         ######################
# Persistance Registry Folder
if (!(Test-Path 'HKCU:\SOFTWARE\AutoIDKU')) {
        New-Item -Path 'HKCU:\SOFTWARE' -Name AutoIDKU
}

# Set Console Title
$host.ui.RawUI.WindowTitle = "AutoIDKU $ver"

#region ###################### COMPATIBILITY CHECKS                ######################
# Check for Pending Reboot
if (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending') {
    Get-Error -Position "Initialization" -ErrorText "Your PC has a pending reboot. Please reboot your PC and run AutoIDKU again."
}

# OS Build Check
if (!($osBuild -In $supportedBuilds)) {
    Get-Error -Position $scriptProgs["Init"] -ErrorText "$osName build $osBuild is not compatible with AutoIDKU."
}

# OS UBR Check
if ($fullBuild -In $latestUBR) {
    $uptoDate = $true
} else {
    $uptoDate = $false
}

# Set TLS Settings
#Set-TLSSettings

# Check of PSWU is needed
Get-PSWURequired
#endregion

# Install Required Modules
Install-RequiredModules
#endregion

#region ###################### MENU CONFIG                  ######################
## Menu Variables
# Header
$header = "AutoIDKU $ver `t`t $osName, $osVersion, $fullBuild `n"
# Main Entries
$mainEntries = [ordered]@{
    "A" = "[A] Applied Settings Configuration Wizard - Easy Mode"
    "B" = "[B] Applied Settings Configuration Wizard - Advanced Mode"
    "Z" = "`n`n`n`n[Z] Run AutoIDKU"
}

# Main Choices
$mainChoices = [ordered]@{
    "A" = {ASCW}
    "B" = {MainMenu -userHeader $header -optionsArray $bEntries -choices $bChoices}
    "Z" = {break}
}

# Option B Entries - ACSW Advanced
$bEntries = [ordered]@{
    "A" = "[A] Enable All Settings"
    "B" = "[B] Disable All Settings"
    "Z" = "`n`n`n`n`n`n[Z] Go Back"
}

# Option B Choices - ACSW Advanced
$bChoices = [ordered]@{
    "A" = {ASCW -enableAll $true}
    "B" = {ASCW -disableAll $true}
    "Z" = {break}
}
MainMenu -userHeader $header -optionsArray $mainEntries -choices $mainChoices
#endregion

#region ###################### VARIABLES               ######################
# This section is for changing what you want the script to do.

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
#endregion

#region ###################### OPERATE                 ######################
#. $root\operate.ps1
#endregion

#region ###################### VALIDATE                ######################
#endregion

Write-Host "Incomplete"
pause
Stop-Transcript
Exit