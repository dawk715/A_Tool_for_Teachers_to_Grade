<?php
session_start();
require 'db_connection.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Hash the entered password with SHA2 for comparison
    $hashedPassword = hash('sha256', $password);  // Equivalent to SHA2('password', 256) in MySQL

    // Prepare and execute query using MySQLi
    $query = "SELECT * FROM Teachers WHERE email = ? AND password_hash = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("ss", $email, $hashedPassword);
    $stmt->execute();
    $result = $stmt->get_result();
    $teacher = $result->fetch_assoc();

    // Check if the teacher was found
    if ($teacher) {
        $_SESSION['teacher_id'] = $teacher['teacher_id'];
        $_SESSION['user_type'] = 'teacher';
        header('Location: teacher_dashboard.php');
        exit();
    } else {
        echo "<script>alert('Invalid email or password'); window.location.href = 'index.php';</script>";
    }
}
?>
