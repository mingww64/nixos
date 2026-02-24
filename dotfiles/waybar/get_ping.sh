#pingCN=$(ping -c 1 1.2.4.8 | tail -1| awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)
curlMiui=$(curl -o /dev/null -s -w '%{time_total}'  https://www.miui.com/gernerate_204)
curlGoogle=$(curl -o /dev/null -s -w '%{time_total}'  https://www.google.com/gernerate_204)
CN=$(echo "$curlMiui * 1000" | bc -l| cut -d '.' -f 1)
INT=$(echo "$curlGoogle * 1000" | bc -l| cut -d '.' -f 1)
echo "🇨🇳$CN 🌐️ $INT"
