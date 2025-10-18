#!/usr/bin/env bash
set -euo pipefail

# ---- safety / helpers ----
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS only." >&2
  exit 1
fi
log(){ printf "\033[1;32m==>\033[0m %s\n" "$*"; }

log "Removing deletable Apple apps from /Applications (safe)"
for APP in "GarageBand.app" "iMovie.app" "Keynote.app" "Numbers.app" "Pages.app"; do
  if [ -d "/Applications/$APP" ]; then
    log "Removing /Applications/$APP"
    sudo rm -rf "/Applications/$APP"
  fi
done

log "Purging large GarageBand/Logic content if present"
sudo rm -rf "/Library/Application Support/GarageBand" || true
sudo rm -rf "/Library/Audio/Apple Loops" || true
sudo rm -rf "/Library/Audio/Apple Loops Index" || true
rm -rf "$HOME/Library/Application Support/GarageBand" || true


log "Disabling background agents for built-in apps you don't want (per-user)"
disable() { launchctl disable "gui/$UID/$1" 2>/dev/null || true; }

# News / Stocks
disable com.apple.news.notification
disable com.apple.newsd
disable com.apple.stocks

# TV / Music / Podcasts media helpers
disable com.apple.tvhelper
disable com.apple.TVRemoteConnectionService
disable com.apple.MusicLibraryService
disable com.apple.MusicNotification
disable com.apple.podcasts

# Photos analysis (often chatty)
disable com.apple.photoanalysisd

# Siri suggestions / Spotlight extras
disable com.apple.suggestions
disable com.apple.parsecd

log "Hiding built-in apps from Spotlight results (best-effort)"
defaults write com.apple.Spotlight orderedItems -array \
  '{enabled = 1; name = "APPLICATIONS";}' \
  '{enabled = 1; name = "SYSTEM_PREFS";}' \
  '{enabled = 0; name = "MENU_EXPRESSION";}' \
  '{enabled = 0; name = "MENU_OTHER";}' \
  '{enabled = 0; name = "MENU_CONVERSION";}' \
  '{enabled = 0; name = "MENU_DEFINITION";}' \
  '{enabled = 0; name = "MENU_SPOTLIGHT_SUGGESTIONS";}'
killall mds >/dev/null 2>&1 || true
mdutil -i on / >/dev/null 2>&1 || true

log "Turning off notifications for noisy Apple apps (best-effort)"
for BID in \
  com.apple.news \
  com.apple.stocks \
  com.apple.TV \
  com.apple.podcasts \
  com.apple.Music \
  com.apple.iCal \
  com.apple.reminders \
  com.apple.mail
do
  defaults write "$BID" doNotDisturb -bool true 2>/dev/null || true
done

log "Done. Log out/in or reboot for everything to settle."
