Write-Host -ForegroundColor Cyan "Remove Segoe UI Emoji Font"
Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "Segoe UI Emoji (TrueType)"
Stop-Process -Name fontdrvhost,chrome,msedge,discord,firefox,wordpad,notepad,discordptb,discordcanary -ErrorAction SilentlyContinue
if ($build -ne 16299 -and $build -ne 17134) {$segoedir = (Get-ChildItem -Name C:\Windows\WinSxS\amd64_microsoft-windows-font-truetype-segoeui_31bf3856ad364e35_10.0.*)}
if ($build -eq 16299 -or $build -eq 17134) {
    switch ($build) {
        16299 {
            Write-Host "Detected Win10 16299"
            $dualttf = $true
            $segoedir1 = (Get-ChildItem -Name C:\Windows\WinSxS\amd64_microsoft-windows-font-truetype-segoeui_31bf3856ad364e35_10.0.16299.15*)
            if ($ubr -gt 15) {$segoedir2 = (Get-ChildItem -Name C:\Windows\WinSxS\amd64_microsoft-windows-font-truetype-segoeui_31bf3856ad364e35_10.0.16299.522*)}
            Write-Host $segoedir1
            Write-Host $segoedir2
        }
        17134 {
            Write-Host "Detected Win10 17134"
            $dualttf = $true
            $segoedir1 = (Get-ChildItem -Name C:\Windows\WinSxS\amd64_microsoft-windows-font-truetype-segoeui_31bf3856ad364e35_10.0.17134.1*)
            if ($ubr -gt 1) {$segoedir2 = (Get-ChildItem -Name C:\Windows\WinSxS\amd64_microsoft-windows-font-truetype-segoeui_31bf3856ad364e35_10.0.17134.81*)}
            Write-Host $segoedir1
            Write-Host $segoedir2
        }
    }
}
switch ($dualttf) {
    $false {
        Write-Host "Only one to delete."
        Write-Host $segoedir
        takeown.exe /f $segoedir\seguiemj.ttf 
        icacls.exe $segoedir\seguiemj.ttf /grant Administrators:F /t
        Remove-Item -Path $segoedir\seguiemj.ttf -Force -Whatif
    }
    $true {
        Write-Host "Two files to delete."
        Write-Host $segoedir1
        Write-Host $segoedir2
        takeown.exe /f $segoedir1\seguiemj.ttf 
        if ($ubr -gt 15) {takeown.exe /f $segoedir2\seguiemj.ttf}
        icacls.exe $segoedir1\seguiemj.ttf /grant Administrators:F /t
        if ($ubr -gt 15) {icacls.exe $segoedir2\seguiemj.ttf /grant Administrators:F /t}
        Remove-Item -Path $segoedir1\seguiemj.ttf -Force -Whatif -ErrorAction SilentlyContinue
        if ($ubr -gt 15) {Remove-Item -Path $segoedir2\seguiemj.ttf -Force -Whatif}
    }
}