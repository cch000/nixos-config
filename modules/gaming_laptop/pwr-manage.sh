#!/usr/bin/env bash

connected="$(echo /sys/class/power_supply/A*)/online"
kernel_version=$(uname -r | cut -c1-3)
readonly min_version=6.3

#check if the laptop is plugged
if [[ $(cat "$connected") == "0" ]]; then

  driver="passive"
  governor="conservative"
  service="start"
  profile="power-saver"
  log="disconnected"

else

  driver="active"
  governor="performance"
  service="stop"
  profile="balanced"
  log="connected"

fi

echo "$log" | systemd-cat -t pwr-manage

# Set cpu scheduling driver
if (($(echo "$kernel_version >= $min_version" | bc -l))); then
  echo "$driver" | tee /sys/devices/system/cpu/amd_pstate/status
fi

# Set cpu scheduling governor if we are on a supported kernel
for i in /sys/devices/system/cpu/*/cpufreq/scaling_governor; do
  echo "$governor" | tee "$i" >/dev/null
done

# Start or stop pwr-cap-rs service if it exists
if systemctl is-enabled pwr-cap-rs.service >/dev/null; then
  systemctl "$service" pwr-cap-rs.service
fi

# Set power profile
powerprofilesctl set "$profile"

# Update waybar icon if waybar is running
if pidof waybar >/dev/null; then
  pkill -SIGRTMIN+8 waybar
fi
