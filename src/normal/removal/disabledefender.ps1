Write-Host -ForegroundColor Cyan "Disable Windows Defender"
if ($build -ge 18362) {
    Write-Host -ForegroundColor Cyan "Please disable Tamper Protection if it is there. If it isn't, press enter. Enter to continue."
    Read-Host
}
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft' -Name 'Windows Defender'
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -Name 'Real-Time Protection'
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -Name 'DisableAntiSpyware' -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection' -Name 'DisableBehaviorMonitoring' -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection' -Name 'DisableOnAccessProtection' -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection' -Name 'DisableScanOnRealtimeEnable' -Value 1 -Type DWord -Force