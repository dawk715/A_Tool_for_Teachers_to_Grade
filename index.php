<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>University Login</title>
    <meta name="author" content="David Williams">
    <meta name="description" content="A Student Grading Tool designed to help teachers manage, calculate, and review student grades based on weighted assignments, quizzes, midterms, and final projects.">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center mb-4">University Portal Login</h2>
        <div class="row justify-content-center">
            <!-- Student Login Form -->
            <div class="col-md-5">
                <div class="card">
                    <div class="card-header text-center">
                        <h4>Student Login</h4>
                    </div>
                    <div class="card-body">
                        <form action="student_login.php" method="POST">
                            <div class="mb-3">
                                <label for="studentEmail" class="form-label">Email address</label>
                                <input type="email" class="form-control" id="studentEmail" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="studentPassword" class="form-label">Password</label>
                                <input type="password" class="form-control" id="studentPassword" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Login</button>
                        </form>
                    </div>
                </div>
                <p>For testing purposes you can use:</br>john.doe1@example.com / password111</br>david.williams@example.com / password123</p>
            </div>

            <!-- Teacher Login Form -->
            <div class="col-md-5 ms-3">
                <div class="card">
                    <div class="card-header text-center">
                        <h4>Teacher Login</h4>
                    </div>
                    <div class="card-body">
                        <form action="teacher_login.php" method="POST">
                            <div class="mb-3">
                                <label for="teacherEmail" class="form-label">Email address</label>
                                <input type="email" class="form-control" id="teacherEmail" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="teacherPassword" class="form-label">Password</label>
                                <input type="password" class="form-control" id="teacherPassword" name="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Login</button>
                        </form>
                    </div>
                </div>
                <p>For testing purposes you can use:</br>elam.birnbaum@example.com / password456</p>
            </div>
        </div>
    </div>
    <!-- Bootstrap JS (Optional) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
