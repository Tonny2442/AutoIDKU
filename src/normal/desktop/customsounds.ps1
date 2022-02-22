$download = "https://github.com/Tonny2442/idkuauto/raw/main/utils/Longhorn.zip"

Start-BitsTransfer -Source $download -Destination $workdir\longhorn.zip

Expand-Archive -Path $workdir\longhorn.zip -DestinationPath $workdir

$longhorn = (Test-Path -Path "C:\Windows\Media\Longhorn")
if ($longhorn -eq $true) {Remove-Item -Path "C:\Windows\media" -Name "Longhorn" }
Copy-Item -Path $workdir\longhorn -Destination "C:\Windows\Media\Longhorn" -Recurse -Force

reg.exe import $workdir\longhorn.reg