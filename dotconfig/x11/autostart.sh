#!/bin/bash

# Color definitions (assuming you have a '~/nord' file for colors)
. ~/nord

# Update Interval (seconds)
update_interval=3600

# --- FUNCTIONS ---

# Package updates check (adjust if not using aptitude)
pkg_updates() {
  updates_available="$(aptitude search '~U' | wc -l)"  # More direct count

  if [[ $updates_available -eq 0 ]]; then
    printf "^c$green^  fully updated "
  else
    printf "^c$green^  $updates_available updates "
  fi
}

# Memory usage
mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

# Date and time
clock() {
  printf "^c$black^ ^b$darkblue^  "
  printf "^c$black^^b$blue^ $(date '+%b %d - %H:%M') "
}

# Bandwidth calculation
bandwidth() {
  interface="ens33"  # Adjust to your network interface

  old_rx=$(awk "/$interface:/ {print \$2}" /proc/net/dev)
  old_tx=$(awk "/$interface:/ {print \$10}" /proc/net/dev)

  sleep 1
  new_rx=$(awk "/$interface:/ {print \$2}" /proc/net/dev)
  new_tx=$(awk "/$interface:/ {print \$10}" /proc/net/dev)

  rx_diff=$((new_rx - old_rx))
  tx_diff=$((new_tx - old_tx))

  rx_speed=$(echo "scale=2; $rx_diff / 1024" | bc)
  tx_speed=$(echo "scale=2; $tx_diff / 1024" | bc)

  printf "^c$mint^⬇$rx_speed KB^c$mint^⬆$tx_speed KB "
}

volumeicon &
# --- MAIN LOOP ---

# Initial update check
updates=$(pkg_updates)

while true; do
  # Package updates at interval
  if [[ $((`date +%s` % update_interval)) -eq 0 ]]; then
      updates=$(pkg_updates)
  fi

  # Build status bar content
  status_text="$updates $(bandwidth) $(mem) $(clock)"

  # Update status bar (using xsetroot)
  xsetroot -name "$status_text"

  sleep 1
done
