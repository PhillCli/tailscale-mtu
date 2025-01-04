
# Tailscale MTU Persistent Configuration ⚙️

This repository provides step-by-step instructions and scripts to make the MTU configuration for Tailscale persistent on both Linux and Windows. Each section is tailored to its operating system and includes explanations for every step.



## Why Adjust the MTU? 🤔

Tailscale defaults to an MTU of 1280 for compatibility with most networks, but in some situations, increasing the MTU to 1500 can improve network performance. This is particularly useful in environments where fragmentation is not a concern.


## Table of Contents 📋
- [Linux Configuration 🐧](#linux-configuration-)
- [Windows Configuration 🪟](#windows-configuration-)
- [License 📜](#license-)


## Linux Configuration 🐧

### Steps:

1. **Create a `udev` rule:**

   - Open a terminal and run the following command to create a new rule file:
     ```bash
     sudo nano /etc/udev/rules.d/99-tailscale-mtu.rules
     ```

2. **Add the rule to the file:**

   - Paste the following content into the file:
     ```bash
     ACTION=="add", SUBSYSTEM=="net", KERNEL=="tailscale0", ENV{DISABLE_RULE}=="1", RUN+="/sbin/ip link set dev tailscale0 mtu 1500"
     ```

3. **Reload the rules and apply them:**

   - Run the following commands to activate the new rule:
     ```bash
     sudo udevadm control --reload-rules
     sudo udevadm trigger
     ```

### Explanation 📝

- `ACTION=="add"`: The rule triggers when a network device is added.
- `SUBSYSTEM=="net"`: Applies only to network devices.
- `KERNEL=="tailscale0"`: Targets the Tailscale interface.
- `RUN+="/sbin/ip link set dev tailscale0 mtu 1500"`: Runs the command to set the MTU to 1500.

<br>

---

<br>

## Windows Configuration 🪟

### Steps:

1. **Download the PowerShell script:**

   - Save the [windows-setup.ps1](./windows-setup.ps1) file to your computer.

2. **Run the script as Administrator:**

   - Open a PowerShell terminal as Administrator.
   - Navigate to the directory where the script is saved.
   - Execute the script:
     ```powershell
     .\setup-tailscale-task.ps1
     ```

### How It Works ⚙️

- The script creates a scheduled task named `Tailscale-MTU`.
- The task runs a PowerShell command in the background to monitor the Tailscale interface.

### What’s Inside the Script? 🤔

Here’s the content of the PowerShell script:

```powershell
$taskName = "Tailscale-MTU"
$taskDescription = "Adjust MTU for Tailscale interface"
$scriptCommand = "while (`$true) { try { Get-NetIPInterface -InterfaceAlias 'Tailscale' | Where-Object { `$_.NlMtu -ne 1500 } | ForEach-Object { Set-NetIPInterface -InterfaceAlias 'Tailscale' -NlMtuBytes 1500 }; Start-Sleep -Seconds 10 } catch { Start-Sleep -Seconds 10 } }"

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command `"$scriptCommand`""

$trigger = New-ScheduledTaskTrigger -AtLogOn

$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest

$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description $taskDescription -Force
```

### Note 📜

You can modify the MTU value to suit your needs. Replace `1500` in the commands or scripts with the desired MTU value.

For Linux, modify the `RUN+="/sbin/ip link set dev tailscale0 mtu 1500"` line in the `udev` rule file to set your preferred MTU value.

For Windows, update the `1500` in the PowerShell script on $scriptCommand part to the MTU value you want.

---

## License 📄

This repository is licensed under the [MIT License](./LICENSE).
