Write-Host -ForegroundColor Cyan "Doing Windows Updates before running the script"
$wureboot = (Get-ItemProperty -Path "HKCU:\Software\AutoIDKU").RebootForWU

switch ($build) {
    {$_ -ge 10240 -and $_ -le 19041} {$version = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').ReleaseId}
    {$_ -ge 19042 -and $_ -le 19044} {$version = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion}
}

Write-Host "Windows Update Portion" -ForegroundColor Cyan
    $wudir = (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate)
    if ($wudir -eq $false) {New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name 'WindowsUpdate'}
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersionInfo' -Value $version -Type String -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name 'TargetReleaseVersion' -Value 1 -Type DWord -Force
    Restart-Service -Name wuauserv
if ($wureboot -eq 0 -or $null -eq $wureboot) {
    Get-WindowsUpdate
    Get-WindowsUpdate -AcceptAll -Install -NotCategory 'Upgrade' -IgnoreReboot
    Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootForWU" -Value 1 -Type DWord -Force
    Write-Host "Rebooting for WU Run #1. Enter to continue."
    Read-Host
    shutdown -r -t 2
    Start-Sleep -Seconds 5
}
if ($wureboot -eq 1) {
    Get-WindowsUpdate
    Get-WindowsUpdate -AcceptAll -Install -NotCategory 'Upgrade' -IgnoreReboot
    Set-ItemProperty -Path "HKCU:\Software\AutoIDKU" -Name "RebootForWU" -Value 2 -Type DWord -Force
    Write-Host "Rebooting for WU Run #2. Enter to continue."
    Read-Host
    shutdown -r -t 2
    Start-Sleep -Seconds 5
}
if ($wureboot -eq 2) {
    Write-Host "Updates are installed." -ForegroundColor Green
}