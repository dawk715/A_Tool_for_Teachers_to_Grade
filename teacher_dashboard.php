<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="David Williams">
    <meta name="description" content="A Student Grading Tool Teacher Dashboard">
    
    <title>Teacher Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <?php
    session_start();
    require 'db_connection.php';

    // Check if teacher is logged in
    if (!isset($_SESSION['teacher_id'])) {
        header('Location: index.php');
        exit();
    }

    // Get the logged-in teacher's information
    $teacher_id = $_SESSION['teacher_id'];
    $teacherQuery = "SELECT first_name, last_name FROM Teachers WHERE teacher_id = ?";
    $teacherStmt = $conn->prepare($teacherQuery);
    $teacherStmt->bind_param("i", $teacher_id);
    $teacherStmt->execute();
    $teacherResult = $teacherStmt->get_result();
    $teacher = $teacherResult->fetch_assoc();

    // Query to fetch students and their final grades only for the teacher's classes
    $query = "
        SELECT s.student_id, s.first_name, s.last_name, sf.final_grade
        FROM Students s
        JOIN StudentSubjects ss ON s.student_id = ss.student_id
        JOIN Subjects sub ON ss.subject_id = sub.subject_id
        JOIN StudentFinalGrades sf ON s.student_id = sf.student_id AND sf.subject_id = sub.subject_id
        WHERE sub.subject_id IN (
            SELECT subject_id FROM Teachers WHERE teacher_id = ?
        )
        ORDER BY sf.final_grade DESC, s.last_name";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $teacher_id);
    $stmt->execute();
    $result = $stmt->get_result();
    ?>

    <div class="container mt-5">
        <!-- LogOut -->
        <div class="mb-4">
            <a href="logout.php" class="btn btn-secondary">&larr; Log Out</a>
        </div>
        <!-- Teacher greeting -->
        <div class="card mb-4">
            <div class="card-body">
                <h2 class="card-title">Hi, Mr. <?php echo htmlspecialchars($teacher['first_name']) . ' ' . htmlspecialchars($teacher['last_name']); ?></h2>
                <p class="card-text">Here is a list of students assigned to your classes:</p>
            </div>
        </div>

        <!-- Student list with final grades -->
        <div class="card">
            <div class="card-body">
                <?php if ($result->num_rows > 0): ?>
                    <ul class="list-group list-group-flush">
                        <?php while ($row = $result->fetch_assoc()): ?>
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <a href="student_assignments.php?student_id=<?php echo $row['student_id']; ?>">
                                    <?php echo htmlspecialchars($row['first_name']) . ' ' . htmlspecialchars($row['last_name']); ?>
                                </a>
                                <span class="badge bg-primary">
                                    <?php echo is_numeric($row['final_grade']) ? "Final Grade: " . $row['final_grade'] . "%" : "Not Available"; ?>
                                </span>
                            </li>
                        <?php endwhile; ?>
                    </ul>
                <?php else: ?>
                    <p class="text-muted">No students found for your classes.</p>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS (Optional) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <?php
    // Close statements and connection
    $teacherStmt->close();
    $stmt->close();
    $conn->close();
    ?>
</body>
</html>
