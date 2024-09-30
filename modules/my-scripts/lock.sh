#!/usr/bin/env bash

swaylock
sleep 2

if pidof hyprland >/dev/null; then
  hyprctl dispatch dpms off
fi

if pidof niri >/dev/null; then
  niri msg action power-off-monitors
fi
