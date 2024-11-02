#!/usr/bin/env bash

sleep 60

naptime=200

while true; do

  connected="$(cat /sys/class/power_supply/A*/online)"

  if [ "$connected" == "1" ]; then

    prev="$(powerprofilesctl get)"
    profile=$prev
    temp="$(cat /sys/class/thermal/thermal_zone0/temp)"

    if [ "$prev" == "performance" ]; then
      sleep "$naptime"
      continue
    fi

    if [ "$temp" -lt 55000 ]; then

      profile="power-saver"

    elif [ "$temp" -gt 80000 ]; then

      profile="balanced"

    fi

    if [ "$prev" != "$profile" ]; then

      powerprofilesctl set "$profile"
      echo "profile switched to $profile"

      # Update waybar icon if waybar is running
      if pidof waybar >/dev/null; then
        pkill -SIGRTMIN+8 waybar
      fi
    fi
  fi

  sleep "$naptime"

done
