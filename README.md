# Môi trường ảo, Máy ảo, Container · Python Env Managers · Git/GitHub · RDBMS & SQL

**Sinh viên:** Triệu Quốc Khánh — **MSSV:** 2A202603749
**Hạn nộp:** 11:00 15/11/2026

## Nội dung bài nộp

| # | Yêu cầu | Lý thuyết | Demo (code + output chạy thật) |
|---|---|---|---|
| 1a | Virtual environment, Virtual machine, Docker container | [docs/01-virtualization-theory.md](docs/01-virtualization-theory.md) | [01_venv](demos/01_venv) · [06_docker](demos/06_docker) · [07_container_from_scratch](demos/07_container_from_scratch) · [08_virtual_machine](demos/08_virtual_machine) |
| 1b | Python env managers: venv, virtualenv, uv, pyenv, conda | [docs/02-python-env-managers.md](docs/02-python-env-managers.md) | [01_venv](demos/01_venv) · [02_virtualenv](demos/02_virtualenv) · [03_uv](demos/03_uv) · [04_pyenv](demos/04_pyenv) · [05_conda](demos/05_conda) |
| 1c | Git, GitHub, nộp bài lên GitHub | [docs/03-git-github.md](docs/03-git-github.md) | Chính repo này + [SUBMIT.md](SUBMIT.md) |
| 2a | Cài RDBMS (MySQL, PostgreSQL) và dùng thử | [docs/04-rdbms-install.md](docs/04-rdbms-install.md) | [sql/](sql) — output: [PostgreSQL](sql/postgresql/output.txt), [MariaDB/MySQL](sql/mysql/output.txt) |
| 2b | Ngôn ngữ SQL | [docs/05-sql-basics.md](docs/05-sql-basics.md) | [sql/common/03_queries.sql](sql/common/03_queries.sql) (12 câu: SELECT → JOIN → GROUP BY → window → VIEW → TRANSACTION) |

## Cấu trúc repo

```
.
├── README.md
├── SUBMIT.md                     # các bước đẩy bài lên GitHub
├── docs/                         # lý thuyết (5 file)
├── demos/
│   ├── common/check_env.py       # script in thông tin môi trường, dùng chung cho mọi demo
│   ├── 01_venv/                  # demo.sh, demo.ps1 (Windows), output.txt
│   ├── 02_virtualenv/
│   ├── 03_uv/
│   ├── 04_pyenv/
│   ├── 05_conda/                 # + environment.yml
│   ├── 06_docker/                # Dockerfile, app.py, output.txt
│   ├── 07_container_from_scratch/# container tự dựng bằng Linux namespaces + chroot
│   └── 08_virtual_machine/       # Vagrantfile + hướng dẫn VirtualBox
├── sql/
│   ├── mysql/01_schema.sql       # DDL cho MySQL/MariaDB
│   ├── postgresql/01_schema.sql  # DDL cho PostgreSQL
│   ├── common/02_seed.sql        # dữ liệu mẫu
│   ├── common/03_queries.sql     # 12 câu truy vấn
│   └── docker-compose.yml        # chạy MySQL + Postgres bằng Docker
└── screenshots/                  # ảnh chụp trên máy Windows cá nhân
```

## Kết quả chính (trích từ output thật)

| Demo | Quan sát | Kết luận |
|---|---|---|
| venv | projectA `requests 2.31.0`, projectB `requests 2.32.3`, cùng Python 3.13.18; `sys.prefix` khác nhau | Cô lập thư viện, dùng chung interpreter |
| virtualenv vs venv | 0.25 s vs 2.02 s / env | virtualenv nhanh hơn ~8× nhờ cache seed |
| uv | `uv add` sinh `pyproject.toml` + `uv.lock`; cài pandas+requests+flask 0.05 s vs pip 1.48 s | Nhanh ~30×, tái lập bằng `uv sync` |
| pyenv | Cùng lệnh `python`: global → 3.13.18, trong thư mục có `.python-version` → 3.12.13 | Đổi phiên bản Python nhờ shims |
| conda | env `ai312` có Python 3.12.16 + numpy 2.5.4 + **ffmpeg 9.0.2** (binary C); 929 MB | Quản lý cả package không phải Python, nặng hơn venv ~58× |
| Docker | 2 container cùng image: hostname khác, đều là **PID 1**, kernel = kernel host; nhìn từ host là PID 2248; `--memory 128m --cpus 0.5` | Container = process cô lập, dùng chung kernel |
| Container tự dựng | `unshare` + `chroot`: hostname `my-container`, chỉ thấy PID 1, chỉ có card `lo` | Docker được xây trên namespaces + cgroups |
| SQL | 12 câu chạy trên PostgreSQL 16.15 và MariaDB 10.11.14; CHECK chặn điểm 11 | Cùng 1 bộ SQL chuẩn chạy được trên 2 RDBMS |

## Môi trường sinh output

| Thành phần | Phiên bản |
|---|---|
| OS chạy demo | Linux x86_64 (kernel 6.18), Python 3.13.18 |
| uv / pyenv / conda / virtualenv | 0.11.32 / 2.8.15 / 26.9.4 (Miniforge) / 21.15.6 |
| Docker Engine | 29.9.3 |
| PostgreSQL / MariaDB | 16.15 / 10.11.14 |

Ghi chú trung thực: môi trường chạy demo chặn Docker Hub và python.org, nên (1) base image Docker được tự dựng bằng `docker import` ([build_base_image.sh](demos/06_docker/build_base_image.sh), dùng `Dockerfile.offline`); `Dockerfile` chuẩn `FROM python:3.12-slim` dùng trên máy có mạng; (2) pyenv đăng ký interpreter có sẵn thay vì `pyenv install` từ source; (3) demo VM cần hypervisor nên chạy trên máy Windows theo [08_virtual_machine/README.md](demos/08_virtual_machine/README.md).

## Chạy lại các demo trên Windows

Xem [demos/README.md](demos/README.md).
