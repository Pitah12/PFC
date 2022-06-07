#!/bin/bash
echo -e "\e[32m Configurando DHCP...\e[0m"
# En magenta.
echo -e "\e[35m"
read -p "Introduzca el dominio: " dominio
echo -e "\e[0m"
sed -i 's/option domain-name ".*";/option domain-name "'$dominio'";/g' /etc/dhcp/dhcpd.conf

#Configurar /etc/resolv.conf con la variable $dominio
#Ejemplo: domain-name instragram.com
#search instragram.com
#nameserver IP_Propia
echo -e "\e[32m Configurando /etc/resolv.conf...\e[0m"
#EL DOMAIN NAME NO FUNCIONA AUN!!!!!!!!!!!!!!!!!!!!!!!!!
sed -i 's/domain-name .*;/domain-name '$dominio';/g' /etc/resolv.conf
sed -i 's/search.*/search '$dominio'/g' /etc/resolv.conf
#Falta poner la IP del servidor DNS en nameserver

#Reinicia el servicio DHCP.
echo -e "\e[32m Reiniciando servicio DHCP...\e[0m"
service isc-dhcp-server restart
