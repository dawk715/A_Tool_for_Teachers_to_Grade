<?php
// db_connection.php
$host = 'localhost';
$dbname = 'UniversityGrades';
$username = 'root';
$password = ''; // Add your database password if set

$conn = new mysqli($host, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} else {
    echo "<script>console.log('Database connected successfully');</script>";
}
?>
