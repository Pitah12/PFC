# Selecciona el paquete a desinstalar.
echo "1. MariaDB"
echo "2. Apache"
read -p "Seleccione una opcion: " opcion
# Si el numero es 1, se desinstala mariaDB.
if [ $opcion -eq 1 ]; then
    # Desinstala mariaDB.
    apt-get --purge remove "mariadb*"
    ./inicio.sh
fi
if [ $opcion -eq 2 ]; then
    # Desinstala apache.
    apt-get --purge remove apache2
    ./inicio.sh
fi