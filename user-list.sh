#!/bin/bash

echo "-------------------------------" | lolcat
echo "USERNAME          EXP DATE     " | lolcat
echo "-------------------------------" | lolcat
while read expired
do
        AKUN="$(echo $expired | cut -d: -f1)"
        ID="$(echo $expired | grep -v nobody | cut -d: -f3)"
        exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
        if [[ $ID -ge 1000 ]]; then
		datanormal=$(date -d"$exp" '+%d/%m/%Y')
        printf "%-17s %2s\n" "$AKUN" "$datanormal" | lolcat
        fi
done < /etc/passwd
JUMLAH="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
echo "-------------------------------" | lolcat
echo "Jumlah akun: $JUMLAH user" | lolcat
echo "-------------------------------" | lolcat
echo -e "Script By Nazril Purnomo" | lolcat
