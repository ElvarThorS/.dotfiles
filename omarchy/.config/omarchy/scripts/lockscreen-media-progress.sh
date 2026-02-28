#!/bin/bash

set -euo pipefail

status=$(playerctl status 2>/dev/null || true)
if [ "$status" != "Playing" ]; then
  exit 0
fi

pos=$(playerctl position 2>/dev/null || echo 0)
len=$(playerctl metadata mpris:length 2>/dev/null || echo 0)

pos_s=$(printf "%.0f" "$pos")
len_s=$((len / 1000000))

if [ "$len_s" -le 0 ]; then
  exit 0
fi

bar_len=24
filled=$((pos_s * bar_len / len_s))
if [ "$filled" -lt 0 ]; then filled=0; fi
if [ "$filled" -gt "$bar_len" ]; then filled=$bar_len; fi

bar=""
i=0
while [ $i -lt $bar_len ]; do
  if [ $i -lt $filled ]; then
    bar+="█"
  else
    bar+="░"
  fi
  i=$((i + 1))
done

fmt() {
  local t=$1
  printf '%02d:%02d' $((t / 60)) $((t % 60))
}

printf '%s %s / %s\n' "$bar" "$(fmt "$pos_s")" "$(fmt "$len_s")"
