#!/usr/bin/env bash

# inspired by https://gitlab.com/lassegs/powerprofilecycle

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
