#!/bin/bash

read -p "Username : " Login
read -p "Penambahan Masa Aktif (hari): " masaaktif
chage -E `date -d "$masaaktif days" +"%Y-%m-%d"` $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"

echo -e "--------------------------------" | lolcat
echo -e "Username       : $Login" | lolcat
echo -e "Aktif Sampai   : $exp" | lolcat
echo -e "================================" | lolcat
echo -e "Script by Nazril Purnomo" | lolcat
