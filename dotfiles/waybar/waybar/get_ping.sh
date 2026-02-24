pingCN=$(ping -c 1 1.2.4.8 | tail -1| awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)
curl=$(curl -o /dev/null -s -w '%{time_total}'  https://www.google.com/gernerate_204)
curlAB=$(echo "$curl * 1000" | bc -l| cut -d '.' -f 1)
echo "$pingCN ms|$curlAB ms"
