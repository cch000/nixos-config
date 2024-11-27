#!/usr/bin/env bash

connected="$(cat /sys/class/power_supply/A*/online)"

#check if the laptop is plugged in
if [[ $connected == "0" ]]; then

  profile="power-saver"
  amdgpu="battery"

else

  profile="balanced"
  amdgpu="balanced"

fi

# Set power-profile
powerprofilesctl set $profile

# Check which one is the igpu and set amd gpu profile
if [[ $(cat /sys/class/drm/card2/device/vendor) == "0x1002" ]]; then

  echo "$amdgpu" >/sys/class/drm/card2/device/power_dpm_state

else

  echo "$amdgpu" >/sys/class/drm/card1/device/power_dpm_state

fi

# Enable/disable panel_od
echo "$connected" >/sys/bus/platform/devices/asus-nb-wmi/panel_od

# Update waybar icon if waybar is running
if pidof waybar >/dev/null; then
  pkill -SIGRTMIN+8 waybar
fi
