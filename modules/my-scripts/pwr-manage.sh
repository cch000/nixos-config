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

# Set amd gpu profile
echo "$amdgpu" > /sys/class/drm/card1/device/power_dpm_state 

# Update waybar icon if waybar is running
if pidof waybar >/dev/null; then
  pkill -SIGRTMIN+8 waybar
fi
