# 05. Tìm hiểu ngôn ngữ SQL

## 1. SQL là gì
**SQL (Structured Query Language)** — ngôn ngữ khai báo (declarative) để định nghĩa, thao tác và truy vấn dữ liệu trong RDBMS: ta mô tả **cần gì**, RDBMS (query optimizer) tự quyết định **lấy thế nào**. Chuẩn ANSI/ISO (SQL-92, SQL:1999, …, SQL:2023); mỗi RDBMS có "phương ngữ" riêng (MySQL, PL/pgSQL, T-SQL).

## 2. Năm nhóm lệnh

| Nhóm | Tên đầy đủ | Lệnh | Ví dụ trong repo |
|---|---|---|---|
| **DDL** | Data Definition | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` | `sql/*/01_schema.sql` |
| **DML** | Data Manipulation | `INSERT`, `UPDATE`, `DELETE` | `02_seed.sql`, Q10–Q11 |
| **DQL** | Data Query | `SELECT` | Q1–Q9 |
| **DCL** | Data Control | `GRANT`, `REVOKE` | mục 6 |
| **TCL** | Transaction Control | `BEGIN/START TRANSACTION`, `COMMIT`, `ROLLBACK`, `SAVEPOINT` | Q10–Q11 |

## 3. Ràng buộc toàn vẹn (Constraints)

| Ràng buộc | Ý nghĩa | Trong `school_demo` |
|---|---|---|
| `PRIMARY KEY` | Định danh duy nhất mỗi hàng, không NULL | `students.student_id`, khoá kép `enrollments(student_id, course_id, semester)` |
| `FOREIGN KEY` | Tham chiếu tới PK bảng khác | `enrollments.student_id → students` |
| `ON DELETE CASCADE / SET NULL` | Hành vi khi xoá hàng cha | xoá SV → xoá luôn đăng ký |
| `UNIQUE` | Không trùng | `student_code`, `email` |
| `NOT NULL` | Bắt buộc có giá trị | `full_name` |
| `CHECK` | Điều kiện logic | `score BETWEEN 0 AND 10` |
| `DEFAULT` | Giá trị mặc định | `created_at` |

## 4. Mô hình dữ liệu mẫu

```
departments 1 ──── N students N ──── N courses N ──── 1 departments
                          \              /
                           enrollments (score, semester)
```

## 5. Thứ tự thực thi logic của SELECT

| Thứ tự viết | Thứ tự **thực thi** |
|---|---|
| 1. SELECT | 1. FROM / JOIN |
| 2. FROM | 2. WHERE |
| 3. JOIN … ON | 3. GROUP BY |
| 4. WHERE | 4. HAVING |
| 5. GROUP BY | 5. SELECT (tính cột, window function) |
| 6. HAVING | 6. DISTINCT |
| 7. ORDER BY | 7. ORDER BY |
| 8. LIMIT | 8. LIMIT / OFFSET |

→ Vì vậy **không** dùng alias của SELECT trong WHERE được, nhưng dùng trong ORDER BY được; điều kiện trên hàm gộp (`COUNT`, `AVG`) phải đặt ở `HAVING`.

## 6. Bảng tra cứu cú pháp

| Chủ đề | Cú pháp | Câu trong `03_queries.sql` |
|---|---|---|
| Lọc | `WHERE`, `AND/OR`, `BETWEEN`, `IN`, `LIKE '%x%'`, `IS NULL` | Q1, Q2 |
| Sắp xếp/giới hạn | `ORDER BY col DESC LIMIT n` | Q1 |
| INNER JOIN | chỉ hàng khớp ở cả 2 bảng | Q3 |
| LEFT JOIN | giữ mọi hàng bảng trái, bảng phải NULL nếu không khớp | Q4, Q9 |
| Hàm gộp | `COUNT, SUM, AVG, MIN, MAX` + `GROUP BY` | Q5 |
| Lọc nhóm | `HAVING` | Q5, Q6 |
| Subquery | `(SELECT AVG(score) FROM enrollments)` | Q6 |
| Điều kiện | `CASE WHEN … THEN … ELSE … END`, `COALESCE` | Q4, Q7 |
| Window function | `RANK() OVER (PARTITION BY … ORDER BY …)` | Q8 |
| View | `CREATE VIEW v AS SELECT …` | Q9 |
| Transaction | `START TRANSACTION … ROLLBACK/COMMIT` | Q10, Q11 |
| Index | `CREATE INDEX idx ON t(col)` | `01_schema.sql` |
| Phân quyền | `CREATE USER u; GRANT SELECT ON db.* TO u; REVOKE …` | — |

## 7. Các loại JOIN

| JOIN | Kết quả |
|---|---|
| `INNER JOIN` | A ∩ B |
| `LEFT JOIN` | Toàn bộ A + phần khớp của B |
| `RIGHT JOIN` | Toàn bộ B + phần khớp của A |
| `FULL OUTER JOIN` | A ∪ B (PostgreSQL có; MySQL không có → dùng `LEFT … UNION … RIGHT`) |
| `CROSS JOIN` | Tích Descartes A × B |
| Self join | Bảng join với chính nó (vd. nhân viên – quản lý) |

## 8. Khác biệt cú pháp MySQL vs PostgreSQL gặp trong bài

| Việc | MySQL/MariaDB | PostgreSQL |
|---|---|---|
| Tự tăng | `INT AUTO_INCREMENT` | `INT GENERATED ALWAYS AS IDENTITY` |
| Chọn DB | `USE school_demo;` | `\c school_demo` (lệnh của psql) |
| Liệt kê bảng | `SHOW TABLES;` | `\dt` |
| Mô tả bảng | `DESCRIBE students;` | `\d students` |
| Nối chuỗi | `CONCAT(a, b)` | `a \|\| b` hoặc `CONCAT` |
| Bắt đầu transaction | `START TRANSACTION` | `BEGIN` hoặc `START TRANSACTION` |
| Phân biệt hoa/thường khi so chuỗi | Mặc định **không** (collation `_ci`) | **Có** (dùng `ILIKE` để bỏ qua) |

## 9. Kết quả tiêu biểu (PostgreSQL 16.15)

Q5 — môn có ≥ 2 SV:

| course_code | title | so_sv | diem_tb | diem_max |
|---|---|---|---|---|
| CS3005 | Học máy | 2 | 8.50 | 9.50 |
| MA2002 | Xác suất thống kê | 2 | 8.00 | 8.00 |
| ET3001 | Xử lý ảnh và Thị giác máy tính | 2 | 8.00 | 9.00 |

> MA2002 có 2 SV nhưng 1 SV điểm NULL → `COUNT(*)` = 2, còn `AVG(score)` bỏ qua NULL nên = 8.00.
| CS2001 | Cơ sở dữ liệu | 3 | 7.33 | 8.50 |
| MA1001 | Đại số tuyến tính | 2 | 6.50 | 9.00 |

Đầy đủ: [sql/postgresql/output.txt](../sql/postgresql/output.txt).
