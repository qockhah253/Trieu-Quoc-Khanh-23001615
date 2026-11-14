-- =====================================================================
-- CSDL mẫu: QUẢN LÝ ĐĂNG KÝ HỌC PHẦN  (MySQL 8 / MariaDB 10.4+ trong XAMPP)
-- Chạy: C:\xampp\mysql\bin\mysql.exe -u root < 01_schema.sql   (hoặc tab SQL trong phpMyAdmin)
-- Khác PostgreSQL: AUTO_INCREMENT thay cho IDENTITY, USE thay cho \c, ENGINE=InnoDB
-- =====================================================================
DROP DATABASE IF EXISTS school_demo;
CREATE DATABASE school_demo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE school_demo;

CREATE TABLE departments (
    dept_id    INT AUTO_INCREMENT PRIMARY KEY,
    dept_name  VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE students (
    student_id   INT AUTO_INCREMENT PRIMARY KEY,
    student_code VARCHAR(12) NOT NULL UNIQUE,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(120) UNIQUE,
    birth_date   DATE,
    dept_id      INT,
    created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE courses (
    course_id   INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) NOT NULL UNIQUE,
    title       VARCHAR(150) NOT NULL,
    credits     SMALLINT NOT NULL CHECK (credits BETWEEN 1 AND 6),
    dept_id     INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
) ENGINE=InnoDB;

CREATE TABLE enrollments (
    student_id  INT,
    course_id   INT,
    semester    VARCHAR(10) NOT NULL,
    score       DECIMAL(4,2) CHECK (score BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, course_id, semester),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id)  REFERENCES courses(course_id)   ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_students_dept ON students(dept_id);
CREATE INDEX idx_enroll_course ON enrollments(course_id);
