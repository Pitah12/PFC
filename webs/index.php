<?php
//Conecetate a la base de datos mariadb "pagina_web" en localhost con usuario "root" y contraseña "asir21"
$servername = "localhost";
$database = "user";
$username = "root";
$password = "asir21";

// Crea la conexion
$conn = mysqli_connect($servername, $username, $password, $database);

// Comprueba la conexion
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

echo "Connected successfully";
mysqli_close($conn);
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
?>
</body>
</html>
