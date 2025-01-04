#!/bin/bash

# Check for root permissions
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please use sudo."
  exit 1
fi

# Create udev rule file
UDEV_RULE_PATH="/etc/udev/rules.d/99-tailscale-mtu.rules"
echo 'Creating udev rule file at $UDEV_RULE_PATH...'
cat <<EOF > $UDEV_RULE_PATH
ACTION=="add", SUBSYSTEM=="net", KERNEL=="tailscale0", RUN+="/sbin/ip link set dev tailscale0 mtu 1500"
EOF

# Reload udev rules and apply them
echo "Reloading udev rules..."
udevadm control --reload-rules
udevadm trigger

# Verify MTU setting
echo "Verifying MTU for tailscale0 interface..."
MTU=$(ip link show tailscale0 | grep -oP 'mtu \K\d+')

if [ "$MTU" -eq 1500 ]; then
  echo "MTU is correctly set to 1500 for the tailscale0 interface."
else
  echo "MTU is not set correctly. Current MTU: $MTU"
fi

echo "Setup complete."
