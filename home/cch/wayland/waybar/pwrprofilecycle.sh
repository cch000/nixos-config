#!/usr/bin/env bash

# inspired by https://gitlab.com/lassegs/powerprofilecycle

PGET="powerprofilesctl get"

case $($PGET) in
performance)
  echo 󰓅 && exit 0
  ;;
power-saver)
  echo 󰾆 && exit 0
  ;;
balanced)
  echo 󰾅 && exit 0
  ;;
esac
