#!/usr/bin/env bash

connected="$(echo /sys/class/power_supply/A*)/online"

#check if the laptop is plugged in
if [[ $(cat "$connected") == "0" ]]; then

  driver="passive"
  governor="conservative"
  profile="power-saver"
  log="disconnected"

else

  driver="active"
  governor="performance"
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

# Set power profile
powerprofilesctl set "$profile"

# Update waybar icon if waybar is running
if pidof waybar >/dev/null; then
  pkill -SIGRTMIN+8 waybar
fi
