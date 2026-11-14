#!/usr/bin/env bash
# Demo conda (Miniforge): tạo env có phiên bản Python riêng, cài package non-Python, export/import
set -e
cd "$(dirname "$0")"
HERE=$(pwd)
CONDA_DIR=/opt/miniforge
if [ ! -d "$CONDA_DIR" ]; then
  [ -f /tmp/mf.sh ] || curl -sSL -o /tmp/mf.sh https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
  bash /tmp/mf.sh -b -p "$CONDA_DIR" >/dev/null
fi
source "$CONDA_DIR/etc/profile.d/conda.sh"

echo "== [1] conda version =="; conda --version

echo; echo "== [2] Tạo env 'ai312' với Python 3.12 + numpy + ffmpeg (ffmpeg là binary C, không phải package Python) =="
conda create -y -q -n ai312 python=3.12 numpy ffmpeg >/dev/null
conda env list

echo; echo "== [3] Activate và kiểm tra =="
conda activate ai312
python --version
python -c "import sys, numpy; print('prefix:', sys.prefix); print('numpy', numpy.__version__)"
echo "ffmpeg: $(which ffmpeg)"; ffmpeg -version | head -1

echo; echo "== [4] Export environment.yml (--from-history: chỉ package đã yêu cầu) =="
conda env export --from-history | grep -v '^prefix' | tee "$HERE/environment.yml"
conda deactivate

echo; echo "== [5] Tạo lại env từ file (tái lập) =="
conda env create -y -q -n ai312_clone -f "$HERE/environment.yml" >/dev/null
conda run -n ai312_clone python -c "import numpy; print('clone numpy', numpy.__version__)"

echo; echo "== [6] Kích thước env (so với venv ~16MB) =="
du -sh "$CONDA_DIR/envs/ai312"

echo; echo "== [7] Dọn dẹp =="
conda env remove -y -q -n ai312_clone >/dev/null && conda env list
