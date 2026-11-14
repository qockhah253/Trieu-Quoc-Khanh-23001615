#!/usr/bin/env bash
# Demo pyenv: nhiều phiên bản Python, global/local, cơ chế shims
# Ghi chú: môi trường demo chặn python.org nên không build từ source được (`pyenv install`).
# Thay vào đó đăng ký 2 interpreter có sẵn (3.12 do `uv python install` tải, 3.13 hệ thống)
# vào ~/.pyenv/versions — pyenv coi mọi thư mục trong versions/ là 1 phiên bản hợp lệ.
# Trên máy thật chỉ cần: pyenv install 3.12.7 && pyenv install 3.13.1
set -e
cd "$(dirname "$0")"
export PYENV_ROOT="$HOME/.pyenv"
[ -d "$PYENV_ROOT" ] || git clone -q --depth 1 https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

echo "== [1] pyenv version =="; pyenv --version

echo; echo "== [2] Số bản CPython có thể cài: =="; pyenv install --list | grep -cE '^\s+3\.[0-9]+\.[0-9]+$'
pyenv install --list | grep -E '^\s+3\.1[23]\.[0-9]+$' | tail -3

echo; echo "== [3] Đăng ký 2 phiên bản =="
P312=$(uv python find 3.12); P313=/usr/local
mkdir -p "$PYENV_ROOT/versions"
ln -sfn "$(dirname "$(dirname "$(readlink -f "$P312")")")" "$PYENV_ROOT/versions/3.12"
ln -sfn "$P313" "$PYENV_ROOT/versions/3.13"
pyenv rehash
pyenv versions

echo; echo "== [4] pyenv global 3.13 =="
pyenv global 3.13; python --version; echo "which python -> $(which python)  (đây là SHIM)"

echo; echo "== [5] pyenv local 3.12 trong thư mục project_old =="
rm -rf /tmp/project_old && mkdir /tmp/project_old && cd /tmp/project_old
pyenv local 3.12
echo ".python-version = $(cat .python-version)"
python --version
echo "pyenv which python -> $(pyenv which python)"

echo; echo "== [6] Ra khỏi thư mục -> quay về global =="
cd /tmp && python --version

echo; echo "== [7] Kết hợp pyenv + venv =="
cd /tmp/project_old && python -m venv .venv && .venv/bin/python --version

echo; echo "== [8] Nội dung 1 shim =="
head -20 "$PYENV_ROOT/shims/python"
