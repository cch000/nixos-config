#!/usr/bin/env bash

pwr_supply=$(echo /sys/class/power_supply/A*)
connected="$pwr_supply/online"

bat=$(echo /sys/class/power_supply/BAT*)
bat_status="$bat/status"

prev=0

while true; do

  #check if the laptop is plugged
  if [[ $(cat "$connected") == "0" ]]; then

    driver="passive"
    governor="conservative"
    ryzenadj="start"
    profile="power-saver"

  else

    driver="active"
    governor="performance"
    ryzenadj="stop"
    profile="balanced"

  fi

  if [[ $prev != "$governor" ]]; then

    echo "$driver" | tee /sys/devices/system/cpu/amd_pstate/status

    for i in /sys/devices/system/cpu/*/cpufreq/scaling_governor; do
      echo "$governor" | tee "$i" >/dev/null
    done

    systemctl "$ryzenadj" ryzenadj.service

    # Set power profile
    powerprofilesctl set "$profile"

    # Update waybar icon
    pkill -SIGRTMIN+8 waybar

  fi

  prev=$governor

  #wait for the next power change event
  inotifywait -qq "$bat_status"

done
