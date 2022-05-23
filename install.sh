#!/bin/bash
clear
echo "****************************************************************************"
echo " 
 ####      #####     ####    #####
  ##      ##   ##   ##  ##  ##   ##
  ##      ##   ##  ##       ##   ##
  ##      ##   ##  ##       ##   ##
  ##   #  ##   ##  ##  ###  ##   ##
  ##  ##  ##   ##   ##  ##  ##   ##
 #######   #####     #####   #####
"
#Variables para guardar si los programas están instalados o no.
instalado_git=0
instalado_mysql=0
instalado_apache=0
insladado_php=0
instalado_dhcp=0
instalado_dns=0
instalado_nmap=0


#Comprueba que está instalado el paquete de git y 
#lo marca con color verde si está instalado y rojo si no lo está.
echo -e "\e[32m"
git --version
echo -e "\e[0m"
if [ $? -eq 0 ]; then
    echo -e "\e[32mGit instalado\e[0m"
    instalado_git=1
else
    echo -e "\e[31mGit no instalado\e[0m"
    instalado_git=0
fi

#Comprueba que está instalado Apache2 
#y lo marca con color verde si está instalado y rojo si no lo está.
if [ -f /etc/apache2/apache2.conf ]; then
    echo -e "\e[32mApache2 instalado\e[0m"
    instalado_apache=1
else
    echo -e "\e[31mApache2 no instalado\e[0m"
    instalado_apache=0
fi

#Comprueba que está instalado los paquetes de PHP y PHP-MySQL
#y lo marca con color verde si están instalados y rojo si no lo están.
if [ -d /etc/php ]; then
    echo -e "\e[32mPHP instalado\e[0m"
    instalado_php=1
else
    echo -e "\e[31mPHP no instalado\e[0m"
    instalado_php=0
fi

#Comprueba que está instalado DHCP
#y lo marca con color verde si está instalado y rojo si no lo está.
if [ -f /etc/dhcp/dhcpd.conf ]; then
    echo -e "\e[32mDHCP instalado\e[0m"
    instalado_dhcp=1
else
    echo -e "\e[31mDHCP no instalado\e[0m"
    instalado_dhcp=0
fi

#Comprueba que está instalado DNS
#y lo marca con color verde si está instalado y rojo si no lo está.
if [ -f /etc/bind/named.conf ]; then
    echo -e "\e[32mDNS instalado\e[0m"
    instalado_dns=1
else
    echo -e "\e[31mDNS no instalado\e[0m"
    instalado_dns=0
fi

#Comprueba que está instalado mysql-server
#y lo marca con color verde si está instalado y rojo si no lo está.
if [ $(dpkg -l | grep mysql-server | wc -l) -eq 0 ]; then
    echo -e "\e[31mMysql-server no instalado\e[0m"
    instalado_mysql=0
else
    echo -e "\e[32mMysql-server instalado\e[0m"
    instalado_mysql=1
fi

#Comprueba que está instalada la herramienta Nmap
#y lo marca con color verde si está instalado y rojo si no lo está.
if [ $(dpkg -l | grep nmap | wc -l) -eq 0 ]; then
    echo -e "\e[31mNmap no instalado\e[0m"
    instalado_nmap=0
else
    echo -e "\e[32mNmap instalado\e[0m"
    instalado_nmap=1
fi

#Pregunta por la opción que el usuario quiere ejecutar.
suma_instalados=$(($instalado_git + $instalado_mysql + $instalado_apache + $instalado_php + $instalado_dhcp + $instalado_dns + $instalado_nmap))
echo "****************************************************************************"
if [ $suma_instalados -eq 7 ]; then
    ./inicio.sh
else
    #De color rojo.
    echo -e "\e[31m"
    echo "No están instalados todos los paquetes/herramientas."
    read -p "Seleccione una opcion: [1] Instalar todo [2] Elegir programa a instalar [3] Seguir " opcion
    echo -e "\e[0m"
    if [ $opcion -eq 1 ]; then
        #Instala todos los paquetes.
        sudo apt-get update
        #Git
        if [ $instalado_git -eq 0 ]; then
            echo "Instalando Git..."
            sudo apt-get install git -y
        fi
        #DHCP

        if [ $instalado_dhcp -eq 0 ]; then
            echo "Instalando DHCP..."
            sudo apt-get install isc-dhcp-server -y
            #Si se ha instalado cambia la variable a 1.
            if [ -f /etc/dhcp/dhcpd.conf ]; then
                instalado_dhcp=1
            fi
        fi

        #Configurar DHCP (option domain-name "variable")
        #Ejemplo: option domain-name "instragram.com";
        if [ $instalado_dhcp -eq 1 ]; then
            echo "Configurando DHCP..."
            read -p "Introduzca el dominio: " dominio
            sed -i 's/option domain-name ".*";/option domain-name "'$dominio'";/g' /etc/dhcp/dhcpd.conf
        fi

        #Configurar /etc/resolv.conf con la variable $dominio
        #Ejemplo: domain-name instragram.com
        #search instragram.com
        #nameserver IP_Propia
        if [ $instalado_dhcp -eq 1 ]; then
            echo "Configurando /etc/resolv.conf..."
            #EL DOMAIN NAME NO FUNCIONA AUN!!!!!!!!!!!!!!!!!!!!!!!!!
            sed -i 's/domain-name .*;/domain-name '$dominio';/g' /etc/resolv.conf
            sed -i 's/search.*/search '$dominio'/g' /etc/resolv.conf
            #Falta poner la IP del servidor DNS en nameserver
        fi

        #DNS
        if [ $instalado_dns -eq 0 ]; then
            echo "Instalando DNS..."
            sudo apt-get install bind9 -y
            #Si se ha instalado cambia la variable a 1.
            if [ -f /etc/bind/named.conf.options ]; then
                instalado_dns=1
            fi
        fi

        #Configurar DNS
        #Copia el archivo /etc/bind/db.local a /etc/bind/db.$dominio
        #Ejemplo: db.$dominio
        if [ $instalado_dns -eq 1 ]; then
            echo "Configurando DNS..."
            read -p "Introduzca el dominio para el DNS (el mismo de antes): " dominio
            cp /etc/bind/db.local /etc/bind/db.$dominio
            #Si db.$dominio existe modifica /etc/bind/db.$dominio.
            #IN SOA debianservidor.$dominio.com. root.debianservidor.$dominio.com. (
            #IN NS debianservidor.$dominio.com.
            if [ -f /etc/bind/db.$dominio ]; then
                #NO FUNCIONA AUN!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                sed -i 's/@ IN  SOA .*;/@ IN  SOA '$dominio'.com. root.'$dominio'.com. (/g' /etc/bind/db.$dominio
                sed -i 's/@ IN  NS .*;/@ IN  NS '$dominio'.com./g' /etc/bind/db.$dominio
            fi

            #Configurar named.conf.local con la zona del dominio.
            #Ejemplo: zone "instragram.com" {
            #type master;
            #file "db.instragram.com";
            #};
            if [ -f /etc/bind/named.conf.local ]; then
                echo "Configurando named.conf.local..."
                echo "zone \"$dominio\" {" >> /etc/bind/named.conf.local
                echo "type master;" >> /etc/bind/named.conf.local
                echo "file \"db.$dominio\";" >> /etc/bind/named.conf.local
                echo "};" >> /etc/bind/named.conf.local
            fi
        fi
        #Apache2
        if [ $instalado_apache -eq 0 ]; then
            echo "Instalando Apache2..."
            apt-get install apache2 -y
        fi
        /etc/init.d/apache2 start

        #PHP
        if [ $instalado_php -eq 0 ]; then
            echo "Instalando PHP..."
            apt-get install php libapache2-mod-php php-mysql -y
        fi
        #Nmap
        if [ $instalado_nmap -eq 0 ]; then
            echo "Instalando Nmap..."
            apt-get install nmap -y
        fi
    elif [ $opcion -eq 2 ]; then
        ./instalar.sh
    elif [ $opcion -eq 3 ]; then
        ./inicio.sh
    fi
fi