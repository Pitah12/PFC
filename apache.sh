if [ -f /etc/apache2/apache2.conf ]; then
        #Mira si el proceso esta corriendo y lo inicia si no esta corriendo.
        if [ $(ps -ef | grep -v grep | grep apache2 | wc -l) -eq 0 ]; then
            echo "El servidor web esta parado."
            echo "Desea iniciarlo?"
            read -p "s/n: " respuesta
            if [ $respuesta = "s" ]; then
                /etc/init.d/apache2 start
                echo "El servidor web se ha iniciado."
            fi
        #Si proceso esta corriendo, lo detiene.
        else
            echo "El servidor web esta iniciado."
            echo "Desea pararlo?"
            read -p "s/n: " respuesta
            if [ $respuesta = "s" ]; then
                /etc/init.d/apache2 stop
                echo "El servidor web se ha parado."
            fi
        fi
else
    echo "No se encuentra apache2."
    read -p "Desea instalarlo? (s/n): " instalar
    if [ $instalar = "s" ]; then
        apt-get install apache2
        /etc/init.d/apache2 start
    fi
fi