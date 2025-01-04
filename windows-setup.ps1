
$taskName = "Tailscale-MTU"
$taskDescription = "Adjust MTU for Tailscale interface"
$scriptCommand = "while (`$true) { try { Get-NetIPInterface -InterfaceAlias 'Tailscale' | Where-Object { `$_.NlMtu -ne 1500 } | ForEach-Object { Set-NetIPInterface -InterfaceAlias 'Tailscale' -NlMtuBytes 1500 }; Start-Sleep -Seconds 10 } catch { Start-Sleep -Seconds 10 } }"

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command `"$scriptCommand`""

$trigger = New-ScheduledTaskTrigger -AtLogOn

$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest

$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description $taskDescription -Force

