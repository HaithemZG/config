#!/bin/bash

. $HOME/

# Existing functions
pkg_updates() {
  updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc -l)

  if [ -z "$updates" ]; then
    printf "^c$green^  Fully Updated "
  else
    printf "^c$green^  $updates"" updates "
  fi
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

clock() {
	printf "^c$black^ ^b$darkblue^  "
	printf "^c$black^^b$blue^ $(date '+%b %d - %H:%M') "
}

# Function to calculate bandwidth usage
bandwidth() {
    # Read network interface stats (adjust 'eth0' to your primary interface if needed)
    old_rx=$(cat /proc/net/dev | grep 'ens33' | awk '{print $2}')
    old_tx=$(cat /proc/net/dev | grep 'ens33' | awk '{print $10}')

    sleep 1 # One second interval

    # Read new stats
    new_rx=$(cat /proc/net/dev | grep 'ens33' | awk '{print $2}')
    new_tx=$(cat /proc/net/dev | grep 'ens33' | awk '{print $10}')

    # Calculate differences (in bytes)
    rx_diff=$((new_rx - old_rx))
    tx_diff=$((new_tx - old_tx))

    # Convert to human-readable units (example: KB/s)
    rx_speed=$(echo "scale=2; $rx_diff / 1024" | bc)
    tx_speed=$(echo "scale=2; $tx_diff / 1024" | bc)

    # Display bandwidth info
    printf "^c$mint^⬇$rx_speed KB^c$mint^⬆$tx_speed KB "
}

volumeicon &
# ... (Rest of your existing functions: pkg_updates, mem, clock)

while true; do
 # Existing updates
 [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
 interval=$((interval + 1))

 # Update status bar (adjust based on your status bar setup)
 sleep 1 && xsetroot -name "$updates $(bandwidth) $(mem) $(clock)"
done
