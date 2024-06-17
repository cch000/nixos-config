#!/usr/bin/env bash

while true; do

  connected="$(cat /sys/class/power_supply/A*/online)"

  if [ "$connected" == "1" ]; then

    prev=$(powerprofilesctl get)
    profile=$prev
    load1min=$(LC_NUMERIC="en_US.UTF-8" printf %.0f "$(cut -d" " -f1 /proc/loadavg)")

    if [[ load1min -lt 7 && $(supergfxctl -S) != "active" ]]; then

      profile="power-saver"

    fi

    if [ "$prev" != "$profile" ]; then
      powerprofilesctl set "$profile"

      # Update waybar icon if waybar is running
      if pidof waybar >/dev/null; then
        pkill -SIGRTMIN+8 waybar
      fi
    fi
  fi

  sleep 300

done
