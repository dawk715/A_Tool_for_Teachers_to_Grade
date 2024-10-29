Student Grading Tool
=====================

This tool is designed to help teachers manage and calculate student grades based on various assignments, quizzes, midterms, and final projects. It provides both a teacher and student portal for easy access to relevant information and grading features.

=====================
Table of Contents
=====================
1. Features
2. Project Setup and Installation
3. Usage Instructions
4. Development Notes
5. License

=====================
1. Features
=====================
- **Weighted Grading System**: Calculates final grades based on assignment, quiz, midterm, and final project weights.
- **Teacher Dashboard**: Allows teachers to view, add, and update grades for their students.
- **Student Dashboard**: Provides students with a read-only view of their grades.
- **Secure Login**: Separate login portals for teachers and students.

=====================
2. Project Setup and Installation
=====================

### Prerequisites
- **PHP**: Version 7.4 or higher
- **MySQL**: For database management
- **Web Server**: Apache, XAMPP, or WAMP recommended

### Installation Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/YOUR_GITHUB_USERNAME/StudentGradingTool.git
Set Up Database:
Locate the university_grades.sql file within the project directory.
Import this SQL file into your MySQL database. This will set up the database schema and initial tables.
Update db_connection.php in the project files with your MySQL credentials.
Configure Environment:
Copy all project files into the root directory of your web server (e.g., htdocs for XAMPP).
Make sure the mysqli extension is enabled in PHP.
Run the Application:
Access the tool in your browser by visiting http://localhost/StudentGradingTool (or your configured local server URL).
===================== 3. Usage Instructions

Teacher Instructions
Login: Use your email and password on the teacher portal at the homepage.
Dashboard: After logging in, the teacher dashboard displays a list of students assigned to the logged-in teacher.
View Grades: Click on a student's name to view their assignments and grades.
Add/Update Grades: Enter grades for assignments directly in the tool and submit them as a batch for processing. Final grades are calculated based on configured assignment weights.
Logout: To exit, click on the logout link.
Student Instructions
Login: Use your email and password on the student portal at the homepage.
View Grades: Access a read-only view of all assignments and grades.
Final Grade: The final grade is shown based on the weighted calculation of all entered grades.
===================== 4. Development Notes

Password Hashing: This project uses SHA-256 hashing for demo purposes. In production, it's recommended to use PHP’s password_hash function for enhanced security.
Database Structure: The StudentFinalGrades view provides an easy way to retrieve calculated final grades. This view should not be edited directly.
Security: Sessions and access checks are included to ensure only logged-in teachers and students can view their respective dashboards.
===================== 5. License

This project is licensed under the MIT License.

===================== End of README