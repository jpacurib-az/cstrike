# start
Clear-Host

# create temp dir
$TempDir = "C:\temp"
New-Item -ItemType Directory -Force -Path $TempDir -ErrorAction SilentlyContinue

# download cstrike zip
Write-Host "Downloading Counter-Strike files" -ForegroundColor green
$CstrikeZipUrl = "https://www.dropbox.com/s/h20i5kch17xlr44/cstrike.zip?dl=1"
$ZipLocation = $TempDir + "\cstrike.zip"
if (Test-Path -Path $ZipLocation -PathType Leaf) {
  Remove-Item -Path $ZipLocation -Force
}
Invoke-WebRequest -Uri $CstrikeZipUrl -OutFile $ZipLocation
# $WebClient = New-Object System.Net.WebClient
# $WebClient.Downloadfile($CstrikeZipUrl, $ZipLocation)
# $WebClient.Dispose()
Write-Host "Downloaded to" $ZipLocation -ForegroundColor green
Start-Sleep -Seconds 1

# variable declarations
$HLFolder = "C:\Sierra\Half-Life"
$ExeFile = $HLFolder + "\hl.exe"

# extract zip file
Write-Host "Extracting files" -ForegroundColor green
Expand-Archive -Path $ZipLocation -Destination $HLFolder -Force
Write-Host "Done extracting to" $HLFolder -ForegroundColor green
Start-Sleep -Seconds 1

# create desktop shortcut
Write-Host "Creating desktop shortcut" -ForegroundColor green
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Counter Strike.lnk")
$Shortcut.TargetPath = $ExeFile
$Shortcut.Arguments = "-console -game cstrike"
if ($HLFolder -eq "C:\Sierra\Half-Life") {
  # for some reason; this refuses to be converted into a variable
  $Shortcut.WorkingDirectory = "C:\Sierra\Half-Life"
}
$Shortcut.IconLocation = $HLFolder + "\cstrike\cstrike.ico"
$Shortcut.Description = "Counter-Strike"
$Shortcut.Save()
Start-Sleep -Seconds 1

# updating regedit key(s)
Write-Host "Adding registry key(s)" -ForegroundColor green
$CompatKey = "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
reg add $CompatKey /v $ExeFile /d "~ DWM8And16BitMitigation DISABLEDXMAXIMIZEDWINDOWEDMODE HIGHDPIAWARE WINXPSP3" /f
Start-Sleep -Seconds 1

# prompt to open CD Key file
$reply = Read-Host -Prompt "Opening CD Key file? [y/n]"
if ($reply.ToUpper() -eq 'Y') { 
  $CdKey = $HLFolder + "\cd-key.txt"
  notepad.exe $CdKey
}
Write-Host "Success!" -ForegroundColor green
Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
