# start
Clear-Host

# delete cstrike zip
Write-Host "Removing Counter-Strike files" -ForegroundColor green
$ZipLocation = "C:\temp\cstrike.zip"
if (Test-Path -Path $ZipLocation -PathType Leaf) {
  Remove-Item -Path $ZipLocation -Force
}
Start-Sleep -Seconds 1

# delete half-life folder
$HLFolder = "C:\Sierra"
if (Test-Path -Path $HLFolder -PathType Container) {
  Remove-Item -Path $HLFolder -Force -Recurse
}
Start-Sleep -Seconds 1

# delete desktop shortcut
$Shortcut = "$Home\Desktop\Counter Strike.lnk"
if (Test-Path -Path $Shortcut -PathType Leaf) {
  Remove-Item -Path $Shortcut -Force
}
Start-Sleep -Seconds 1

# updating regedit key(s)
$ExeFile = "C:\Sierra\Half-Life\hl.exe"
Write-Host "Removing registry key(s)" -ForegroundColor green
$CompatKey = "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
reg delete $CompatKey /v $ExeFile /f
Start-Sleep -Seconds 1

Write-Host "Success!" -ForegroundColor green
Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
