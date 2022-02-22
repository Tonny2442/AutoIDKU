if ($build -lt 14393) {
    Write-Host "Install .NET 4.6.2" -ForegroundColor Cyan
    $462dl = "https://download.visualstudio.microsoft.com/download/pr/8e396c75-4d0d-41d3-aea8-848babc2736a/80b431456d8866ebe053eb8b81a168b3/ndp462-kb3151800-x86-x64-allos-enu.exe"
    Start-BitsTransfer -Source $462dl -Destination $workdir\dotnet462.exe
    Start-Process $workdir\dotnet462.exe -NoNewWindow -Wait -ArgumentList "/passive /log %temp%\net.htm /noreboot"
    $pendingreboot = (Test-PendingReboot).IsRebootPending
    if ($pendingreboot -eq $true) {
        Write-Host -ForegroundColor Cyan ".NET 4.6.2 requires a reboot to complete installation. Enter to reboot."
        Set-ItemProperty -Path 'HKCU:\SOFTWARE\AutoIDKU' -Name "dotnetrebooted" -Value 1 -Type DWord -Force
        shutdown -r -t 2
    }
}