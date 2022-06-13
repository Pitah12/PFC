<?php
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

// Muestra el contenido de la tabla "user" que tiene las columnas "nombre" y "passwd"
$sql = "SELECT nombre, passwd FROM user";
$result = mysqli_query($conn, $sql);

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
    // Muesrta el contenido de la tabla "user" que tiene las columnas "nombre" y "passwd"
    echo "<table>";
    echo "<tr>";
    echo "<th>Nombre</th>";
    echo "<th>Contraseña</th>";
    echo "</tr>";
    while($row = mysqli_fetch_assoc($result)) {
        echo "<tr>";
        echo "<td>" . $row["nombre"] . "</td>";
        echo "<td>" . $row["passwd"] . "</td>";
        echo "</tr>";
    }
    echo "</table>";

} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

?>
</body>
</html>
