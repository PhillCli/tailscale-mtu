<div align="center">
    <img src="./tailscale-logo.png" alt="Tailscale Logo">
</div>

# Tailscale MTU Configuration ⚙️

This repository provides step-by-step instructions and scripts to make the MTU configuration for Tailscale persistent on both Linux and Windows. Each section is tailored to its operating system and includes explanations for every step.


## Why Adjust the MTU? 🤔

Tailscale defaults to an MTU of 1280 for compatibility with most networks, but in some situations, increasing the MTU to 1500 can improve network performance. This is particularly useful in environments where fragmentation is not a concern.

<br>

## Table of Contents 📋
- [Linux Configuration 🐧](#linux-configuration-)
- [Windows Configuration 🪟](#windows-configuration-)
- [License 📜](#license-)

<br>

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
     ACTION=="add", SUBSYSTEM=="net", KERNEL=="tailscale0", RUN+="/sbin/ip link set dev tailscale0 mtu 1500"
     ```

3. **Reload the rules and apply them:**

   - Run the following commands to activate the new rule:
     ```bash
     sudo udevadm control --reload-rules
     sudo udevadm trigger
     ```

4. **Check the MTU size** ✅
   - Verify if the MTU for the `tailscale0` interface has been set to `1500`:
     ```bash
     ip link show tailscale0
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

### **Option 1: Automatic Execution from URL**

1. **Run the script directly from the URL:** (Recommended)

   - Open a PowerShell terminal as Administrator.
   - Run the following command:
     ```powershell
     Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/luizbizzio/tailscale-mtu/refs/heads/main/windows-setup.ps1'))
     ```
<br>

---

<br>

### **Option 2: Manual Download and Execution**

1. **Download the PowerShell script:**

   - Save the [windows-setup.ps1](https://raw.githubusercontent.com/luizbizzio/tailscale-mtu/refs/heads/main/windows-setup.ps1) file to your computer.

2. **Run the script as Administrator:**

   - Open a PowerShell terminal as Administrator.
   - Navigate to the directory where the script is saved.
   - Execute the script:
     ```powershell
     Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; ./windows-setup.ps1
     ```

### Explanation 📝

Here’s what the PowerShell script does step by step:
- The first part of the command, `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`, temporarily allows unsigned scripts to run in the current session without changing the system's global execution policy.
- **`$taskName`**: Names the task as `Tailscale-MTU`.
- **`$scriptCommand`**: Continuously monitors the `Tailscale` interface and adjusts the MTU if needed.
- **Scheduled Task Settings**:
  - `RunLevel Highest`: Ensures administrative privileges.
  - `WindowStyle Hidden`: Runs the script silently in the background.

<br>

---


### Note 📜

You can modify the MTU value to suit your needs. Replace `1500` in the commands or scripts with the desired MTU value.

For Linux, modify the `RUN+="/sbin/ip link set dev tailscale0 mtu 1500"` line in the `udev` rule file to set your preferred MTU value.

For Windows, update the `1500` in the PowerShell script on `$scriptCommand` part to the MTU value you want.

---

## License 📄

This repository is licensed under the [MIT License](./LICENSE).
