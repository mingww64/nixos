#!/usr/bin/env bash

# URL to fetch with curl
TARGET_URL="https://wttr.in/?format=1"

# How many seconds to wait between checks if offline
WAIT_SECONDS=3

# Loop until nmcli reports "full" connectivity.
# Redirect nmcli's potential error output (stderr) to /dev/null
# so it doesn't print anything if NetworkManager isn't running yet.
while [ "$(nmcli -t --fields CONNECTIVITY networking connectivity check 2>/dev/null)" != "full" ]; do
  sleep "$WAIT_SECONDS"
done

# Once the loop exits, the network is confirmed online ("full").
# Execute curl with the --silent flag (-s) to suppress progress meters
# and only output the actual fetched data.
curl --silent "$TARGET_URL"

exit 0
