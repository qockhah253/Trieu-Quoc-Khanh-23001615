-- =====================================================================
-- CSDL mẫu: QUẢN LÝ ĐĂNG KÝ HỌC PHẦN  (PostgreSQL 16/18)
-- Chạy: psql -U postgres -f 01_schema.sql   (hoặc Query Tool trong pgAdmin 4)
-- =====================================================================
DROP DATABASE IF EXISTS school_demo;
CREATE DATABASE school_demo;
\c school_demo

-- DDL: CREATE TABLE + ràng buộc (PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK, NOT NULL, DEFAULT)
CREATE TABLE departments (
    dept_id    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dept_name  VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE students (
    student_id  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_code VARCHAR(12) NOT NULL UNIQUE,
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(120) UNIQUE,
    birth_date  DATE,
    dept_id     INT REFERENCES departments(dept_id) ON DELETE SET NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE courses (
    course_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_code VARCHAR(10) NOT NULL UNIQUE,
    title       VARCHAR(150) NOT NULL,
    credits     SMALLINT NOT NULL CHECK (credits BETWEEN 1 AND 6),
    dept_id     INT NOT NULL REFERENCES departments(dept_id)
);

-- Bảng trung gian quan hệ N-N (students <-> courses)
CREATE TABLE enrollments (
    student_id  INT REFERENCES students(student_id) ON DELETE CASCADE,
    course_id   INT REFERENCES courses(course_id)   ON DELETE CASCADE,
    semester    VARCHAR(10) NOT NULL,
    score       NUMERIC(4,2) CHECK (score BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, course_id, semester)
);

CREATE INDEX idx_students_dept ON students(dept_id);
CREATE INDEX idx_enroll_course ON enrollments(course_id);
