#!/usr/bin/env bash

# inspired by https://gitlab.com/lassegs/powerprofilecycle

if [ "${1:-default}" == "-n" ]; then

  PGET="$(cat /sys/firmware/acpi/platform_profile)"

  case $PGET in
  performance)
    powerprofilesctl set power-saver
    ;;
  quiet)
    powerprofilesctl set balanced
    ;;
  balanced)
    powerprofilesctl set performance
    ;;
  esac
fi

PGET="$(cat /sys/firmware/acpi/platform_profile)"

case $PGET in
performance)
  echo 󰓅 && exit 0
  ;;
quiet)
  echo 󰾆 && exit 0
  ;;
balanced)
  echo 󰾅 && exit 0
  ;;
esac
