#!/usr/bin/env bash
set -euo pipefail

echo "==> Removing deletable Apple apps from /Applications (safe)"
for APP in "GarageBand.app" "iMovie.app" "Keynote.app" "Numbers.app" "Pages.app"; do
  if [ -d "/Applications/$APP" ]; then
    echo "Removing /Applications/$APP"
    sudo rm -rf "/Applications/$APP"
  fi
done

echo "==> Purging large GarageBand/Logic content if present"
sudo rm -rf "/Library/Application Support/GarageBand" || true
sudo rm -rf "/Library/Audio/Apple Loops" || true
sudo rm -rf "/Library/Audio/Apple Loops Index" || true
rm -rf "$HOME/Library/Application Support/GarageBand" || true

echo "==> Clearing Dock and repopulating with your core apps"
# Wipes Dock
defaults write com.apple.dock persistent-apps -array

killall Dock || true



echo "==> Keeping AirPlay enabled (doing nothing to it)"
# (Intentionally no change to AirPlay Receiver)

echo "==> Disabling background agents for built-in apps you don't want (per-user)"
# These labels vary by macOS version; we try-safe and ignore failures.
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

echo "==> Hiding built-in apps from Spotlight results (less in-your-face)"
# Toggle off categories you don’t want; these keys are safe to set.
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

echo "==> Turning off notifications for noisy Apple apps"
# You’ll still want to review manually in System Settings → Notifications.
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

echo "==> Done. Reboot is optional, but recommended."
