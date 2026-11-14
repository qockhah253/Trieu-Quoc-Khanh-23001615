-- DML: INSERT dữ liệu mẫu (chạy được trên cả PostgreSQL và MySQL/MariaDB)
INSERT INTO departments (dept_name) VALUES
  ('Điện tử - Tin học'), ('Khoa học máy tính'), ('Toán ứng dụng');

INSERT INTO students (student_code, full_name, email, birth_date, dept_id) VALUES
  ('SV001', 'Triệu Quốc Khánh', 'khanh@example.edu', '2004-05-03', 1),
  ('SV002', 'Nguyễn Văn An',    'an@example.edu',    '2004-01-15', 1),
  ('SV003', 'Trần Thị Bình',    'binh@example.edu',  '2003-11-20', 2),
  ('SV004', 'Lê Minh Châu',     'chau@example.edu',  '2004-08-09', 2),
  ('SV005', 'Phạm Đức Dũng',    'dung@example.edu',  '2005-02-28', 3),
  ('SV006', 'Hoàng Gia Hân',    NULL,                '2004-12-01', NULL);

INSERT INTO courses (course_code, title, credits, dept_id) VALUES
  ('ET3001', 'Xử lý ảnh và Thị giác máy tính', 3, 1),
  ('ET3002', 'Hệ điều hành nhúng',             3, 1),
  ('CS2001', 'Cơ sở dữ liệu',                  4, 2),
  ('CS3005', 'Học máy',                        3, 2),
  ('MA1001', 'Đại số tuyến tính',              3, 3),
  ('MA2002', 'Xác suất thống kê',              2, 3);

INSERT INTO enrollments (student_id, course_id, semester, score) VALUES
  (1, 1, '2026.1', 9.0), (1, 3, '2026.1', 8.5), (1, 4, '2026.1', 9.5),
  (2, 1, '2026.1', 7.0), (2, 2, '2026.1', 6.5), (2, 5, '2026.1', 4.0),
  (3, 3, '2026.1', 8.0), (3, 4, '2026.1', 7.5),
  (4, 3, '2026.1', 5.5), (4, 6, '2026.1', NULL),
  (5, 5, '2026.1', 9.0), (5, 6, '2026.1', 8.0);
