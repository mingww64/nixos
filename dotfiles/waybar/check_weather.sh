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

# Fetch weather as JSON with a 3 second max timeout
weather=$(curl -s --max-time 3 "https://wttr.in/?format=j1" 2>/dev/null)

if [ -n "$weather" ] && echo "$weather" | jq -e '.current_condition[0]' >/dev/null 2>&1; then
  # Use wttr.in if successful
  temp=$(echo "$weather" | jq -r '.current_condition[0].temp_C')
  condition=$(echo "$weather" | jq -r '.current_condition[0].weatherDesc[0].value')
  echo "{\"text\": \"$temp°C\", \"tooltip\": \"$condition\"}"
  exit 0
fi

# Fallback: wttr.in failed, try Open-Meteo as a free alternative (guessing location based on IP using ipapi first, then querying open-meteo)
# First get coordinates
coords=$(curl -s --max-time 2 https://ipapi.co/json/)
if [ -n "$coords" ]; then
  lat=$(echo "$coords" | jq -r '.latitude')
  lon=$(echo "$coords" | jq -r '.longitude')
  
  if [ "$lat" != "null" ] && [ "$lon" != "null" ]; then
    # Then get weather
    weather_fallback=$(curl -s --max-time 3 "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code")
    
    if [ -n "$weather_fallback" ] && echo "$weather_fallback" | jq -e '.current' >/dev/null 2>&1; then
        temp=$(echo "$weather_fallback" | jq -r '.current.temperature_2m')
        code=$(echo "$weather_fallback" | jq -r '.current.weather_code')
        
        # Basic mapping of WMO codes to descriptions
        condition="Clear"
        [ "$code" -ge 1 ] && [ "$code" -le 3 ] && condition="Cloudy"
        [ "$code" -ge 45 ] && [ "$code" -le 48 ] && condition="Fog"
        [ "$code" -ge 51 ] && [ "$code" -le 67 ] && condition="Rain"
        [ "$code" -ge 71 ] && [ "$code" -le 77 ] && condition="Snow"
        [ "$code" -ge 80 ] && [ "$code" -le 82 ] && condition="Showers"
        [ "$code" -ge 95 ] && [ "$code" -le 99 ] && condition="Thunderstorm"
        
        echo "{\"text\": \"$temp°C\", \"tooltip\": \"$condition\"}"
        exit 0
    fi
  fi
fi

# Both APIs failed, output error
echo '{"text": "", "tooltip": "Weather Unavailable"}'
exit 0
