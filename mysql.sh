#!/bin/bash
echo "****************************************************************************"
echo "[1] Iniciar el servidor MySQL"
echo "[2] Parar el servidor MySQL"
echo "[3] Reiniciar el servidor MySQL"
echo "[4] Configurar el servidor MySQL"
echo "[5] Salir"
echo ""
read -p "Seleccione una opcion: " opcion
echo ""

while [ -z $opcion ] || [ $opcion -lt 1 ] || [ $opcion -gt 5 ]; do
    echo "Por favor, introduzca una opcion valida."
    read -p "Seleccione una opcion: " opcion
    echo ""
done

#Iniciar
if [ $opcion -eq 1 ]; then
    /etc/init.d/mysql start
fi

#Parar
if [ $opcion -eq 2 ]; then
    /etc/init.d/mysql stop
fi

#Reiniciar
if [ $opcion -eq 3 ]; then
    /etc/init.d/mysql restart
fi

if [ $opcion -eq 4 ]; then
    read -p "Introduzca la contraseña de root: " contrasena
    
    echo -e "\e[32m Configurando MySQL...\e[0m"
    read -p "Desea insalar la base de datos para recopilar datos? (s/n): " respuesta
    #Si la respuesta es s, se crea un usuario y contraseña "tfg "y base de datos.
    if [ $respuesta = "s" ]; then
        mysql -u root -p -e "CREATE USER 'tfg'@'localhost' IDENTIFIED BY 'tfg';"
        mysql -u root -p -e "CREATE DATABASE tfg;"
    fi
fi




#Si proceso esta corriendo, lo detiene.
else
    echo "El servidor de base de datos esta iniciado."
    echo "Desea pararlo?"
    read -p "s/n: " respuesta
    if [ $respuesta = "s" ]; then
        /etc/init.d/mysql stop
        echo "El servidor de base de datos se ha parado."
    fi
fi
