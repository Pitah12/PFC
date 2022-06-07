#!/bin/bash
echo -e "\e[32m Configurando DNS...\e[0m"
#En magenta.
echo -e "\e[35m"
read -p "Introduzca el dominio para el DNS: " dominio
echo -e "\e[0m"
#Comprueba si db.$dominio ya existe.
if [ -f /etc/bind/db.$dominio ]; then
    echo -e "\e[31m El dominio ya existe.\e[0m"
    #Si no existe, se crea.
else
    echo -e "\e[32m Creando dominio...\e[0m"
    mkdir /etc/bind/db.$dominio
fi                           
#;
#; BIND data file for local loopback interface
#;
#$TTL    604800
#@       IN      SOA     www.$dominio. root.$dominio. (
#                              2         ; Serial
#                         604800         ; Refresh
#                          86400         ; Retry
#                        2419200         ; Expire
#                         604800 )       ; Negative Cache TTL
#;
#@       IN      NS      $dominio.
#wwww       IN      A       $ip

#Si db.$dominio existe modifica /etc/bind/db.$dominio.
if [ -f /etc/bind/db.$dominio ]; then
    echo "Modificando /etc/bind/db.$dominio"
    echo -e "\e[35m"
    read -p "Introduzca la IP de este equipo: " ip
    echo ";" > /etc/bind/db.$dominio
    echo "; BIND data file for local loopback interface" >> /etc/bind/db.$dominio
    echo ";" >> /etc/bind/db.$dominio
    echo "@       IN      SOA     www.$dominio. root.$dominio. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      www.$dominio.
www     IN      A       $ip" >> /etc/bind/db.$dominio
fi
#Configurar named.conf.local con la zona del dominio.
#Ejemplo: zone "instragram.com" {
#type master;
#file "db.instragram.com";
#};
if [ -f /etc/bind/named.conf.local ]; then
    #Si existe $dominio en named.conf.local, no hace nada.
    if ! grep -q "$dominio" /etc/bind/named.conf.local; then
        echo "Modificando /etc/bind/named.conf.local"
        echo "zone \"$dominio\" {" >> /etc/bind/named.conf.local
        echo "type master;" >> /etc/bind/named.conf.local
        echo "file \"db.$dominio\";" >> /etc/bind/named.conf.local
        echo "};" >> /etc/bind/named.conf.local
    fi
fi

#Reinicia el servicio de DNS.
echo -e "\e[32m Reiniciando servicio DNS...\e[0m"
service bind9 restart
./config.sh