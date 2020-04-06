#!/bin/bash
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;

flag=0

echo

function create_user() {
	useradd -M $uname
	echo "$uname:$pass" | chpasswd
	usermod -e $expdate $uname

	myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
	myip2="s/xxxxxxxxx/$myip/g";	
	wget -qO /tmp/client.ovpn "https://raw.githubusercontent.com/kambuse/Debian9/kambuse-Debian-9/client-1194.conf"
	sed -i 's/remote xxxxxxxxx 1194/remote xxxxxxxxx 443/g' /tmp/client.ovpn
	sed -i $myip2 /tmp/client.ovpn
	echo ""
	echo "========================="
	echo "Host IP : $myip"
	echo "Port    : 443/22/80"
	echo "Squid   : 8080/3128"
	echo "========================="
	echo "Script by Nazril Purnomo , Gunakan akun dengan bijak"
	echo "========================="
}

function renew_user() {
	echo "New expiration date for $uname: $expdate...";
	usermod -e $expdate $uname
}

function delete_user(){
	userdel $uname
}

function expired_users(){
	cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
	totalaccounts=`cat /tmp/expirelist.txt | wc -l`
	for((i=1; i<=$totalaccounts; i++ )); do
		tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
		username=`echo $tuserval | cut -f1 -d:`
		userexp=`echo $tuserval | cut -f2 -d:`
		userexpireinseconds=$(( $userexp * 86400 ))
		todaystime=`date +%s`
		if [ $userexpireinseconds -lt $todaystime ] ; then
			echo $username
		fi
	done
	rm /tmp/expirelist.txt
}

function not_expired_users(){
    cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
    totalaccounts=`cat /tmp/expirelist.txt | wc -l`
    for((i=1; i<=$totalaccounts; i++ )); do
        tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
        username=`echo $tuserval | cut -f1 -d:`
        userexp=`echo $tuserval | cut -f2 -d:`
        userexpireinseconds=$(( $userexp * 86400 ))
        todaystime=`date +%s`
        if [ $userexpireinseconds -gt $todaystime ] ; then
            echo $username
        fi
    done
	rm /tmp/expirelist.txt
}

function used_data(){
	myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`
	myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`
	ifconfig $myint | grep "RX bytes" | sed -e 's/ *RX [a-z:0-9]*/Received: /g' | sed -e 's/TX [a-z:0-9]*/\nTransfered: /g'
}

	clear
	echo ""
	echo "--------------- Selamat datang di Server - IP: $myip ---------------"
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
	tram=$( free -m | awk 'NR==2 {print $2}' )
	swap=$( free -m | awk 'NR==4 {print $2}' )
	up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')

	echo -e "\e[032;1mCPU model:\e[0m $cname"
	echo -e "\e[032;1mNumber of cores:\e[0m $cores"
	echo -e "\e[032;1mCPU frequency:\e[0m $freq MHz"
	echo -e "\e[032;1mTotal amount of ram:\e[0m $tram MB"
	echo -e "\e[032;1mTotal amount of swap:\e[0m $swap MB"
	echo -e "\e[032;1mSystem uptime:\e[0m $up"
	echo -e "\e[032;1mBy \e[0m Ahmad Thoriq Najahi"
	echo "------------------------------------------------------------------------------"
	echo -e "\e[031;1m 1\e[0m) Buat Akun SSH/OpenVPN (\e[34;1muser-add\e[0m)"
	echo -e "\e[031;1m 2\e[0m) Generate Akun SSH/OpenVPN (\e[34;1muser-gen\e[0m)"
	echo -e "\e[031;1m 3\e[0m) Generate Akun Trial (\e[34;1muser-trial\e[0m)"
	echo -e "\e[031;1m 4\e[0m) Ganti Password Akun SSH/VPN (\e[34;1muser-pass\e[0m)"
	echo -e "\e[031;1m 5\e[0m) Tambah Masa Aktif Akun SSH/OpenVPN (\e[34;1muser-renew\e[0m)"
	echo -e "\e[031;1m 6\e[0m) Hapus Akun SSH/OpenVPN (\e[34;1muser-del\e[0m)"
	echo -e "\e[031;1m 7\e[0m) Cek Login Dropbear & OpenSSH (\e[34;1muser-login\e[0m)"
	echo -e "\e[031;1m 8\e[0m) Auto Limit Multi Login (\e[34;1mauto-limit\e[0m)"
	echo -e "\e[031;1m 9\e[0m) Melihat detail user SSH & OpenVPN (\e[34;1muser-detail\e[0m)"
	echo -e "\e[031;1m10\e[0m) Daftar Akun dan Expire Date (\e[34;1muser-list\e[0m)"
	echo -e "\e[031;1m11\e[0m) Delete Akun Expire (\e[34;1mdelete-user-expire\e[0m)"
	echo -e "\e[031;1m12\e[0m) Kill Multi Login (\e[34;1mauto-kill-user\e[0m)"
	echo -e "\e[031;1m13\e[0m) Auto Banned Akun (\e[34;1mbanned-user\e[0m)"
	echo -e "\e[031;1m14\e[0m) Unbanned Akun (\e[34;1munbanned-user\e[0m)"
	echo -e "\e[031;1m15\e[0m) Mengunci Akun SSH & OpenVPN (\e[34;1muser-lock\e[0m)"
	echo -e "\e[031;1m16\e[0m) Membuka user SSH & OpenVPN yang terkunci (\e[34;1muser-unlock\e[0m)"
	echo -e "\e[031;1m17\e[0m) Melihat daftar user yang terkick oleh perintah user-limit (\e[34;1mlog-limit\e[0m)"
	echo -e "\e[031;1m18\e[0m) Melihat daftar user yang terbanned oleh perintah user-ban (\e[34;1mlog-ban\e[0m)"
	echo -e "\e[031;1m19\e[0m) Cek Lokasi User (\e[34;1mcek-lokasi-user\e[0m)"
	echo -e "\e[031;1m20\e[0m) Set Auto Reboot (\e[34;1mauto-reboot\e[0m)"
	echo -e "\e[031;1m21\e[0m) Speedtest (\e[34;1mcek-speedttes-vps\e[0m)"
	echo -e "\e[031;1m22\e[0m) Cek Ram (\e[34;1mcek-ram\e[0m)"
	echo -e "\e[031;1m23\e[0m) Edit Port (\e[34;1medit-port\e[0m)"
  	echo -e "\e[031;1m24\e[0m) Cek Port Aktif (\e[34;1mport-aktif\e[0m)"
  	echo -e "\e[031;1m25\e[0m) Non Aktif User Expired (\e[34;1mdisable-user-expire\e[0m)"
  	echo -e "\e[031;1m26\e[0m) Daftar User Expired (\e[34;1muser-expired-list\e[0m)"
	echo -e "\e[031;1m27\e[0m) Restart (\e[34;1mrestart\e[0m)"
	echo ""
	echo -e "\e[031;1m x\e[0m) Exit"
	read -p "Masukkan pilihan anda, kemudian tekan tombol ENTER: " option1
	case $option1 in
        1)  
          clear
          user-add
          ;;
        2)  
          clear
          user-gen
          ;;
        3)	
          clear
          user-trial
	  	  ;;	
        4)
          clear
          user-pass
          ;;
        5)
          clear
          user-renew
	      ;;
        6)
           clear
           user-del
          ;;		
	 	7)
	   	   clear
	   	   user-login
	      ;;
	 	8)
           clear
	       auto-limit
	   	  ;;	
	 	9)
	       clear
           user-detail
          ;;
        10)
           clear
           user-list
          ;;
        11)
           clear
           delete-user-expire
	      ;;
		12)
		   clear
		   read -p "Isikan Maximal User Login (1-2): " MULTILOGIN
		   echo "    AUTO KILL MULTI LOGIN    "    
		   echo "-----------------------------"
	           	auto-kill-user  $MULTILOGIN
		   		autokill  $MULTILOGIN
	       echo "-----------------------------"
	       echo "AUTO KILL MULTI LOGIN SELESAI"
	      ;;
    	13)
       	   clear
           banned-user
	      ;;
		14)
           clear
           unbanned-user
	      ;;
        15)
	       clear
           user-lock
	      ;;
    	16)
       	   clear
           user-unlock
	      ;;
		17)
	       clear
	       log-limit
	      ;;
		18)
           clear
           log-ban
	      ;;
    	19)
	       clear
	       user-login
           echo "Contoh: 49.0.35.16 lalu Enter"
           read -p "Ketik Salah Satu Alamat IP User: " userip
           curl ipinfo.io/$userip
         ;;
		20)
	       clear
           auto-reboot
         ;;
		21)
		   clear
	        #!/bin/bash
	        red='\e[1;31m'
	        green='\e[0;32m'
	        blue='\e[1;34m'
	        NC='\e[0m'
	        echo "Speed Tes Server"
	        cek-speedttes-vps
          ;;
        22)
           clear
           cek-ram
          ;;
        23)
           clear
           edit-port
	      ;;
        24)
           clear
           port-aktif
	      ;;
        25)
           clear
           disable-user-expire
	      ;;
        26)
           clear
           user-expired-list
	      ;;
        27)
	       clear
	       reboot
          ;;
        x)
          ;;
        *) menu;;
        esac
