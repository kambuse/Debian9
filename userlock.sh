 #!/bin/bash
            # Lock User.
            red='\e[1;31m'
            green='\e[0;32m'
            blue='\e[1;34m'
            NC='\e[0m'
            echo "Connecting to server..."
            sleep 0.2
            echo "Checking Permision..."
            sleep 0.3
            echo -e "${green}Permission Accepted...${NC}"
            sleep 1
            echo""

            read -p "Masukkan Username yang ingin anda kunci: " username
            egrep "^$username" /etc/passwd >/dev/null
            if [ $? -eq 0 ]; then
            # proses mengganti passwordnya
            passwd -l $username
            echo""
            echo "Script by Nazril Purnomo"
            echo " "
            echo "-----------------------------------------------"
            echo -e "Username ${blue}$username${NC} Sudah berhasil di ${red}KUNCI${NC}."
            echo -e "Akses Login untuk username ${blue}$username${NC} sudah kunci"
            echo "-----------------------------------------------"
            else
            echo "Username tidak ditemukan di server anda"
            exit 1
            fi
