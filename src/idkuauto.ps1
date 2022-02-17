### IDKU Automatic Configuration Script

### ------ Import Modules ------

Import-Module BitsTransfer

### ------ Variables ------

# Get Windows Build and current UBR
$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
$ubr = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').UBR

# Set Working Directory
$workdir = $env:TEMP

###############################################################
### ------- MODIFYABLE VARIABLES -------

# This section is for changing what you want the script to do.
# Please only modify this if you know what you're doing!

$hidetaskbaricons =     $true
$replaceneticon =       $true
$removeedge =           $true
$windowsupdate =        $true
$setwallpaper =         $true
$dotnet35 =             $true 
$dotnet462 =            $true
$sharex462 =            $true
$paintdotnet462 =       $true 
$disblestartupitems =   $true
$linkfolders =          $true
$desktopshortcuts =     $true 
$removelockscreen =     $true 
$removeudpassistant =   $true 
$removewaketimers =     $true 
$disableWOL =           $true 
$disablenotifs =        $true 
$disablegamebar =       $true 
$disableautoplay =      $true 
$disablemultitaskbar =  $true
$deleteWU =             $true 
$removeUWPapps =        $true 
$openshellconfig =      $true 
$explorericon =         $true
$transparencydisable =  $true 
$disableanimations =    $true 
$classicapps =          $true 
$disablewinink =        $true 
$removedownloads =      $true 
$1903micicondisable =   $true
$taskbarpins =          $true
$removeemojifont =      $true 
$defaultapps =          $true 
$remove3Dobjects =      $true
$hidebluetoothicon =    $true
$winaeroconfig =        $true 
$disablesettings =      $true 
$blockapps =            $true 
$gpomodifs =            $true 
$defaultcolor =         $true
$fixthispcdetails =     $true
$disableaddressbar =    $true

##############################################################

### -------- Winver Detection --------

# Your version must be between 10240 and 19044. If it is not, not supported.
switch ($build) {
    {$_ -ge 10240 -and $_ -le 19044} {$versupported = $true}
    default {
        Write-Host "You're not running a supported version of Windows for this script." -ForegroundColor Red
        Write-Host "Press Enter to exit" -ForegroundColor White
        Read-Host
        exit
    }
}



##################### Begin Script ###########################

switch ($true) {
    $hidetaskbaricons {
        Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTaskViewButton' -Value 0 -Type DWord -Force
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchBoxTaskbarMode' -Value 0 -Type DWord -Force
        if ($build -ge 16299) { Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Name 'PeopleBand' -Value 0 -Type DWord -Force}
        New-Item -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Explorer' -Force
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'DisableNotificationCenter' -Value 1 -Type DWord -Force
    }






























}