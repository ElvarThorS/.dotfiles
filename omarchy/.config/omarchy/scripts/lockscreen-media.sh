#!/bin/bash

set -euo pipefail

cache_dir="$HOME/.cache/omarchy/lockscreen"
cache_file="$cache_dir/cover.png"
blank_png_b64="iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII="
mkdir -p "$cache_dir"

status=$(playerctl status 2>/dev/null || true)
if [ "$status" != "Playing" ]; then
  printf '%s' "$blank_png_b64" | base64 -d > "$cache_file" 2>/dev/null || true
  exit 0
fi

art_url=$(playerctl metadata mpris:artUrl 2>/dev/null || true)
if [ -n "$art_url" ]; then
  if [[ "$art_url" == file://* ]]; then
    src="${art_url#file://}"
    cp -f "$src" "$cache_file" 2>/dev/null || true
  else
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL "$art_url" -o "$cache_file" 2>/dev/null || true
    elif command -v wget >/dev/null 2>&1; then
      wget -qO "$cache_file" "$art_url" 2>/dev/null || true
    fi
  fi
fi

artist=$(playerctl metadata artist 2>/dev/null || true)
title=$(playerctl metadata title 2>/dev/null || true)
album=$(playerctl metadata album 2>/dev/null || true)

parts=()
[ -n "$artist" ] && parts+=("$artist")
[ -n "$title" ] && parts+=("$title")
[ -n "$album" ] && parts+=("$album")

[ ${#parts[@]} -eq 0 ] && exit 0

out="${parts[0]}"
for part in "${parts[@]:1}"; do
  out+=" / $part"
done

printf '%s\n' "$out"
