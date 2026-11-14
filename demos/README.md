# Chạy lại demo trên Windows (PowerShell)

Giả định repo ở `C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS`. Mỗi demo chạy xong → chụp màn hình lưu vào `C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS\screenshots\`.

| Demo | Cài đặt (1 lần) | Lệnh chạy | Ảnh chụp |
|---|---|---|---|
| 01 venv | — | `powershell -ExecutionPolicy Bypass -File C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS\demos\01_venv\demo.ps1` | `01_venv.png` |
| 02 virtualenv | `C:\Users\AD\AppData\Local\Programs\Python\Python313\python.exe -m pip install virtualenv` | `C:\Users\AD\AppData\Local\Programs\Python\Python313\python.exe -m virtualenv -p 3.12 C:\dev\ve_demo` rồi `C:\dev\ve_demo\Scripts\python.exe C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS\demos\common\check_env.py` | `02_virtualenv.png` |
| 03 uv | `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 \| iex"` | `cd C:\dev; uv init uv_demo; cd C:\dev\uv_demo; uv add requests; uv run python C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS\demos\common\check_env.py` | `03_uv.png` |
| 04 pyenv | pyenv-win (xem docs/02, mục 2.3) | `pyenv install 3.11.9; pyenv versions; cd C:\dev\uv_demo; pyenv local 3.11.9; python --version` | `04_pyenv.png` |
| 05 conda | Đã có Anaconda tại `C:\Users\AD\anaconda3` | Mở **Anaconda Prompt**: `conda env create -f C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS\demos\05_conda\environment.yml` → `conda activate ai312` → `python --version` → `ffmpeg -version` | `05_conda.png` |
| 06 docker | Docker Desktop: `winget install -e --id Docker.DockerDesktop` (bật WSL 2) | `cd C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS\demos\06_docker; docker build -t env-demo:1.0 .; docker run -d -p 8001:8000 --name c1 env-demo:1.0` → mở `http://localhost:8001` | `06_docker.png` |
| 07 container tự dựng | Cần Linux + root (WSL 2 Ubuntu) | Trong WSL: `sudo bash /mnt/c/dev/TrieuQuocKhanh-2A202603749-Env-Git-RDBMS/demos/07_container_from_scratch/demo.sh` (cần `uv` trong WSL) | (tuỳ chọn) |
| 08 VM | VirtualBox + Vagrant | Xem `C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS\demos\08_virtual_machine\README.md` | `08_vm.png` |

Trên Linux/macOS/WSL: chạy `bash demos/<thư-mục>/demo.sh` (output mẫu đã lưu ở `output.txt` từng thư mục).
