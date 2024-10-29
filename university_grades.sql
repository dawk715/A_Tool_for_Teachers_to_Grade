-- Create the database
CREATE DATABASE IF NOT EXISTS UniversityGrades;
USE UniversityGrades;

-- Table to store subjects or classes, as Brightspace should handle all classes
CREATE TABLE IF NOT EXISTS Subjects (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(300) NOT NULL, 
    subject_code VARCHAR(50) NOT NULL UNIQUE -- Unique code for the subject (e.g., CSC_350)
);

INSERT INTO Subjects (subject_name, subject_code)
VALUES
    ('Cloud Computing', 'CIS_362'),
    ('Software Development', 'CSC_350'),
    ('Web Programming', 'CIS_385'),
    ('Data Structure', 'CSC_331');

-- Table to store teacher information, with a reference to subject_id
CREATE TABLE IF NOT EXISTS Teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARBINARY(255) NOT NULL, -- Encrypted password
    subject_id INT, -- Link to the subject taught by this teacher
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Now, insert teachers with associations to each subject
INSERT INTO Teachers (first_name, last_name, email, password_hash, subject_id)
VALUES
    ('Kevin', 'Byron', 'kevin.byron@example.com', SHA2(RAND(), 256), 1), -- Associated with CIS_362
    -- Insert "password456" hashed specifically for Elam Birnbaum
    ('Elam', 'Birnbaum', 'elam.birnbaum@example.com', SHA2('password456', 256), 2), -- Associated with CSC_350
    ('Eduardo', 'Naranjo Rivera', 'eduardo.naranjo@example.com', SHA2(RAND(), 256), 3), -- Associated with CIS_385
    ('Anna', 'Salvati', 'anna.salvati@example.com', SHA2(RAND(), 256), 4); -- Associated with CSC_331

-- Table to store student information
CREATE TABLE IF NOT EXISTS Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARBINARY(255) NOT NULL, -- Encrypted password
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert 15 sample students with random names and emails
INSERT INTO Students (first_name, last_name, email, password_hash)
VALUES
    -- Insert "password111" hashed specifically for John Doe
    ('John', 'Doe', 'john.doe1@example.com', SHA2('password111', 256)),
    ('Jane', 'Doe', 'jane.doe1@example.com', SHA2(RAND(), 256)),
    ('Alice', 'Smith', 'alice.smith@example.com', SHA2(RAND(), 256)),
    ('Bob', 'Brown', 'bob.brown@example.com', SHA2(RAND(), 256)),
    ('Carol', 'Taylor', 'carol.taylor@example.com', SHA2(RAND(), 256)),
    -- Insert "password123" hashed specifically for David Williams
    ('David', 'Williams', 'david.williams@example.com', SHA2('password123', 256)),
    ('Eve', 'Clark', 'eve.clark@example.com', SHA2(RAND(), 256)),
    ('Frank', 'Johnson', 'frank.johnson@example.com', SHA2(RAND(), 256)),
    ('Grace', 'Lee', 'grace.lee@example.com', SHA2(RAND(), 256)),
    ('Hank', 'White', 'hank.white@example.com', SHA2(RAND(), 256)),
    ('Ivy', 'Harris', 'ivy.harris@example.com', SHA2(RAND(), 256)),
    ('Jack', 'Thompson', 'jack.thompson@example.com', SHA2(RAND(), 256)),
    ('Kate', 'Martinez', 'kate.martinez@example.com', SHA2(RAND(), 256)),
    ('Leo', 'Garcia', 'leo.garcia@example.com', SHA2(RAND(), 256)),
    ('Mia', 'Robinson', 'mia.robinson@example.com', SHA2(RAND(), 256));

-- Junction table to link students to multiple subjects (many-to-many relationship)
CREATE TABLE IF NOT EXISTS StudentSubjects (
    student_id INT NOT NULL,
    subject_id INT, -- Make subject_id nullable to allow ON DELETE SET NULL
    enrollment_date DATE DEFAULT CURRENT_DATE, 
    PRIMARY KEY (student_id), -- Primary key only on student_id
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Step 1: Ensure John Doe (student_id = 1) and David Williams (student_id = 6) are assigned to subject_id 2
INSERT INTO StudentSubjects (student_id, subject_id, enrollment_date)
VALUES 
    (1, 2, CURDATE()),  -- John Doe
    (6, 2, CURDATE());  -- David Williams

-- Step 2: Randomly assign 8 additional students to subject_id 2, excluding John Doe and David Williams
INSERT INTO StudentSubjects (student_id, subject_id, enrollment_date)
SELECT student_id, 2, CURDATE()
FROM Students
WHERE student_id NOT IN (1, 6)  -- Exclude John Doe and David Williams
ORDER BY RAND()  -- Randomize the order of selected students
LIMIT 8;

-- Step 3: Assign the remaining students to random subjects (1, 3, or 4)
INSERT INTO StudentSubjects (student_id, subject_id, enrollment_date)
SELECT student_id, FLOOR(1 + RAND() * 3), CURDATE()  -- Randomly selects subject_id 1, 3, or 4
FROM Students
WHERE student_id NOT IN (SELECT student_id FROM StudentSubjects);  -- Exclude students already assigned

-- Table to store assignment types with subjects and weights
CREATE TABLE IF NOT EXISTS AssignmentTypes (
    assignment_type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    weight DECIMAL(5, 2) NOT NULL CHECK (weight >= 0 AND weight <= 1),
    subject_id INT, -- Link assignment types to subjects
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Insert assignment types for CSC_350 (subject_id = 2)
INSERT INTO AssignmentTypes (type_name, weight, subject_id)
VALUES
    ('Homework', 0.20, 2),
    ('Quizzes', 0.10, 2),
    ('Midterm', 0.30, 2),
    ('Final Project', 0.40, 2);


-- Table to store individual assignments associated with an assignment type and teacher
CREATE TABLE IF NOT EXISTS Assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    assignment_type_id INT,
    teacher_id INT, -- Link to the teacher who created the assignment
    name VARCHAR(50) NOT NULL,
    max_score DECIMAL(5, 2) DEFAULT 100,
    due_date DATE NOT NULL, -- Due date for the assignment
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Date when the assignment was created
    FOREIGN KEY (assignment_type_id) REFERENCES AssignmentTypes(assignment_type_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Insert 5 random homework assignments for CSC_350 (assignment_type_id = ID for Homework in CSC_350)
INSERT INTO Assignments (assignment_type_id, teacher_id, name, max_score, due_date, creation_date)
VALUES
    (1, 2, 'Homework 1', 100, DATE_ADD(CURDATE(), INTERVAL 7 DAY), CURDATE()),
    (1, 2, 'Homework 2', 100, DATE_ADD(CURDATE(), INTERVAL 14 DAY), CURDATE()),
    (1, 2, 'Homework 3', 100, DATE_ADD(CURDATE(), INTERVAL 21 DAY), CURDATE()),
    (1, 2, 'Homework 4', 100, DATE_ADD(CURDATE(), INTERVAL 28 DAY), CURDATE()),
    (1, 2, 'Homework 5', 100, DATE_ADD(CURDATE(), INTERVAL 35 DAY), CURDATE());

-- Insert 8 random quizzes for CSC_350 (assignment_type_id = ID for Quizzes in CSC_350)
INSERT INTO Assignments (assignment_type_id, teacher_id, name, max_score, due_date, creation_date)
VALUES
    (2, 2, 'Quiz 1', 100, DATE_ADD(CURDATE(), INTERVAL 5 DAY), CURDATE()),
    (2, 2, 'Quiz 2', 100, DATE_ADD(CURDATE(), INTERVAL 10 DAY), CURDATE()),
    (2, 2, 'Quiz 3', 100, DATE_ADD(CURDATE(), INTERVAL 15 DAY), CURDATE()),
    (2, 2, 'Quiz 4', 100, DATE_ADD(CURDATE(), INTERVAL 20 DAY), CURDATE()),
    (2, 2, 'Quiz 8', 100, DATE_ADD(CURDATE(), INTERVAL 40 DAY), CURDATE());

-- Insert 1 midterm assignment for CSC_350 (assignment_type_id = ID for Midterm in CSC_350)
INSERT INTO Assignments (assignment_type_id, teacher_id, name, max_score, due_date, creation_date)
VALUES
    (3, 2, 'Midterm Exam', 100, DATE_ADD(CURDATE(), INTERVAL 45 DAY), CURDATE());

-- Insert 1 final project for CSC_350 (assignment_type_id = ID for Final Project in CSC_350)
INSERT INTO Assignments (assignment_type_id, teacher_id, name, max_score, due_date, creation_date)
VALUES
    (4, 2, 'Final Project', 100, DATE_ADD(CURDATE(), INTERVAL 60 DAY), CURDATE());


-- Table to store individual grades for each assignment and student, with submission date, grading date, and teacher ID
CREATE TABLE IF NOT EXISTS Grades (
    grade_id INT AUTO_INCREMENT,
    student_id INT,
    assignment_id INT,
    teacher_id INT, -- The teacher who graded the assignment
    score DECIMAL(5, 2) CHECK (score >= 0),
    submission_date DATE, -- Date the student submitted the assignment
    grading_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Date the grade was assigned
    PRIMARY KEY (student_id, assignment_id), -- Composite primary key for unique pairs
    UNIQUE (grade_id), -- Unique identifier for each grade entry
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (assignment_id) REFERENCES Assignments(assignment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO Grades (student_id,assignment_id,teacher_id,score)
VALUES
    (1,1,2,75),
    (1,2,2,89),
    (1,3,2,103),
    (1,4,2,55),
    (1,5,2,100),
    (1,6,2,65),
    (1,7,2,78),
    (1,8,2,99),
    (1,9,2,76),
    (1,10,2,69),
    (1,11,2,86),
    (1,12,2,90);

-- View to calculate and view the final grade for each student dynamically, with subject_id included
CREATE VIEW StudentFinalGrades AS
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    sub.subject_id,
    sub.subject_name,
    sub.subject_code,

    -- Average Homework Score
    COALESCE(
        (SELECT AVG(g.score) 
         FROM Grades g
         JOIN Assignments a ON g.assignment_id = a.assignment_id
         JOIN AssignmentTypes at ON a.assignment_type_id = at.assignment_type_id
         WHERE g.student_id = s.student_id 
           AND at.subject_id = sub.subject_id 
           AND at.type_name = 'Homework'), 
        0
    ) AS avg_homework,

    -- Average Quizzes Score (Dropping the Lowest Grade)
    COALESCE(
        (SELECT AVG(g.score) 
         FROM Grades g
         JOIN Assignments a ON g.assignment_id = a.assignment_id
         JOIN AssignmentTypes at ON a.assignment_type_id = at.assignment_type_id
         WHERE g.student_id = s.student_id 
           AND at.subject_id = sub.subject_id 
           AND at.type_name = 'Quizzes'
           AND g.score != (
               SELECT MIN(g2.score) 
               FROM Grades g2 
               JOIN Assignments a2 ON g2.assignment_id = a2.assignment_id
               JOIN AssignmentTypes at2 ON a2.assignment_type_id = at2.assignment_type_id
               WHERE g2.student_id = s.student_id 
                 AND at2.subject_id = sub.subject_id 
                 AND at2.type_name = 'Quizzes')
         ), 
        0
    ) AS avg_quizzes,

    -- Average Midterm Score
    COALESCE(
        (SELECT AVG(g.score) 
         FROM Grades g
         JOIN Assignments a ON g.assignment_id = a.assignment_id
         JOIN AssignmentTypes at ON a.assignment_type_id = at.assignment_type_id
         WHERE g.student_id = s.student_id 
           AND at.subject_id = sub.subject_id 
           AND at.type_name = 'Midterm'), 
        0
    ) AS avg_midterm,

    -- Average Final Project Score
    COALESCE(
        (SELECT AVG(g.score) 
         FROM Grades g
         JOIN Assignments a ON g.assignment_id = a.assignment_id
         JOIN AssignmentTypes at ON a.assignment_type_id = at.assignment_type_id
         WHERE g.student_id = s.student_id 
           AND at.subject_id = sub.subject_id 
           AND at.type_name = 'Final Project'), 
        0
    ) AS avg_final_project,

    -- Final Grade Calculation
    ROUND(
        COALESCE((
            (SELECT AVG(g.score) 
             FROM Grades g
             JOIN Assignments a ON g.assignment_id = a.assignment_id
             JOIN AssignmentTypes at ON a.assignment_type_id = at.assignment_type_id
             WHERE g.student_id = s.student_id 
               AND at.subject_id = sub.subject_id 
               AND at.type_name = 'Homework') * 0.20), 0)
        + COALESCE((
            (SELECT AVG(g.score) 
             FROM Grades g
             JOIN Assignments a ON g.assignment_id = a.assignment_id
             JOIN AssignmentTypes at ON a.assignment_type_id = at.assignment_type_id
             WHERE g.student_id = s.student_id 
               AND at.subject_id = sub.subject_id 
               AND at.type_name = 'Quizzes'
               AND g.score != (
                   SELECT MIN(g2.score) 
                   FROM Grades g2 
                   JOIN Assignments a2 ON g2.assignment_id = a2.assignment_id
                   JOIN AssignmentTypes at2 ON a2.assignment_type_id = at2.assignment_type_id
                   WHERE g2.student_id = s.student_id 
                     AND at2.subject_id = sub.subject_id 
                     AND at2.type_name = 'Quizzes')) * 0.10), 0)
        + COALESCE((
            (SELECT AVG(g.score) 
             FROM Grades g
             JOIN Assignments a ON g.assignment_id = a.assignment_id
             JOIN AssignmentTypes at ON a.assignment_type_id = at.assignment_type_id
             WHERE g.student_id = s.student_id 
               AND at.subject_id = sub.subject_id 
               AND at.type_name = 'Midterm') * 0.30), 0)
        + COALESCE((
            (SELECT AVG(g.score) 
             FROM Grades g
             JOIN Assignments a ON g.assignment_id = a.assignment_id
             JOIN AssignmentTypes at ON a.assignment_type_id = at.assignment_type_id
             WHERE g.student_id = s.student_id 
               AND at.subject_id = sub.subject_id 
               AND at.type_name = 'Final Project') * 0.40), 0)
    , 0) AS final_grade

FROM Students s
JOIN StudentSubjects ss ON s.student_id = ss.student_id
JOIN Subjects sub ON ss.subject_id = sub.subject_id;


-- View for teachers to see all students' grades in their assigned subjects
CREATE VIEW TeacherStudentGrades AS
SELECT 
    t.teacher_id,
    t.first_name AS teacher_first_name,
    t.last_name AS teacher_last_name,
    sub.subject_name,
    sub.subject_code,
    s.student_id,
    s.first_name AS student_first_name,
    s.last_name AS student_last_name,
    sf.final_grade
FROM Teachers t
JOIN Subjects sub ON t.subject_id = sub.subject_id
JOIN StudentSubjects ss ON sub.subject_id = ss.subject_id
JOIN Students s ON ss.student_id = s.student_id
LEFT JOIN StudentFinalGrades sf ON s.student_id = sf.student_id AND sub.subject_id = sf.subject_id;
