#!/bin/bash

read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif

IP=`dig +short myip.opendns.com @resolver1.opendns.com`
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "====Informasi SSH Account====" | lolcat
echo -e "Host           : $IP"  | lolcat
echo -e "Port OpenSSH   : 22"  | lolcat
echo -e "Port Dropbear  : 80,109, 110"  | lolcat
echo -e "Port SSL/TLS   : 443" | lolcat
echo -e "Port Squid     : 8080,8000"  | lolcat
echo -e "Config OpenVPN : http://$IP:85/client.ovpn"  | lolcat
echo -e "Username       : $Login "  | lolcat
echo -e "Password       : $Pass"  | lolcat
echo -e "-----------------------------"  | lolcat
echo -e "Aktif Sampai   : $exp"  | lolcat
echo -e "============================="  | lolcat
