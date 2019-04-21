#!/usr/bin
if [ $1 ];then
port_dropbear=$1
log=/var/log/secure
loginsukses='Password auth succeeded'
echo ' '
echo ' '
echo " Dropbear Users Login Monitor "
echo "---------------------------------------------------------------"
echo " Tanggal/Jam    | PID  | Username | Dari Host "
echo "---------------------------------------------------------------"
pids=`ps ax |grep dropbear |grep " $port_dropbear" |awk -F" " '{print $1}'`
for pid in $pids
do
pidlogs=`grep $pid $log |grep "$loginsukses" |awk -F" " '{print $3}'`
i=0
for pidend in $pidlogs
do
let i=i+1
done
if [ $pidend ];then
login=`grep $pid $log |grep "$pidend" |grep "$loginsukses"`
PID=$pid
user=`echo $login |awk -F" " '{print $10}' | sed -r "s/'/ /g"`
waktu=`echo $login |awk -F" " '{print $2,$3}'`
while [ ${#waktu} -lt 13 ]
do
waktu=$waktu" "
done

while [ ${#user} -lt 16 ]
do
user=$user" "
done
while [ ${#PID} -lt 8 ]
do
PID=$PID" "
done

fromip=`echo $login |awk -F" " '{print $12}' |awk -F":" '{print $1}'`
echo " $waktu| $PID | $user| $fromip "
fi
done
echo "---------------------------------------------------------------"
echo " Monitor User Login SSH "
else
echo " Gunakan perintah : sh userlogin.sh [port]"
echo " contoh : sh sh userlogin.sh 443"
echo \n
echo \n
fi
exit 0
