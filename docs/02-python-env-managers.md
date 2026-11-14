# 02. Python Environment Managers: venv, virtualenv, uv, pyenv, conda

## 1. Phân loại theo chức năng

Mỗi công cụ giải quyết một (hoặc nhiều) trong 3 việc:

| Chức năng | venv | virtualenv | pyenv | conda | uv |
|---|:---:|:---:|:---:|:---:|:---:|
| (A) Tạo môi trường cô lập thư viện | ✅ | ✅ | ❌ (cần plugin `pyenv-virtualenv`) | ✅ | ✅ |
| (B) Cài/đổi **phiên bản Python** | ❌ | ❌ | ✅ | ✅ | ✅ |
| (C) Cài package + giải phụ thuộc | (dùng pip) | (dùng pip) | ❌ | ✅ (conda) | ✅ (thay pip) |
| Cài được package **không phải Python** (CUDA, MKL, ffmpeg) | ❌ | ❌ | ❌ | ✅ | ❌ |
| Lock file tái lập chính xác | ❌ | ❌ | ❌ | (`conda-lock`) | ✅ `uv.lock` |
| Viết bằng | Python (stdlib) | Python | Bash (Windows: `pyenv-win`, PowerShell/VBS) | Python + C | Rust |
| Tốc độ | Trung bình | Nhanh hơn venv | — | Chậm (solver lớn) | Rất nhanh (10–100× pip) |

## 2. Chi tiết từng công cụ

### 2.1 `venv` (có sẵn trong Python ≥ 3.3)

| Mục | Nội dung |
|---|---|
| Cài đặt | Không cần, đi kèm Python |
| Tạo | `python -m venv .venv` |
| Kích hoạt (Windows PowerShell) | `.\.venv\Scripts\Activate.ps1` |
| Kích hoạt (Linux/macOS) | `source .venv/bin/activate` |
| Cài package | `pip install -r requirements.txt` |
| Xuất danh sách | `pip freeze > requirements.txt` |
| Thoát | `deactivate` |
| Xoá | Xoá thư mục `.venv` |

### 2.2 `virtualenv` (bản gốc, bên thứ 3, `venv` là bản rút gọn của nó)

| Mục | Nội dung |
|---|---|
| Cài đặt | `pip install virtualenv` |
| Tạo | `virtualenv .venv` hoặc chọn Python: `virtualenv -p python3.12 .venv` |
| Khác venv | Nhanh hơn (cache seed `pip/setuptools`), hỗ trợ cả Python cũ (2.7), có `-p` chọn interpreter, có API Python để mở rộng |
| Kích hoạt / thoát | Giống `venv` |

### 2.3 `pyenv` (quản lý **nhiều phiên bản Python**)

| Mục | Nội dung |
|---|---|
| Cài đặt Linux/macOS | `curl https://pyenv.run \| bash` (hoặc `brew install pyenv`) |
| Cài đặt Windows | `pyenv-win`: `Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"` |
| Xem bản có thể cài | `pyenv install --list` |
| Cài 1 bản | `pyenv install 3.12.7` |
| Đặt mặc định toàn máy | `pyenv global 3.12.7` |
| Đặt cho 1 thư mục | `pyenv local 3.11.9` → tạo file `.python-version` |
| Cơ chế | **Shims**: thư mục `~/.pyenv/shims` đứng đầu `PATH`, chứa file `python` giả; khi gọi `python`, shim đọc `.python-version` → chuyển tới đúng bản thật |
| Kết hợp | `pyenv local 3.12.7` rồi `python -m venv .venv` |

### 2.4 `conda` (Anaconda / Miniconda / Miniforge)

| Mục | Nội dung |
|---|---|
| Cài đặt | Miniconda installer từ https://docs.conda.io/en/latest/miniconda.html |
| Tạo env kèm phiên bản Python | `conda create -n ai312 python=3.12 -y` |
| Kích hoạt | `conda activate ai312` |
| Cài package | `conda install numpy pandas -y` (có thể `pip install` bên trong) |
| Xuất / tạo lại | `conda env export > environment.yml` / `conda env create -f environment.yml` |
| Liệt kê / xoá | `conda env list` / `conda env remove -n ai312` |
| Vị trí env | `<anaconda>/envs/<tên>` (tập trung, không nằm trong project) |
| Điểm mạnh | Cài cả thư viện C/C++/CUDA (`cudatoolkit`, `mkl`, `ffmpeg`) dạng binary sẵn → phổ biến trong Data Science/AI |
| Điểm yếu | Nặng (Anaconda ~3–5 GB), solver chậm, trộn `pip` + `conda` dễ hỏng env |

### 2.5 `uv` (Astral, 2024 — công cụ "tất cả trong một")

| Mục | Nội dung |
|---|---|
| Cài Windows | `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 \| iex"` |
| Cài Linux/macOS | `curl -LsSf https://astral.sh/uv/install.sh \| sh` (hoặc `pip install uv`) |
| Cài phiên bản Python (thay pyenv) | `uv python install 3.12` |
| Tạo venv (thay venv/virtualenv) | `uv venv --python 3.12` |
| Cài package (thay pip) | `uv pip install requests` |
| Quản lý project (thay pip-tools/poetry) | `uv init demo` → `uv add requests` → sinh `pyproject.toml` + `uv.lock` |
| Chạy | `uv run main.py` (tự tạo/đồng bộ `.venv`) |
| Tái lập | `uv sync` (cài đúng theo `uv.lock`) |
| Chạy tool tạm | `uvx ruff check .` |
| Điểm mạnh | Viết bằng Rust, cache toàn cục + hard-link → cực nhanh; 1 binary thay 5 công cụ |

## 3. Chọn công cụ nào?

| Tình huống | Khuyến nghị |
|---|---|
| Project Python mới, cá nhân hoặc nhóm | **uv** (`uv init`, `uv add`, commit `uv.lock`) |
| Máy không cài thêm được gì | `venv` |
| Cần chạy nhiều bản Python song song (3.10 / 3.12 / 3.13) | `uv python install` hoặc `pyenv` |
| Cần CUDA/MKL/GDAL/thư viện C khó build, Data Science | `conda` (Miniforge) |
| Hỗ trợ Python 2.7 / dự án cũ | `virtualenv` |

## 4. Kết quả benchmark tự đo (demo trong repo)

| Phép đo (Linux, Python 3.13) | Kết quả | Nguồn |
|---|---|---|
| Tạo 1 env bằng `venv` | 2.02 s | [demos/02_virtualenv/output.txt](../demos/02_virtualenv/output.txt) |
| Tạo 1 env bằng `virtualenv` | 0.25 s | như trên |
| Cài pandas + requests + flask bằng `pip` | 1.48 s | [demos/03_uv/output.txt](../demos/03_uv/output.txt) |
| Cài cùng bộ đó bằng `uv pip` (cache ấm) | 0.05 s (~30×) | như trên |
| Kích thước venv có `requests` | 16 MB | [demos/01_venv/output.txt](../demos/01_venv/output.txt) |
| Kích thước conda env `python=3.12 numpy ffmpeg` | 929 MB | [demos/05_conda/output.txt](../demos/05_conda/output.txt) |

## 5. Tài liệu tham khảo
- https://docs.python.org/3/library/venv.html
- https://virtualenv.pypa.io/
- https://github.com/pyenv/pyenv , https://github.com/pyenv-win/pyenv-win
- https://docs.conda.io/
- https://docs.astral.sh/uv/
