#!/usr/bin/env bash
# Chạy toàn bộ script SQL trên PostgreSQL, in kết quả từng câu (-e echo câu lệnh)
cd "$(dirname "$0")"
psql -U postgres -q -f 01_schema.sql
psql -U postgres -d school_demo -q -f ../common/02_seed.sql
psql -U postgres -d school_demo -e -f ../common/03_queries.sql
