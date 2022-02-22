Write-Host "Setup Music Portion" -ForegroundColor Cyan

$musicdir = (Test-Path -Path $workdir\music)
if ($musicdir -eq $false) {New-Item -Path $workdir -Name music -ItemType directory}

$download1 = "https://github.com/Tonny2442/idkuauto/raw/main/utils/music/core.mp3"
$download2 = "https://github.com/Tonny2442/idkuauto/raw/main/utils/music/rudebuster.mp3"
$download3 = "https://github.com/Tonny2442/idkuauto/raw/main/utils/music/ruins.mp3"
$download4 = "https://github.com/Tonny2442/idkuauto/raw/main/utils/music/scarletforest.mp3"
$download5 = "https://github.com/Tonny2442/idkuauto/raw/main/utils/music/yt-dlg.zip"

Start-BitsTransfer -Source $download1 -Destination $workdir\music\core.mp3
Start-BitsTransfer -Source $download2 -Destination $workdir\music\rudebuster.mp3
Start-BitsTransfer -Source $download3 -Destination $workdir\music\ruins.mp3
Start-BitsTransfer -Source $download4 -Destination $workdir\music\scarletforest.mp3
Start-BitsTransfer -Source $download5 -Destination $workdir\ytdl.zip

Expand-Archive -Path $workdir\ytdl.zip -DestinationPath $workdir\music -ErrorAction SilentlyContinue

Music $workdir\music\ -Shuffle -Loop