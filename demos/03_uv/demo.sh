#!/usr/bin/env bash
# Demo uv: cài Python, tạo project, add package, lock, run, so sánh tốc độ với pip
set -e
cd "$(dirname "$0")"
rm -rf /tmp/uv_demo && mkdir -p /tmp/uv_demo && cd /tmp/uv_demo
HERE_COMMON="$OLDPWD/../common"

echo "== [1] Phiên bản uv =="; uv --version

echo; echo "== [2] Các bản Python uv thấy/quản lý được (rút gọn) =="
uv python list 2>/dev/null | head -8

echo; echo "== [3] Tạo project mới =="
uv init -q demo_project && cd demo_project
ls -A
echo "--- pyproject.toml ---"; cat pyproject.toml

echo; echo "== [4] uv add requests (tự tạo .venv + uv.lock) =="
uv add -q "requests==2.32.3"
echo "--- pyproject.toml sau khi add ---"; cat pyproject.toml
echo "--- 15 dòng đầu uv.lock ---"; head -15 uv.lock

echo; echo "== [5] uv run =="
uv run python "$HERE_COMMON/check_env.py"

echo; echo "== [6] Tái lập: xoá .venv rồi uv sync =="
rm -rf .venv && uv sync -q && uv run python -c "import requests; print('requests', requests.__version__)"

echo; echo "== [7] Benchmark: cài pandas+requests+flask (cache đã ấm) =="
python3 -m venv /tmp/uv_demo/pipenv >/dev/null
/tmp/uv_demo/pipenv/bin/pip download -q -d /tmp/uv_demo/wh pandas requests flask >/dev/null 2>&1 || true
t0=$(date +%s.%N); /tmp/uv_demo/pipenv/bin/pip install -q pandas requests flask; t1=$(date +%s.%N)
uv venv -q /tmp/uv_demo/uvenv; uv pip install -q --python /tmp/uv_demo/uvenv/bin/python pandas requests flask >/dev/null 2>&1
rm -rf /tmp/uv_demo/uvenv; uv venv -q /tmp/uv_demo/uvenv
t2=$(date +%s.%N); uv pip install -q --python /tmp/uv_demo/uvenv/bin/python pandas requests flask; t3=$(date +%s.%N)
python3 -c "print(f'pip install : {$t1-$t0:.2f} s'); print(f'uv pip     : {$t3-$t2:.2f} s'); print(f'uv nhanh hơn ~{($t1-$t0)/($t3-$t2):.0f}x')"
