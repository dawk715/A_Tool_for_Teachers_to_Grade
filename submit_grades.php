<?php
session_start();
require 'db_connection.php';

// Check if teacher is logged in
if (!isset($_SESSION['teacher_id'])) {
    header('Location: index.php');
    exit();
}

// Get student ID and grades from POST data
$student_id = $_POST['student_id'];
$grades = $_POST['grades'];

// Begin transaction for batch insert/update
$conn->begin_transaction();

try {
    // Prepare the insert/update statement
    $stmt = $conn->prepare("
        INSERT INTO Grades (student_id, assignment_id, score)
        VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE score = VALUES(score)
    ");

    // Loop through grades and bind each assignment's grade
    foreach ($grades as $assignment_id => $score) {
        if ($score !== '') { // Only process if a grade was entered
            $stmt->bind_param("iid", $student_id, $assignment_id, $score);
            $stmt->execute();
        }
    }

    // Commit transaction
    $conn->commit();
    // Redirect back to the student's assignments page
    header("Location: student_assignments.php?student_id=" . $student_id);
    exit();
} catch (Exception $e) {
    // Rollback transaction on error
    $conn->rollback();
    echo "<script>alert('Failed to submit grades. Please try again.'); window.history.back();</script>";
}

$stmt->close();
$conn->close();
?>
