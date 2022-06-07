#!/bin/bash
echo "1. Elegir página web"
echo "2. Configurar servidor DHCP. (Atacante)"
echo "3. Configurar servidor DNS. (Atacante)"
echo "4. Iniciar/Parar servidor web. (Apache)"
echo "5. Analisis de red."
echo "6. Desintalar uno o varios paquetes."
echo "7. Salir."
echo ""
read -p "Seleccione una opcion: " opcion
echo ""
#---------------------------------------------------------------------------------------------------------------------

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

if [ $opcion -eq 7 ]; then
    echo "Hasta pronto!"
    exit 0
fi