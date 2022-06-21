#!/bin/bash
echo -e "\e[32m Configurando DHCP...\e[0m"
# En magenta.
echo -e "\e[35m"
read -p "Introduzca el dominio: " dominio
echo -e "\e[0m"
sed -i 's/option domain-name ".*";/option domain-name "'$dominio'";/g' /etc/dhcp/dhcpd.conf
echo -e "\e[35m"
read -p "Introduzca la IP que quieras de la maquina: " ip
echo -e "\e[0m"

#Quitar a la IP los últimos numeros
#Ejemplo de entrada:
#10.21.131.1
#Salida:
#10.21.131.
ip_short=${ip%.*}

#option domain-name "instagram.com";
#option domain-name-servers $ip;

#default-lease-time 86400;
sed -i 's/default-lease-time.*;/default-lease-time 86400;/g' /etc/dhcp/dhcpd.conf
#max-lease-time 7200;
sed -i 's/max-lease-time.*;/max-lease-time 7200;/g' /etc/dhcp/dhcpd.conf
#min-lease-time 3600;
#Añade el min-lease-time
echo "min-lease-time 3600;" >> /etc/dhcp/dhcpd.conf
#option subnet-mask 255.255.255.0;
echo "option subnet-mask 255.255.255.0;" >> /etc/dhcp/dhcpd.conf
#option routers 10.21.133.1;
echo "option routers $ip_short.1;" >> /etc/dhcp/dhcpd.conf
#subnet 10.21.133.0 netmask 255.255.255.0 {
echo "subnet $ip_short.0 255.255.255.0 {" >> /etc/dhcp/dhcpd.conf
#range 10.21.133.20 10.21.133.30;
echo "range $ip_short.20 $ip_short.30;" >> /etc/dhcp/dhcpd.conf
#}

#Configurar las interfaces de red en /etc/network/interfaces
echo -e "\e[35m Se necesitan 2 interfaces de red para el DHCP.\e[0m"
echo -e "\e[35m"
read -p "Introduzca la interfaz de red que quiera usar para el servidor DHCP: " interfaz
read -p "Introduzca la interfaz de red que quiera usar para el cliente DHCP: " interfaz2
echo -e "\e[0m"
#Configurar la interfaz de red
#Comprobar si $interfaz es una interfaz de red
if ! ifconfig | grep -q $interfaz; then
    echo -e "\e[31m La interfaz de red introducida no es válida.\e[0m"
    exit 1
    if ! ifconfig | grep -q $interfaz2; then
        echo -e "\e[31m La interfaz de red introducida no es válida.\e[0m"
        exit 1
    else
        echo -e "\e[32m Configurando interfaces de red...\e[0m"
        #Haz una copia de la interfaz de red
        cp /etc/network/interfaces /etc/network/interfaces.bak
        #Deshabilita las interfaces de red
        ifdown $interfaz $interfaz2
        #Borra el contenido de la carpeta interfaces
        rm -rf /etc/network/interfaces
        #Crea una nueva carpeta interfaces
        touch /etc/network/interfaces
        #Añade el contenido de la interfaz de red
        echo "source /etc/network/interfaces.d/*" >> /etc/network/interfaces
        echo "auto lo
        iface lo inet loopback" >> /etc/network/interfaces
        echo "allow-hotplug $interfaz
        iface $interfaz inet static
            address $ip
            netmask 255.255.255.0" >> /etc/network/interfaces
        echo "allow-hotplug $interfaz2
        iface $interfaz2 inet dhcp" >> /etc/network/interfaces
        #Habilita las interfaces de red
        ifup $interfaz $interfaz2
        echo -e "\e[32m Interfaces de red configuradas.\e[0m"
    fi
fi

#Configurar /etc/resolv.conf con la variable $dominio
#Ejemplo: domain $dominio.com.
#search $dominio.com.
#nameserver ip
#Si domain no existe en resolv, lo pone con el dominio.
#Si search no existe en resolv, lo pone con el dominio.
#Si nameserver no existe en resolv, lo pone con la IP propia.

if [ -f /etc/resolv.conf ]; then
    echo -e "\e[32m Configurando resolv.conf...\e[0m"
    sed -i 's/nameserver .*;/nameserver '$ip';/g' /etc/resolv.conf
    sed -i 's/domain .*;/domain '$dominio';/g' /etc/resolv.conf
    sed -i 's/search .*;/search '$dominio';/g' /etc/resolv.conf

    if ! grep -q "domain $dominio" /etc/resolv.conf; then
        echo "domain $dominio" >> /etc/resolv.conf
    fi
    if ! grep -q "search $dominio" /etc/resolv.conf; then
        echo "search $dominio" >> /etc/resolv.conf
    fi
    if ! grep -q "nameserver $ip" /etc/resolv.conf; then
        echo "nameserver $ip" >> /etc/resolv.conf
    fi
fi

# Configura la interfaz de red en /etc/default/isc-dhcp-server
# INTERFACESv4="" a INTERFACESv4="$interfaz"
echo -e "\e[32m Configurando /etc/default/isc-dhcp-server...\e[0m"
sed -i 's/INTERFACESv4=""/INTERFACESv4="'$interfaz'"/g' /etc/default/isc-dhcp-server

#Reinicia el servicio DHCP.
echo -e "\e[32m Reiniciando servicio DHCP...\e[0m"
service isc-dhcp-server restart
