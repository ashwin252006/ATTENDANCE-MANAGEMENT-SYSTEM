-- -------------------------------------------------
-- Attendance Management System – MySQL 8 schema
-- -------------------------------------------------
CREATE DATABASE IF NOT EXISTS `ams_db`
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `ams_db`;

-- ---------- USERS (central auth table) ----------
CREATE TABLE `users` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email`         VARCHAR(190)    NOT NULL,
  `password_hash` CHAR(60)        NOT NULL,
  `role`          ENUM('ADMIN','FACULTY','STUDENT') NOT NULL,
  `is_active`     BOOLEAN         NOT NULL DEFAULT TRUE,
  `created_at`    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_email` (`email`)
) ENGINE=InnoDB;

-- ---------- DEPARTMENTS ----------
CREATE TABLE `departments` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code`        VARCHAR(10)     NOT NULL,
  `name`        VARCHAR(100)    NOT NULL,
  `description` TEXT,
  `created_at`  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_dept_code` (`code`),
  UNIQUE KEY `uq_dept_name` (`name`)
) ENGINE=InnoDB;

-- ---------- CLASSES (year/section) ----------
CREATE TABLE `classes` (
  `id`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name`           VARCHAR(50)     NOT NULL,
  `dept_id`        BIGINT UNSIGNED NOT NULL,
  `academic_year`  VARCHAR(9)      NOT NULL,
  `created_at`     TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`     TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_class_name_year` (`name`,`academic_year`),
  FOREIGN KEY (`dept_id`) REFERENCES `departments`(`id`) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------- SUBJECTS ----------
CREATE TABLE `subjects` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code`        VARCHAR(15)     NOT NULL,
  `name`        VARCHAR(100)    NOT NULL,
  `credits`     TINYINT UNSIGNED NOT NULL DEFAULT 3,
  `dept_id`     BIGINT UNSIGNED NOT NULL,
  `created_at`  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_subj_code` (`code`),
  FOREIGN KEY (`dept_id`) REFERENCES `departments`(`id`) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------- STUDENTS ----------
CREATE TABLE `students` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`         BIGINT UNSIGNED NOT NULL,
  `roll_no`         VARCHAR(30)     NOT NULL,
  `first_name`      VARCHAR(50)     NOT NULL,
  `last_name`       VARCHAR(50)     NOT NULL,
  `dob`             DATE,
  `gender`          ENUM('M','F','O'),
  `phone`           VARCHAR(20),
  `address`         TEXT,
  `class_id`        BIGINT UNSIGNED NOT NULL,
  `dept_id`         BIGINT UNSIGNED NOT NULL,
  `admission_date`  DATE            NOT NULL,
  `created_at`      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_student_user` (`user_id`),
  UNIQUE KEY `uq_student_roll` (`roll_no`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`class_id`) REFERENCES `classes`(`id`) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (`dept_id`) REFERENCES `departments`(`id`) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------- FACULTY ----------
CREATE TABLE `faculty` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`         BIGINT UNSIGNED NOT NULL,
  `employee_id`     VARCHAR(30)     NOT NULL,
  `first_name`      VARCHAR(50)     NOT NULL,
  `last_name`       VARCHAR(50)     NOT NULL,
  `phone`           VARCHAR(20),
  `address`         TEXT,
  `dept_id`         BIGINT UNSIGNED NOT NULL,
  `joining_date`    DATE            NOT NULL,
  `created_at`      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_faculty_user` (`user_id`),
  UNIQUE KEY `uq_faculty_emp` (`employee_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`dept_id`) REFERENCES `departments`(`id`) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------- FACULTY‑SUBJECT‑CLASS ASSIGNMENTS ----------
CREATE TABLE `faculty_subject_assignments` (
  `id`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `faculty_id`       BIGINT UNSIGNED NOT NULL,
  `subject_id`       BIGINT UNSIGNED NOT NULL,
  `class_id`         BIGINT UNSIGNED NOT NULL,
  `semester`         TINYINT UNSIGNED NOT NULL,
  `academic_year`    VARCHAR(9)      NOT NULL,
  `created_at`       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fsa_unique` (`faculty_id`,`subject_id`,`class_id`,`semester`,`academic_year`),
  FOREIGN KEY (`faculty_id`) REFERENCES `faculty`(`id`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`id`) ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (`class_id`)   REFERENCES `classes`(`id`)   ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------- CLASS SESSIONS (a concrete lecture/lab) ----------
CREATE TABLE `class_sessions` (
  `id`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `assignment_id`    BIGINT UNSIGNED NOT NULL,
  `session_date`     DATE            NOT NULL,
  `start_time`       TIME            NOT NULL,
  `end_time`         TIME            NOT NULL,
  `topic`            VARCHAR(200),
  `status`           ENUM('SCHEDULED','CONDUCTED','CANCELLED') NOT NULL DEFAULT 'SCHEDULED',
  `created_at`       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`assignment_id`) REFERENCES `faculty_subject_assignments`(`id`) ON UPDATE CASCADE ON DELETE CASCADE,
  INDEX `idx_session_date_assign` (`session_date`,`assignment_id`)
) ENGINE=InnoDB;

-- ---------- ATTENDANCE RECORDS ----------
CREATE TABLE `attendance_records` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `session_id`    BIGINT UNSIGNED NOT NULL,
  `student_id`    BIGINT UNSIGNED NOT NULL,
  `status`        ENUM('PRESENT','ABSENT','EXCUSED') NOT NULL,
  `marked_by`     BIGINT UNSIGNED NOT NULL,
  `marked_at`     TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_attendance_student_session` (`session_id`,`student_id`),
  FOREIGN KEY (`session_id`) REFERENCES `class_sessions`(`id`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`student_id`) REFERENCES `students`(`id`)   ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`marked_by`)  REFERENCES `users`(`id`)      ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;