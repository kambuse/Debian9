#!/bin/bash
echo "" > /root/user.db
datenow=$(date +%s)
echo -e "=================================================" | lolcat
printf '%40s%-10s%-5s\n' "Hapus Akun SSH/OpenVPN Expired" | lolcat
echo -e "-------------------------------------------------" | lolcat
printf '%-20s%-21s%-20s\n' "Username" "Expired" "Status" | lolcat
echo -e "-------------------------------------------------" | lolcat
for user in $(awk -F: '{print $1}' /etc/passwd); do
        expdate=$(chage -l $user|awk -F: '/Account expires/{print $2}')
        echo $expdate|grep -q never && continue
        datanormal=$(date -d"$expdate" '+%d/%m/%Y')
        tput setaf 3 ; tput bold ; printf '%-20s%-21s%s' $user $datanormal ; tput sgr0
        expsec=$(date +%s --date="$expdate")
        diff=$(echo $datenow - $expsec|bc -l)
        tput setaf 2 ; tput bold
        echo $diff|grep -q ^\- && echo "Aktif" && continue
        tput setaf 1 ; tput bold
        echo "Hapus"
        pkill -f $user
        userdel $user
        grep -v ^$user[[:space:]] /root/user.db > /tmp/ph ; cat /tmp/ph > /root/user.db
done
echo -e "=================================================" | lolcat
echo -e "Script by Nazril Purnomo" | lolcat
