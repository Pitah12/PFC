#Comprueba que mariaDB esta instalado.
    if [ $(dpkg -l | grep mariadb-server | wc -l) -eq 0 ]; then
        echo "No se encuentra mariaDB."
        read -p "Desea instalarlo? (s/n): " instalar
        if [ $instalar = "s" ]; then
            apt-get install mariadb-server
        fi
    #Si mariaDB esta instalado, se comprueba que esta corriendo.
    else
        #Mira si el proceso esta corriendo y lo inicia si no esta corriendo.
        if [ $(ps -aux | grep mysql | wc -l) -eq 0 ]; then
            echo "El servidor de base de datos esta parado."
            echo "Desea iniciarlo?"
            read -p "s/n: " respuesta
            if [ $respuesta = "s" ]; then
                /etc/init.d/mysql start
                echo "El servidor de base de datos se ha iniciado."
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
    fi