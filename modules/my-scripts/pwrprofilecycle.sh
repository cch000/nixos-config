#!/usr/bin/env bash

profile="$(powerprofilesctl get)"

if [ "${1:-default}" == "-n" ]; then

  case $profile in
  performance)
    profile=power-saver
    ;;
  power-saver)
    profile=balanced
    ;;
  balanced)
    profile=performance
    ;;
  esac

  powerprofilesctl set "$profile"
fi

case $profile in
performance)
  echo 󰓅
  ;;
power-saver)
  echo 󰾆
  ;;
balanced)
  echo 󰾅
  ;;
esac
