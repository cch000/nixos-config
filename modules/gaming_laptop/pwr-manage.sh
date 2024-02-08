#!/usr/bin/env bash

connected="$(echo /sys/class/power_supply/A*)/online"

#check if the laptop is plugged
if [[ $(cat "$connected") == "0" ]]; then

  driver="passive"
  governor="conservative"
  ryzenadj="start"
  profile="power-saver"
  log="disconnected"

else

  driver="active"
  governor="performance"
  ryzenadj="stop"
  profile="balanced"
  log="connected"

fi

echo "$log" | systemd-cat -t pwr-manage

# Set cpu scheduling driver
echo "$driver" | tee /sys/devices/system/cpu/amd_pstate/status

# Set cpu scheduling governor
for i in /sys/devices/system/cpu/*/cpufreq/scaling_governor; do
  echo "$governor" | tee "$i" >/dev/null
done

# Start or stop ryzenadj service if it exists
if systemctl is-enabled ryzenadj.service >/dev/null; then
  systemctl "$ryzenadj" ryzenadj.service
fi

# Set power profile
powerprofilesctl set "$profile"

# Update waybar icon if waybar is running
if pidof waybar >/dev/null; then
  pkill -SIGRTMIN+8 waybar
fi
