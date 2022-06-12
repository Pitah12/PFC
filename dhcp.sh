#!/bin/bash
echo -e "\e[32m Configurando DHCP...\e[0m"
# En magenta.
echo -e "\e[35m"
read -p "Introduzca el dominio: " dominio
echo -e "\e[0m"
sed -i 's/option domain-name ".*";/option domain-name "'$dominio.com'";/g' /etc/dhcp/dhcpd.conf

#Configurar /etc/resolv.conf con la variable $dominio
#Ejemplo: domain $dominio.com.
#search $dominio.com.
#nameserver IP_Propia
#Si domain no existe en resolv, lo pone con el dominio.
#Si search no existe en resolv, lo pone con el dominio.
#Si nameserver no existe en resolv, lo pone con la IP propia.

if [ -f /etc/resolv.conf ]; then
    echo -e "\e[32m Configurando resolv.conf...\e[0m"
    echo -e "\e[35m"
    read -p "Introduzca la IP de la máquina: " IP_Propia
    echo -e "\e[0m"
    sed -i 's/nameserver .*;/nameserver '$IP_Propia';/g' /etc/resolv.conf
    sed -i 's/domain .*;/domain '$dominio'.com;/g' /etc/resolv.conf
    sed -i 's/search .*;/search '$dominio'.com;/g' /etc/resolv.conf

    if ! grep -q "domain $dominio.com" /etc/resolv.conf; then
        echo "domain $dominio.com" >> /etc/resolv.conf
    fi
    if ! grep -q "search $dominio.com" /etc/resolv.conf; then
        echo "search $dominio.com" >> /etc/resolv.conf
    fi
    if ! grep -q "nameserver $IP_Propia" /etc/resolv.conf; then
        echo "nameserver $IP_Propia" >> /etc/resolv.conf
    fi
fi

#Reinicia el servicio DHCP.
echo -e "\e[32m Reiniciando servicio DHCP...\e[0m"
service isc-dhcp-server restart
