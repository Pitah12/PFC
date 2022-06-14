#!/bin/bash
echo "1. Elegir página web"
echo "2. Configurar servidor DHCP. (Atacante)"
echo "3. Configurar servidor DNS. (Atacante)"
echo "4. Configurar MySQL (Necesario)"
echo "5. Analisis de red."
echo "6. Ataque ARP"
echo "7. Desintalar uno o varios paquetes."
echo "8. Salir."
echo ""
read -p "Seleccione una opcion: " opcion
echo ""
#---------------------------------------------------------------------------------------------------------------------

instalar_mysql_conf="mysql -u root -e \"ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'pfc1'\""
instalar_mysql_conf1="mysql -u root -p pfc1 -e \"FLUSH PRIVILEGES\""
instalar_mysql_conf3="mysql -u root -e \"FLUSH PRIVILEGES\""

#variable página_web
#Mientras no esté entre el 1 y el 7 se repite el bucle.
#Si opcion está vacia, se repite el bucle.
while [ -z $opcion ] || [ $opcion -lt 1 ] || [ $opcion -gt 7 ]; do
    echo "Por favor, introduzca una opcion valida."
    read -p "Seleccione una opcion: " opcion
    echo ""
done

if [ $opcion -eq 1 ]; then
    ./apache.sh
fi

if [ $opcion -eq 2 ]; then
    ./dhcp.sh
fi

if [ $opcion -eq 3 ]; then
    ./dns.sh
fi

# Si el numero es 4, se configura mysql.
if [ $opcion -eq 4 ]; then
    # Color magenta.
    echo -e "\e[35m Configurando MySQL...\e[0m"
    mysql -u root < script.sql
    #Crear usuario y contraseña.
    mysql -u root -e "CREATE USER 'hacker'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'phising'"
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'hacker'@'localhost' WITH GRANT OPTION"
    mysql -u root -e "FLUSH PRIVILEGES"
    #Crear contraseña para root.
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'pfc1'"
    echo -e "\e[35m Contraseña del usuario hacker: phising\e[0m"
    echo -e "\e[35m Contraseña del usuario root: pfc1\e[0m"
fi

# Si el numero es 5, se inicia el analisis de red.
if [ $opcion -eq 5 ]; then
    ./analisis.sh
fi

if [ $opcion -eq 6 ]; then
    ./arp.sh
fi

# Si el numero es 7, se desinstala uno o varios paquetes.
if [ $opcion -eq 7 ]; then
    ./desinstalar.sh
fi

if [ $opcion -eq 8 ]; then
    echo "Hasta pronto!"
    exit 0
fi