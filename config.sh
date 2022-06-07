#!/bin/bash
clear
echo "1. Elegir página web"
echo "2. Iniciar/Parar servidor DHCP. (Atacante)"
echo "3. Configurar servidor DNS. (Atacante)"
echo "4. Iniciar/Parar servidor web. (Apache)"
echo "5. Analisis de red."
echo "6. Desintalar uno o varios paquetes."
echo "7. Salir."
read -p "Seleccione una opcion: " opcion
#---------------------------------------------------------------------------------------------------------------------

#variable página_web
if [ $opcion -eq 1 ]; then
    ./apache.sh
fi

# Si el numero es 4, se inicia el servidor web.
if [ $opcion -eq 4 ]; then
    ./apache.sh
fi

# Si el numero es 5, se inicia el analisis de red.
if [ $opcion -eq 5 ]; then
    ./analisis.sh
fi

# Si el numero es 6, se desinstala uno o varios paquetes.
if [ $opcion -eq 6 ]; then
    ./desinstalar.sh
fi