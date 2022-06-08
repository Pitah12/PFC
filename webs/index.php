<?php
//Conecetate a la base de datos mariadb "pagina_web" en localhost con usuario "root" y contraseña "asir21"
$servername = "localhost";
$database = "vulne";
$username = "root";
$password = "pfc1";

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

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Conexion a la base de datos</title> 
</head>
<body>
<?php
if ($conn) {
    echo "Conexion realizada correctamente";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

// Muestra el usuario y contraseña introducidos en index.html
echo "<br>Usuario: " . $_POST["username"];
echo "<br>Contraseña: " . $_POST["passwd"];

?>
</body>
</html>
