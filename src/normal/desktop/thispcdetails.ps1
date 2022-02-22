$wshell = New-Object -ComObject wscript.shell;
Write-Host -ForegroundColor Cyan "DO NOT TOUCH ANYTHING!"
Start-Sleep -Seconds 2
Start-Process 'explorer.exe' 
Start-Sleep -Seconds 2
$wshell.SendKeys("+{F10}");
Start-Sleep -Milliseconds 100
$wshell.SendKeys("{DOWN}");
Start-Sleep -Milliseconds 100
$wshell.SendKeys("{RIGHT}");
Start-Sleep -Milliseconds 100
$wshell.SendKeys("{DOWN}");
Start-Sleep -Milliseconds 100
$wshell.SendKeys("{DOWN}");
Start-Sleep -Milliseconds 100
$wshell.SendKeys("{DOWN}");
Start-Sleep -Milliseconds 100
$wshell.SendKeys("{DOWN}");
Start-Sleep -Milliseconds 100
$wshell.SendKeys("{DOWN}");
Start-Sleep -Milliseconds 100
$wshell.SendKeys("{ENTER}");