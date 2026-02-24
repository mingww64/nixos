#media=$(playerctl metadata -s -f "({{playerName}}) {{artist}} - {{title}}")
media=$(playerctl metadata -s -f "{{title}}")
player_status=$(playerctl status -s)

if [[ $player_status = "Playing" ]]; then
	song_status=''
elif [[ $player_status = "Paused" ]]; then
	song_status=''
else
	song_status='Music stopped'
fi

echo -e "$song_status $media"
