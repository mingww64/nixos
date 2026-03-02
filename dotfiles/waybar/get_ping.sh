#pingCN=$(ping -c 1 1.2.4.8 | tail -1| awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)
curlMiui=$(curl -o /dev/null -s -w '%{time_total}'  https://www.miui.com/gernerate_204)
curlGoogle=$(curl -o /dev/null -s -w '%{time_total}'  https://www.google.com/gernerate_204)
CN=$(awk -v t="$curlMiui" 'BEGIN { printf "%.0f", t * 1000 }')
INT=$(awk -v t="$curlGoogle" 'BEGIN { printf "%.0f", t * 1000 }')
if [ "$CN" -ne 0 ] && [ "$INT" -ne 0 ]; then
    STATUS="󰴽 Connected"
elif [ "$CN" -ne 0 ]; then
    STATUS="󰴼 Local Only"
else
    STATUS=" Offline"
fi

jq -n -c --arg text "$STATUS" --arg tooltip "🇨🇳 $CN ms | 🌐 $INT ms" '{text: $text, tooltip: $tooltip}'
