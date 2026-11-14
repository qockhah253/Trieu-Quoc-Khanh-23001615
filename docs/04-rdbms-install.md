# 04. Cài đặt RDBMS trên máy cá nhân (Windows 11) và dùng thử

## 1. RDBMS là gì

| Khái niệm | Giải thích |
|---|---|
| DBMS | Phần mềm quản lý cơ sở dữ liệu (lưu, truy vấn, bảo mật, sao lưu) |
| **RDBMS** | DBMS theo **mô hình quan hệ** (E. F. Codd, 1970): dữ liệu lưu thành **bảng** (relation) gồm hàng (tuple) và cột (attribute); liên kết bằng khoá (PK/FK); truy vấn bằng **SQL** |
| ACID | Atomicity (tất cả hoặc không), Consistency (luôn đúng ràng buộc), Isolation (giao dịch không giẫm nhau), Durability (đã COMMIT thì không mất) |
| Mô hình Client–Server | Server (`mysqld`, `postgres`) lắng nghe cổng (3306 / 5432); client (`mysql`, `psql`, phpMyAdmin, pgAdmin, DBeaver) kết nối vào |

## 2. So sánh các RDBMS phổ biến

| Tiêu chí | MySQL 8.4 | MariaDB 10.x/11.x | PostgreSQL 16–18 | SQLite | SQL Server |
|---|---|---|---|---|---|
| Giấy phép | GPL (Oracle) | GPL (fork của MySQL) | PostgreSQL (BSD-like) | Public domain | Thương mại (có bản Express) |
| Cổng mặc định | 3306 | 3306 | 5432 | — (file) | 1433 |
| Client CLI | `mysql` | `mysql` / `mariadb` | `psql` | `sqlite3` | `sqlcmd` |
| GUI | MySQL Workbench, phpMyAdmin | phpMyAdmin, HeidiSQL | pgAdmin 4 | DB Browser | SSMS |
| Điểm mạnh | Phổ biến web (LAMP), dễ dùng | Tương thích MySQL, mã nguồn mở hoàn toàn | Chuẩn SQL đầy đủ, JSONB, extension (PostGIS, **pgvector** cho AI/RAG) | Nhúng, không cần server | Hệ sinh thái Microsoft |
| Auto increment | `AUTO_INCREMENT` | `AUTO_INCREMENT` | `GENERATED AS IDENTITY` / `SERIAL` | `AUTOINCREMENT` | `IDENTITY(1,1)` |

## 3. Cách cài trên Windows (chọn 1 hoặc nhiều)

### Cách 1 — MySQL/MariaDB qua XAMPP (máy đã cài tại `C:\xampp`)

| # | Thao tác | Kiểm tra |
|---|---|---|
| 1 | Mở `C:\xampp\xampp-control.exe` → bấm **Start** ở dòng MySQL | Dòng MySQL chuyển xanh, Port 3306 |
| 2 | PowerShell: `C:\xampp\mysql\bin\mysql.exe -u root -e "SELECT VERSION();"` | In `10.4.x-MariaDB` (XAMPP dùng MariaDB) |
| 3 | Trình duyệt: `http://localhost/phpmyadmin` (cần Start Apache) | Thấy giao diện phpMyAdmin |

### Cách 1b — MySQL Community Server bản gốc

| # | Thao tác |
|---|---|
| 1 | `winget install -e --id Oracle.MySQL` hoặc tải MySQL Installer tại https://dev.mysql.com/downloads/installer/ |
| 2 | Chọn *Server only* hoặc *Developer Default* (kèm Workbench), đặt mật khẩu root, cổng **3307** nếu XAMPP đang chiếm 3306 |
| 3 | Kiểm tra: `"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe" -u root -p -P 3307 -e "SELECT VERSION();"` |

### Cách 2 — PostgreSQL (máy đã cài PostgreSQL 18 + pgAdmin 4)

| # | Thao tác | Kiểm tra |
|---|---|---|
| 1 | (Nếu chưa cài) `winget install -e --id PostgreSQL.PostgreSQL.17` hoặc installer EDB https://www.postgresql.org/download/windows/ | — |
| 2 | Kiểm tra service: `Get-Service postgresql*` | Status = Running |
| 3 | CLI: `"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -c "SELECT version();"` | In `PostgreSQL 18.x` |
| 4 | GUI: mở **pgAdmin 4** → Servers → PostgreSQL 18 → nhập mật khẩu | Thấy database `postgres` |

### Cách 3 — Chạy bằng Docker (kết hợp phần container)

| # | Thao tác |
|---|---|
| 1 | `docker compose -f C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS\sql\docker-compose.yml up -d` |
| 2 | MySQL: `docker exec -it sql-mysql-1 mysql -uroot -proot123` |
| 3 | Postgres: `docker exec -it sql-postgres-1 psql -U postgres` |

## 4. Dùng thử: nạp CSDL mẫu `school_demo`

### 4.1 Trên MySQL/MariaDB (XAMPP)

```powershell
$Repo  = "C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS"
$MySQL = "C:\xampp\mysql\bin\mysql.exe"
Get-Content "$Repo\sql\mysql\01_schema.sql"  | & $MySQL --default-character-set=utf8mb4 -u root
Get-Content "$Repo\sql\common\02_seed.sql"   | & $MySQL --default-character-set=utf8mb4 -u root school_demo
Get-Content "$Repo\sql\common\03_queries.sql"| & $MySQL --default-character-set=utf8mb4 -u root -t -vvv --force school_demo
```
Hoặc phpMyAdmin → tab **SQL** → dán lần lượt nội dung 3 file → **Go**.

### 4.2 Trên PostgreSQL 18

```powershell
$Repo = "C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS"
$Psql = "C:\Program Files\PostgreSQL\18\bin\psql.exe"
$env:PGCLIENTENCODING = "UTF8"
& $Psql -U postgres -f "$Repo\sql\postgresql\01_schema.sql"
& $Psql -U postgres -d school_demo -f "$Repo\sql\common\02_seed.sql"
& $Psql -U postgres -d school_demo -e -f "$Repo\sql\common\03_queries.sql"
```
Hoặc pgAdmin → chuột phải database → **Query Tool** → Open file → **F5**.

### 4.3 Kết quả đã chạy thật (môi trường Linux)

| RDBMS | Phiên bản | Output |
|---|---|---|
| PostgreSQL | 16.15 | [sql/postgresql/output.txt](../sql/postgresql/output.txt) |
| MariaDB (nhánh MySQL) | 10.11.14 | [sql/mysql/output.txt](../sql/mysql/output.txt) |

Câu Q12 **cố ý lỗi** để thấy ràng buộc `CHECK` hoạt động:
- PostgreSQL: `ERROR: new row for relation "enrollments" violates check constraint "enrollments_score_check"`
- MariaDB: `ERROR 4025 (23000): CONSTRAINT enrollments.score failed`

## 5. Ảnh chụp cần nộp (chụp trên máy mình)

| File | Nội dung |
|---|---|
| `screenshots/mysql_version.png` | Lệnh `SELECT VERSION();` trên MySQL/MariaDB |
| `screenshots/phpmyadmin_school_demo.png` | 4 bảng của `school_demo` trong phpMyAdmin |
| `screenshots/pgadmin_query.png` | Kết quả Q5 trong pgAdmin Query Tool |
