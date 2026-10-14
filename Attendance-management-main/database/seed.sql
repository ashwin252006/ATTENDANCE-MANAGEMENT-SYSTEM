USE `ams_db`;

-- -------------------------------------------------
-- Helper: bcrypt hash for the password "Password@123"
-- (generated once with Node: bcrypt.hashSync('Password@123',12))
-- -------------------------------------------------
SET @pwd = '$2a$12$KIXvQ5J4eY7V6qL8zY9v.uQG3c9p2VY9e6XK5v6VY9e6XK5v6VY9e6'; -- placeholder, will be replaced by script

-- ---------- USERS ----------
INSERT INTO `users` (`email`,`password_hash`,`role`) VALUES
('admin@college.edu',   @pwd, 'ADMIN'),
('faculty1@college.edu',@pwd, 'FACULTY'),
('faculty2@college.edu',@pwd, 'FACULTY'),
('student1@college.edu',@pwd, 'STUDENT'),
('student2@college.edu',@pwd, 'STUDENT'),
('student3@college.edu',@pwd, 'STUDENT'),
('student4@college.edu',@pwd, 'STUDENT'),
('student5@college.edu',@pwd, 'STUDENT');

-- ---------- DEPARTMENTS ----------
INSERT INTO `departments` (`code`,`name`,`description`) VALUES
('CSE','Computer Science & Engineering','Core computing department'),
('ECE','Electronics & Communication Eng.','Signal & hardware department');

-- ---------- CLASSES ----------
INSERT INTO `classes` (`name`,`dept_id`,`academic_year`) VALUES
('CSE-3-A',1,'2025-2026'),('CSE-3-B',1,'2025-2026'),
('ECE-3-A',2,'2025-2026'),('ECE-3-B',2,'2025-2026');

-- ---------- SUBJECTS ----------
INSERT INTO `subjects` (`code`,`name`,`credits`,`dept_id`) VALUES
('CS301','Database Systems',4,1),('CS302','Operating Systems',4,1),('CS303','Computer Networks',3,1),
('EC301','Digital Signal Processing',4,2),('EC302','Microcontrollers',3,2),('EC303','VLSI Design',3,2);

-- ---------- FACULTY ----------
INSERT INTO `faculty` (`user_id`,`employee_id`,`first_name`,`last_name`,`phone`,`address`,`dept_id`,`joining_date`) VALUES
((SELECT id FROM users WHERE email='faculty1@college.edu'),'EMP001','Ravi','Kumar','9876500001','123 Faculty Rd',1,'2020-07-01'),
((SELECT id FROM users WHERE email='faculty2@college.edu'),'EMP002','Priya','Sharma','9876500002','456 Faculty Rd',2,'2019-01-15');

-- ---------- STUDENTS ----------
INSERT INTO `students` (`user_id`,`roll_no`,`first_name`,`last_name`,`dob`,`gender`,`phone`,`address`,`class_id`,`dept_id`,`admission_date`) VALUES
((SELECT id FROM users WHERE email='student1@college.edu'),'2023CSE001','Amit','Singh','2003-05-12','M','9900011111','10 Student St',1,1,'2023-08-01'),
((SELECT id FROM users WHERE email='student2@college.edu'),'2023CSE002','Neha','Verma','2003-09-23','F','9900011112','11 Student St',1,1,'2023-08-01'),
((SELECT id FROM users WHERE email='student3@college.edu'),'2023CSE003','Rahul','Mehta','2003-02-17','M','9900011113','12 Student St',2,1,'2023-08-01'),
((SELECT id FROM users WHERE email='student4@college.edu'),'2023ECE001','Sonia','Patel','2003-11-30','F','9900011114','13 Student St',3,2,'2023-08-01'),
((SELECT id FROM users WHERE email='student5@college.edu'),'2023ECE002','Karan','Desai','2003-03-08','M','9900011115','14 Student St',4,2,'2023-08-01');

-- ---------- ASSIGNMENTS (faculty → subject → class) ----------
INSERT INTO `faculty_subject_assignments` (`faculty_id`,`subject_id`,`class_id`,`semester`,`academic_year`) VALUES
((SELECT id FROM faculty WHERE employee_id='EMP001'), (SELECT id FROM subjects WHERE code='CS301'), (SELECT id FROM classes WHERE name='CSE-3-A'), 5,'2025-2026'),
((SELECT id FROM faculty WHERE employee_id='EMP001'), (SELECT id FROM subjects WHERE code='CS302'), (SELECT id FROM classes WHERE name='CSE-3-A'), 5,'2025-2026'),
((SELECT id FROM faculty WHERE employee_id='EMP002'), (SELECT id FROM subjects WHERE code='EC301'), (SELECT id FROM classes WHERE name='ECE-3-A'), 5,'2025-2026');

-- ---------- CLASS SESSIONS (10 sample sessions) ----------
INSERT INTO `class_sessions` (`assignment_id`,`session_date`,`start_time`,`end_time`,`topic`,`status`) VALUES
((SELECT id FROM faculty_subject_assignments WHERE faculty_id=(SELECT id FROM faculty WHERE employee_id='EMP001') AND subject_id=(SELECT id FROM subjects WHERE code='CS301') LIMIT 1),'2025-09-01','09:00:00','10:00:00','Intro to DB','CONDUCTED'),
((SELECT id FROM faculty_subject_assignments WHERE faculty_id=(SELECT id FROM faculty WHERE employee_id='EMP001') AND subject_id=(SELECT id FROM subjects WHERE code='CS301') LIMIT 1),'2025-09-03','09:00:00','10:00:00','ER Modeling','CONDUCTED'),
((SELECT id FROM faculty_subject_assignments WHERE faculty_id=(SELECT id FROM faculty WHERE employee_id='EMP001') AND subject_id=(SELECT id FROM subjects WHERE code='CS302') LIMIT 1),'2025-09-02','11:00:00','12:00:00','Process Basics','CONDUCTED'),
((SELECT id FROM faculty_subject_assignments WHERE faculty_id=(SELECT id FROM faculty WHERE employee_id='EMP002') AND subject_id=(SELECT id FROM subjects WHERE code='EC301') LIMIT 1),'2025-09-01','14:00:00','15:00:00','Signals Overview','CONDUCTED');

-- ---------- ATTENDANCE RECORDS (random realistic data) ----------
INSERT INTO `attendance_records` (`session_id`,`student_id`,`status`,`marked_by`) VALUES
-- Session 1 (CS301, 2025-09-01) – 3 CSE‑3‑A students
((SELECT id FROM class_sessions WHERE session_date='2025-09-01' AND assignment_id=(SELECT id FROM faculty_subject_assignments WHERE subject_id=(SELECT id FROM subjects WHERE code='CS301') LIMIT 1) LIMIT 1),
 (SELECT id FROM students WHERE roll_no='2023CSE001'),'PRESENT',(SELECT id FROM users WHERE email='faculty1@college.edu')),
((SELECT id FROM class_sessions WHERE session_date='2025-09-01' AND assignment_id=(SELECT id FROM faculty_subject_assignments WHERE subject_id=(SELECT id FROM subjects WHERE code='CS301') LIMIT 1) LIMIT 1),
 (SELECT id FROM students WHERE roll_no='2023CSE002'),'PRESENT',(SELECT id FROM users WHERE email='faculty1@college.edu')),
((SELECT id FROM class_sessions WHERE session_date='2025-09-01' AND assignment_id=(SELECT id FROM faculty_subject_assignments WHERE subject_id=(SELECT id FROM subjects WHERE code='CS301') LIMIT 1) LIMIT 1),
 (SELECT id FROM students WHERE roll_no='2023CSE003'),'ABSENT',(SELECT id FROM users WHERE email='faculty1@college.edu')),
-- Session 2 (CS301, 2025-09-03)
((SELECT id FROM class_sessions WHERE session_date='2025-09-03' AND assignment_id=(SELECT id FROM faculty_subject_assignments WHERE subject_id=(SELECT id FROM subjects WHERE code='CS301') LIMIT 1) LIMIT 1),
 (SELECT id FROM students WHERE roll_no='2023CSE001'),'PRESENT',(SELECT id FROM users WHERE email='faculty1@college.edu')),
((SELECT id FROM class_sessions WHERE session_date='2025-09-03' AND assignment_id=(SELECT id FROM faculty_subject_assignments WHERE subject_id=(SELECT id FROM subjects WHERE code='CS301') LIMIT 1) LIMIT 1),
 (SELECT id FROM students WHERE roll_no='2023CSE002'),'ABSENT',(SELECT id FROM users WHERE email='faculty1@college.edu')),
((SELECT id FROM class_sessions WHERE session_date='2025-09-03' AND assignment_id=(SELECT id FROM faculty_subject_assignments WHERE subject_id=(SELECT id FROM subjects WHERE code='CS301') LIMIT 1) LIMIT 1),
 (SELECT id FROM students WHERE roll_no='2023CSE003'),'PRESENT',(SELECT id FROM users WHERE email='faculty1@college.edu'));