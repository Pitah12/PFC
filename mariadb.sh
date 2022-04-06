#Comprueba que mariaDB esta instalado.
    if [ $(dpkg -l | grep mariadb-server | wc -l) -eq 0 ]; then
        echo "No se encuentra mariaDB."
        read -p "Desea instalarlo? (s/n): " instalar
        if [ $instalar = "s" ]; then
            apt-get install mariadb-server
            mysql_secure_installation
        fi
        ./mariadb.sh
    #Si mariaDB esta instalado, se comprueba que esta corriendo.
    else
        #Si mariaDB no esta corriendo, se inicia.
        if [ $(ps -A | grep mysql | wc -l) -eq 0 ]; then
            echo "El servidor de base de datos esta parado."
            echo "Desea iniciarlo?"
            read -p "s/n: " respuesta
            if [ $respuesta = "s" ]; then
                /etc/init.d/mysql start
                echo "El servidor de base de datos se ha iniciado."
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
        ./inicio.sh
    fi