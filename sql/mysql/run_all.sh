#!/usr/bin/env bash
# Chạy toàn bộ script SQL trên MySQL/MariaDB (-v -v -t: in câu lệnh + bảng kết quả)
cd "$(dirname "$0")"
mysql --default-character-set=utf8mb4 -u root < 01_schema.sql
mysql --default-character-set=utf8mb4 -u root school_demo < ../common/02_seed.sql
mysql --default-character-set=utf8mb4 -u root -t -vvv --force school_demo < ../common/03_queries.sql
