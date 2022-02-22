$edgexists = Test-Path "$env:USERPROFILE\Desktop\Microsoft Edge.lnk"
switch ($true) {
    $edgexists {
        Write-Host "Remove Edge from Desktop" -ForegroundColor Cyan
        Remove-Item -Path "$env:USERPROFILE\Desktop\Microsoft Edge.lnk" -Force
    }
}