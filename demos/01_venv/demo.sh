#!/usr/bin/env bash
# Demo venv: 2 project, cùng 1 Python, 2 phiên bản requests khác nhau -> không xung đột
set -e
cd "$(dirname "$0")"
rm -rf /tmp/venv_demo && mkdir -p /tmp/venv_demo/{projectA,projectB}

echo "== [0] Python toàn cục (host) =="
python3 ../common/check_env.py

echo; echo "== [1] Tạo venv cho projectA và projectB =="
python3 -m venv /tmp/venv_demo/projectA/.venv
python3 -m venv /tmp/venv_demo/projectB/.venv
echo "Nội dung pyvenv.cfg của projectA:"
cat /tmp/venv_demo/projectA/.venv/pyvenv.cfg

echo; echo "== [2] Cài 2 phiên bản requests khác nhau =="
/tmp/venv_demo/projectA/.venv/bin/pip install -q "requests==2.31.0"
/tmp/venv_demo/projectB/.venv/bin/pip install -q "requests==2.32.3"

echo; echo "== [3] projectA (activate rồi chạy) =="
source /tmp/venv_demo/projectA/.venv/bin/activate
which python
python ../common/check_env.py
pip freeze > /tmp/venv_demo/projectA/requirements.txt
echo "requirements.txt:"; cat /tmp/venv_demo/projectA/requirements.txt
deactivate

echo; echo "== [4] projectB (không activate, gọi thẳng đường dẫn python) =="
/tmp/venv_demo/projectB/.venv/bin/python ../common/check_env.py

echo; echo "== [5] Kích thước venv =="
du -sh /tmp/venv_demo/projectA/.venv /tmp/venv_demo/projectB/.venv
