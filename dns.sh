echo -e "\e[32m Configurando DNS...\e[0m"
#En magenta.
echo -e "\e[35m"
read -p "Introduzca el dominio para el DNS (el mismo de antes): " dominio
echo -e "\e[0m"
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
    echo -e "\e[32m Configurando named.conf.local...\e[0m"
    echo "zone \"$dominio\" {" >> /etc/bind/named.conf.local
    echo "type master;" >> /etc/bind/named.conf.local
    echo "file \"db.$dominio\";" >> /etc/bind/named.conf.local
    echo "};" >> /etc/bind/named.conf.local
fi