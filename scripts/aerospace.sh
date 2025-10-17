#!/bin/bash
set -e
source ./scripts/utils.sh

CONFIG_SRC="./apps/aerospace.toml"
CONFIG_DEST="$HOME/Library/Application Support/AeroSpace/aerospace.toml"

step "Applying Aerospace configuration..."

mkdir -p "$(dirname "$CONFIG_DEST")"

if [ -f "$CONFIG_DEST" ] && ! files_are_identical "$CONFIG_DEST" "$CONFIG_SRC"; then
  if confirm_override "$CONFIG_DEST" "$CONFIG_SRC" "Aerospace config"; then
    cp "$CONFIG_SRC" "$CONFIG_DEST"
    print_success "Aerospace config updated."
  else
    print_muted "Aerospace config left unchanged."
  fi
else
  cp "$CONFIG_SRC" "$CONFIG_DEST"
  print_success "Aerospace config installed."
fi
