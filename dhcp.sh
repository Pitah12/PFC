#!/bin/bash
echo -e "\e[32m Configurando DHCP...\e[0m"
# En magenta.
echo -e "\e[35m"
read -p "Introduzca el dominio: " dominio
echo -e "\e[0m"
sed -i 's/option domain-name ".*";/option domain-name "'$dominio'";/g' /etc/dhcp/dhcpd.conf

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
    sed -i 's/domain .*;/domain '$dominio';/g' /etc/resolv.conf
    sed -i 's/search .*;/search '$dominio';/g' /etc/resolv.conf

    if ! grep -q "domain $dominio" /etc/resolv.conf; then
        echo "domain $dominio" >> /etc/resolv.conf
    fi
    if ! grep -q "search $dominio" /etc/resolv.conf; then
        echo "search $dominio" >> /etc/resolv.conf
    fi
    if ! grep -q "nameserver $IP_Propia" /etc/resolv.conf; then
        echo "nameserver $IP_Propia" >> /etc/resolv.conf
    fi
fi

# Configura la interfaz de red en /etc/default/isc-dhcp-server
# INTERFACESv4="" a INTERFACESv4="$interfaz"
echo -e "\e[32m Configurando /etc/default/isc-dhcp-server...\e[0m"
echo -e "\e[35m"
read -p "Introduzca la interfaz de red: " interfaz
echo -e "\e[0m"
sed -i 's/INTERFACESv4=""/INTERFACESv4="'$interfaz'"/g' /etc/default/isc-dhcp-server

#Reinicia el servicio DHCP.
echo -e "\e[32m Reiniciando servicio DHCP...\e[0m"
service isc-dhcp-server restart
