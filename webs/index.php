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
    <title>¡Bienvenido!</title> 
</head>
<body>
<?php
if ($conn) {
    //Redirecciona a la pagina de inicio
    header("Location: login.html");
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

?>
</body>
</html>
