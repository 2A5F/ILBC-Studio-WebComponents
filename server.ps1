$host.UI.RawUI.BackGroundColor = 'Black'
$Host.UI.RawUI.ForegroundColor = 'White'

$process = Start-Process powershell.exe './server/start.ps1' -NoNewWindow -PassThru
[console]::TreatControlCAsInput = $true
while ($true) {
    if ($Host.UI.RawUI.KeyAvailable -and (3 -eq [int]$Host.UI.RawUI.ReadKey("AllowCtrlC,IncludeKeyUp,NoEcho").Character)){
        write-host " Stopping Server " -f 'red'
        $process.Kill()
        break
    }
}