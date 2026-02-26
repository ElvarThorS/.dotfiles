#!/bin/bash

status=$(playerctl status 2>/dev/null)
if [ "$status" = "Playing" ]; then
  printf '󰏤'
elif [ "$status" = "Paused" ]; then
  printf '󰐊'
fi
