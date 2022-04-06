#Crea un script que pregunte por una interfaz de red y analice los datos de la misma.
#El script debe mostrar el nombre de la interfaz, la dirección MAC, la dirección IP, el servidor DHCP y el servidor DNS.
#El script debe mostrar un mensaje de error si la interfaz no existe.
#El script usará herramientas como ifconfig, nmap, dig o nslookup.
#!/bin/bash
read -p "Introduce una interfaz de red: " interfaz
ifconfig $interfaz | grep -E "ether|inet" | sed -n '1p' | awk '{print $2}'
if [ $? -eq 0 ]; then
    echo "La interfaz $interfaz existe"
    #IP proporcionada por el DHCP con la variable $IP
    IP=$(ifconfig $interfaz | grep -E "ether|inet" | sed -n '1p' | awk '{print $2}')
    echo "La IP es $IP"
    #Nombre del servidor DHCP con la variable $DHCP
    DHCP=$(ip r | grep -E "default|via" | sed -n '1p' | awk '{print $3}')
    echo "El servidor DHCP es $DHCP"
    #IP de la puerta de enlace con la variable $GATEWAY
    GATEWAY=$(ip r | grep -E "default|via" | sed -n '1p' | awk '{print $3}')
    echo "La IP de la puerta de enlace es $GATEWAY"
    #Scaneo de la IP con nmap. Si gateway tiene el puerto 53 abierto, se muestra el nombre del servidor DNS.
    if nmap -p 53 $GATEWAY | grep -q "open"; then
        echo "El servidor DNS es $GATEWAY"
    else
        echo "El servidor DNS no está disponible"
    fi
else
    echo "La interfaz $interfaz no existe"
fi