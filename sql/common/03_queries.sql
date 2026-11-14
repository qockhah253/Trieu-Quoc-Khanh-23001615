-- =====================================================================
-- Các câu truy vấn SQL cơ bản -> nâng cao (chạy được trên PostgreSQL & MySQL 8/MariaDB)
-- =====================================================================

-- Q1. SELECT + WHERE + ORDER BY + LIMIT: 3 sinh viên sinh năm 2004 trẻ nhất
SELECT student_code, full_name, birth_date
FROM students
WHERE birth_date BETWEEN '2004-01-01' AND '2004-12-31'
ORDER BY birth_date DESC
LIMIT 3;

-- Q2. LIKE + IS NULL: sinh viên chưa có email hoặc tên chứa "Minh"
SELECT student_code, full_name, email
FROM students
WHERE email IS NULL OR full_name LIKE '%Minh%';

-- Q3. INNER JOIN 3 bảng: bảng điểm đầy đủ
SELECT s.student_code, s.full_name, c.course_code, c.title, e.score
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses  c ON c.course_id  = e.course_id
ORDER BY s.student_code, c.course_code;

-- Q4. LEFT JOIN: sinh viên và khoa (kể cả SV chưa có khoa)
SELECT s.full_name, COALESCE(d.dept_name, '(chưa phân khoa)') AS dept
FROM students s
LEFT JOIN departments d ON d.dept_id = s.dept_id
ORDER BY s.student_id;

-- Q5. GROUP BY + aggregate + HAVING: môn có >= 2 SV, điểm TB
SELECT c.course_code, c.title,
       COUNT(*)              AS so_sv,
       ROUND(AVG(e.score),2) AS diem_tb,
       MAX(e.score)          AS diem_max
FROM courses c
JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_code, c.title
HAVING COUNT(*) >= 2
ORDER BY diem_tb DESC;

-- Q6. Subquery: SV có điểm TB cao hơn điểm TB toàn trường
SELECT s.full_name, ROUND(AVG(e.score),2) AS gpa
FROM students s JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id, s.full_name
HAVING AVG(e.score) > (SELECT AVG(score) FROM enrollments)
ORDER BY gpa DESC;

-- Q7. CASE WHEN: xếp loại điểm chữ
SELECT s.full_name, c.course_code, e.score,
       CASE WHEN e.score IS NULL THEN 'Chưa có điểm'
            WHEN e.score >= 8.5  THEN 'A'
            WHEN e.score >= 7.0  THEN 'B'
            WHEN e.score >= 5.5  THEN 'C'
            WHEN e.score >= 4.0  THEN 'D'
            ELSE 'F' END AS grade
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses  c ON c.course_id  = e.course_id
ORDER BY s.full_name, c.course_code;

-- Q8. Window function: xếp hạng SV trong từng môn
SELECT c.course_code, s.full_name, e.score,
       RANK() OVER (PARTITION BY c.course_id ORDER BY e.score DESC) AS hang
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses  c ON c.course_id  = e.course_id
WHERE e.score IS NOT NULL
ORDER BY c.course_code, hang;

-- Q9. VIEW: tổng tín chỉ đã đăng ký mỗi SV
CREATE VIEW v_student_credits AS
SELECT s.student_code, s.full_name, COALESCE(SUM(c.credits),0) AS tong_tin_chi
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
LEFT JOIN courses c     ON c.course_id  = e.course_id
GROUP BY s.student_id, s.student_code, s.full_name;

SELECT * FROM v_student_credits ORDER BY tong_tin_chi DESC;

-- Q10. UPDATE + DELETE trong TRANSACTION (TCL): ROLLBACK -> dữ liệu không đổi
START TRANSACTION;
UPDATE enrollments SET score = 10 WHERE student_id = 2;
DELETE FROM enrollments WHERE score < 5;
SELECT COUNT(*) AS rows_trong_transaction FROM enrollments;
ROLLBACK;
SELECT COUNT(*) AS rows_sau_rollback FROM enrollments;

-- Q11. UPDATE thật + COMMIT: nhập điểm còn thiếu
START TRANSACTION;
UPDATE enrollments SET score = 7.25 WHERE student_id = 4 AND course_id = 6;
COMMIT;
SELECT student_id, course_id, score FROM enrollments WHERE student_id = 4;

-- Q12. Ràng buộc hoạt động: CHECK chặn điểm 11 (câu này CỐ Ý báo lỗi)
INSERT INTO enrollments (student_id, course_id, semester, score) VALUES (6, 1, '2026.1', 11);
