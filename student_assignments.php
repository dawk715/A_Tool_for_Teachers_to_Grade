<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="David Williams">
    <meta name="description" content="A Student Grading Tool - Student Grades">
    
    <title>Student Assignments</title>
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

    // Get the student ID from the query parameter
    $student_id = $_GET['student_id'];

    // Fetch student information and final grade from the view
    $studentQuery = "
        SELECT s.first_name, s.last_name, sf.final_grade
        FROM Students s
        JOIN StudentFinalGrades sf ON s.student_id = sf.student_id
        WHERE s.student_id = ?
    ";
    $stmt = $conn->prepare($studentQuery);
    $stmt->bind_param("i", $student_id);
    $stmt->execute();
    $studentResult = $stmt->get_result();
    $student = $studentResult->fetch_assoc();
    $finalGrade = $student['final_grade'];  // Fetch final grade from the view

    // Fetch all assignments and grades for the student
    $assignmentQuery = "
        SELECT a.assignment_id, a.name AS assignment_name, at.type_name, g.score
        FROM Assignments a
        JOIN AssignmentTypes at ON a.assignment_type_id = at.assignment_type_id
        LEFT JOIN Grades g ON a.assignment_id = g.assignment_id AND g.student_id = ?
        ORDER BY a.assignment_id, a.name";
    $assignmentStmt = $conn->prepare($assignmentQuery);
    $assignmentStmt->bind_param("i", $student_id);
    $assignmentStmt->execute();
    $assignmentsResult = $assignmentStmt->get_result();
    ?>

    <div class="container my-5">
        <!-- Back to Students List Button -->
        <div class="mb-4">
            <a href="teacher_dashboard.php" class="btn btn-secondary">&larr; Back to Students List</a>
        </div>

        <!-- Student Header -->
        <div class="card mb-4">
            <div class="card-body d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="card-title mb-0">Assignments for <?php echo htmlspecialchars($student['first_name']) . " " . htmlspecialchars($student['last_name']); ?></h2>
                    <p class="card-text">Enter grades for each assignment and you can submit all at once or individually.</p>
                </div>
                <div>
                    <span class="badge bg-primary fs-5">
                        <?php echo is_numeric($finalGrade) ? "Final Grade: " . $finalGrade . "%" : "Final Grade: Not Available"; ?>
                    </span>
                </div>
            </div>
        </div>

        <!-- Assignments Table with Batch Grade Form -->
        <form action="submit_grades.php" method="POST">
            <input type="hidden" name="student_id" value="<?php echo $student_id; ?>">
            <div class="card">
                <div class="card-body">
                    <table class="table table-bordered table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>Assignment</th>
                                <th>Type</th>
                                <th>Current Score</th>
                                <th>Enter New Score</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php while ($assignment = $assignmentsResult->fetch_assoc()): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($assignment['assignment_name']); ?></td>
                                    <td><?php echo htmlspecialchars($assignment['type_name']); ?></td>
                                    <td><?php echo $assignment['score'] !== null ? htmlspecialchars($assignment['score']) : "Not Graded"; ?></td>
                                    <td>
                                        <input type="number" name="grades[<?php echo $assignment['assignment_id']; ?>]" class="form-control" min="0" placeholder="Score">
                                    </td>
                                </tr>
                            <?php endwhile; ?>
                        </tbody>
                    </table>
                    <button type="submit" class="btn btn-primary mt-3">Submit Grades</button>
                </div>
            </div>
        </form>
    </div>

    <!-- Bootstrap JS (Optional) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <?php
    // Close statements and connection
    $stmt->close();
    $assignmentStmt->close();
    $conn->close();
    ?>
</body>
</html>
