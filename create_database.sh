#!/bin/bash
# Este script crea una base de datos, y un usuario con permisos para operar en ella.
# Defaults
DB_ROOT=""
DB_ROOT_PASS=""
DB_NAME=""
DB_USER=""
DB_PASS=""

# Recogemos el input del usuario
read -e -p " + Usuario root del servidor mysql: " DB_ROOT
read -e -s -p " + Contraseña root para el servidor mysql: " DB_ROOT_PASS; echo
read -e -p " + Nombre de la base de datos (sin espacios ni caracteres especiales): " DB_NAME
read -e -p " + Nombre del nuevo usuario mysql (o uno ya existente): " DB_USER
read -e -s -p " + Contraseña del nuevo usuario: " DB_PASS;
echo 
echo
# Creamos el nuevo usuario sql
mysql -u ${DB_ROOT} -p${DB_ROOT_PASS} -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}'; GRANT USAGE ON * . * TO '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"

# Comprobamos errores
if [ $? == 0 ]; then
        echo " El usuario ${DB_USER} se ha creado con éxito."

        # Creamos la nueva base de datos
        mysql -u ${DB_ROOT} -p${DB_ROOT_PASS} -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci; GRANT ALL PRIVILEGES ON ${DB_NAME} . * TO '${DB_USER}'@'localhost';"

        # Comprobamos errores
        if [ $? == 0 ]; then
                echo " La base de datos ${DB_NAME} se ha creado con éxito."
                echo " El usuario ${DB_USER} tiene permisos sobre la base de datos ${DB_NAME}."
        else
                mysql -u ${DB_ROOT} -p${DB_ROOT_PASS} -e "DROP USER '${DB_USER}'@'localhost';"
                exit
        fi

else
        echo " Si mysql devuelve ERROR 1396 probablemente signifique que el usuario que intentas crear ya existe."
        echo " Prueba otro nombre de usuario."
        exit
fi