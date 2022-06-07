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
instalado_dhcp=0
instalado_mysql=0
instalado_apache=0
insladado_php=0
instalado_dns=0
instalado_nmap=0

#Variables con la instalación de los programas.
instalar_git="apt-get install git -y"
instalar_dhcp="apt-get install isc-dhcp-server -y"
instalar_dns="apt-get install bind9 -y"
instalar_apache="apt-get install apache2 -y"
instalar_php="apt-get install php libapache2-mod-php php-mysql -y"
instalar_nmap="apt-get install nmap -y"
instalar_mysql="apt-get install mysql-server -y"
instalar_mysql_add="mysql_secure_installation"

#Comprueba que está instalado el paquete de git y 
#lo marca con color verde si está instalado y rojo si no lo está.
echo -e "\e[0m"
#Comprueba que está instalado git.
if [ -x "$(command -v git)" ]; then
    echo -e "\e[32m Git instalado \e[0m"
    instalado_git=1
else
    echo -e "\e[31m Git no instalado \e[0m"
    instalado_git=0
fi

#Comprueba que está instalado Apache2 
#y lo marca con color verde si está instalado y rojo si no lo está.
if [ -f /etc/apache2/apache2.conf ]; then
    echo -e "\e[32m Apache2 instalado \e[0m"
    instalado_apache=1
else
    echo -e "\e[31m Apache2 no instalado \e[0m"
    instalado_apache=0
fi

#Comprueba que está instalado los paquetes de PHP y PHP-MySQL
#y lo marca con color verde si están instalados y rojo si no lo están.
if [ -x "$(command -v php)" ]; then
    echo -e "\e[32m PHP instalado \e[0m"
    instalado_php=1
else
    echo -e "\e[31m PHP no instalado \e[0m"
    instalado_php=0
fi

#Comprueba que está instalado DHCP
#y lo marca con color verde si está instalado y rojo si no lo está.
if [ -f /etc/dhcp/dhcpd.conf ]; then
    echo -e "\e[32m DHCP instalado \e[0m"
    instalado_dhcp=1
else
    echo -e "\e[31m DHCP no instalado \e[0m"
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
    echo -e "\e[32m Todos los paquetes están instalados \e[0m"
    echo -e "\e[35m Pulse cualquier tecla para continuar \e[0m"
    # Al pulsar cualquier tecla se ejecuta el script de inicio.
    read
    ./config.sh

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
            #Color verde.
            echo -e "\e[32m Instalando Git...\e[0m"
            $instalar_git
        fi

        #DHCP
        if [ $instalado_dhcp -eq 0 ]; then
            echo -e "\e[32m Instalando DHCP...\e[0m"
            $instalar_dhcp
            #Si se ha instalado cambia la variable a 1.
            if [ -f /etc/dhcp/dhcpd.conf ]; then
                instalado_dhcp=1
            fi
        fi

        #Configurar DHCP (option domain-name "variable")
        #Ejemplo: option domain-name "instragram.com";
        if [ $instalado_dhcp -eq 1 ]; then
            echo -e "\e[32m Configurando DHCP...\e[0m"
            # En magenta.
            echo -e "\e[35m"
            read -p "Introduzca el dominio: " dominio
            echo -e "\e[0m"
            sed -i 's/option domain-name ".*";/option domain-name "'$dominio'";/g' /etc/dhcp/dhcpd.conf
        fi

        #Configurar /etc/resolv.conf con la variable $dominio
        #Ejemplo: domain-name instragram.com
        #search instragram.com
        #nameserver IP_Propia
        if [ $instalado_dhcp -eq 1 ]; then
            echo -e "\e[32m Configurando /etc/resolv.conf...\e[0m"
            #EL DOMAIN NAME NO FUNCIONA AUN!!!!!!!!!!!!!!!!!!!!!!!!!
            sed -i 's/domain-name .*;/domain-name '$dominio';/g' /etc/resolv.conf
            sed -i 's/search.*/search '$dominio'/g' /etc/resolv.conf
            #Falta poner la IP del servidor DNS en nameserver
        fi

        #DNS
        if [ $instalado_dns -eq 0 ]; then
            echo -e "\e[32m Instalando DNS...\e[0m"
            $instalar_dns
            #Si se ha instalado cambia la variable a 1.
            if [ -f /etc/bind/named.conf.options ]; then
                instalado_dns=1
            fi
        fi

        #Configurar DNS
        #Copia el archivo /etc/bind/db.local a /etc/bind/db.$dominio
        #Ejemplo: db.$dominio
        if [ $instalado_dns -eq 1 ]; then
            ./dns.sh
        fi
        #Apache2
        if [ $instalado_apache -eq 0 ]; then
            echo -e "\e[32m Instalando Apache2...\e[0m"
            $instalar_apache
        fi
        /etc/init.d/apache2 start

        #PHP
        if [ $instalado_php -eq 0 ]; then
            echo -e "\e[32m Instalando PHP...\e[0m"
            $instalar_php
        fi
        #Nmap
        if [ $instalado_nmap -eq 0 ]; then
            echo -e "\e[32m Instalando Nmap...\e[0m"
            $instalar_nmap
        fi
        #MySQL
        if [ $instalado_mysql -eq 0 ]; then
            echo -e "\e[32m Instalando MySQL...\e[0m"
            $instalar_mysql
            $instalar_mysql_add
        fi

    #Elegir programa a instalar.
    elif [ $opcion -eq 2 ]; then
        echo "Seleccione una opcion: [1] Git [2] MySQL [3] Apache2 [4] PHP [5] DHCP [6] DNS [7] Nmap"
        read -p "Opcion: " opcion
        if [ $opcion -eq 1 ]; then
            #Git
            if [ $instalado_git -eq 0 ]; then
                #Color verde.
                echo -e "\e[32m Instalando Git...\e[0m"
                $instalar_git
            fi
        elif [ $opcion -eq 2 ]; then
            #MySQL
            if [ $instalado_mysql -eq 0 ]; then
                echo -e "\e[32m Instalando MySQL...\e[0m"
                $instalar_mysql
                $instalar_mysql_add
            fi
        elif [ $opcion -eq 3 ]; then
            #Apache2
            if [ $instalado_apache -eq 0 ]; then
                echo "Instalando Apache2..."
                apt-get install apache2 -y
            fi
            /etc/init.d/apache2 start
        elif [ $opcion -eq 4 ]; then
            #PHP
            if [ $instalado_php -eq 0 ]; then
                echo "Instalando PHP..."
                $instalar_php
            fi
        elif [ $opcion -eq 5 ]; then
            #DHCP
            if [ $instalado_dhcp -eq 0 ]; then
                echo -e "\e[32m Instalando DHCP...\e[0m"
                sudo apt-get install isc-dhcp-server -y
                #Si se ha instalado cambia la variable a 1.
                if [ -f /etc/dhcp/dhcpd.conf ]; then
                    instalado_dhcp=1
                fi
            fi
        elif [ $opcion -eq 6 ]; then
            #DNS
            if [ $instalado_dns -eq 0 ]; then
                echo "Instalando DNS..."
                sudo apt-get install
                #Si se ha instalado cambia la variable a 1.
                if [ -f /etc/bind/named.conf.options ]; then
                    instalado_dns=1
                fi
            fi
        elif [ $opcion -eq 7 ]; then
            #Nmap
            if [ $instalado_nmap -eq 0 ]; then
                echo "Instalando Nmap..."
                apt-get install nmap -y
            fi
        fi
    elif [ $opcion -eq 3 ]; then
        ./config.sh
    fi
fi