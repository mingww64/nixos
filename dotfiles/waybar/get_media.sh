player_status=$(playerctl status -s)

if [ -z "$player_status" ]; then
    echo '{"text": "Music stopped", "alt": "Stopped", "class": "Stopped"}'
    exit 0
fi

media=$(playerctl metadata --format "{{title}}" 2>/dev/null || echo "")
media=${media//\"/\\\"}

if [ -n "$media" ]; then
    media=" $media"
fi

echo "{\"text\": \"$media\", \"alt\": \"$player_status\", \"class\": \"$player_status\"}"
