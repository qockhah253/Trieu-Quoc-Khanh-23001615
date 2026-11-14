#!/usr/bin/env bash
# Demo virtualenv: cài, tạo env, so sánh tốc độ tạo với venv
set -e
cd "$(dirname "$0")"
rm -rf /tmp/ve_demo && mkdir -p /tmp/ve_demo

echo "== [1] Cài virtualenv (vào 1 venv công cụ riêng, không bẩn Python hệ thống) =="
python3 -m venv /tmp/ve_demo/tools
/tmp/ve_demo/tools/bin/pip install -q virtualenv
/tmp/ve_demo/tools/bin/virtualenv --version

echo; echo "== [2] Tạo env bằng virtualenv, có chọn interpreter bằng -p =="
/tmp/ve_demo/tools/bin/virtualenv -q -p python3 /tmp/ve_demo/env1
/tmp/ve_demo/env1/bin/pip install -q six==1.16.0
/tmp/ve_demo/env1/bin/python ../common/check_env.py

echo; echo "== [3] So sánh thời gian tạo env (5 lần mỗi loại) =="
t0=$(date +%s.%N); for i in 1 2 3 4 5; do python3 -m venv /tmp/ve_demo/v$i; done; t1=$(date +%s.%N)
for i in 1 2 3 4 5; do /tmp/ve_demo/tools/bin/virtualenv -q /tmp/ve_demo/w$i; done; t2=$(date +%s.%N)
python3 -c "print(f'venv       : {($t1-$t0)/5:.2f} s/env'); print(f'virtualenv : {($t2-$t1)/5:.2f} s/env')"
