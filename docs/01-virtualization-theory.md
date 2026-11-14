# 01. Virtual Environment vs Virtual Machine vs Container

## 1. Bài toán chung: "Cô lập môi trường" (Isolation)

| Vấn đề | Ví dụ thực tế |
|---|---|
| Xung đột phiên bản thư viện | Project A cần `numpy==1.26`, project B cần `numpy==2.1` |
| Xung đột phiên bản ngôn ngữ | `mediapipe` cũ chỉ chạy Python 3.12, máy mặc định 3.13 |
| "Chạy trên máy tôi được mà" | Khác OS, khác thư viện hệ thống (libGL, CUDA, glibc) |
| Cần OS khác hẳn | Đang dùng Windows nhưng cần test trên Ubuntu |

Ba công nghệ giải quyết bài toán trên ở **3 tầng cô lập khác nhau**:

```
Tầng cô lập (thấp → cao)
┌───────────────────────────────────────────────────────────────────┐
│ Virtual Environment │ chỉ cô lập: thư viện Python (site-packages)  │
│ Container           │ cô lập: filesystem, process, network, user   │
│                     │ (dùng chung kernel với host)                 │
│ Virtual Machine     │ cô lập: toàn bộ OS + kernel + phần cứng ảo   │
└───────────────────────────────────────────────────────────────────┘
```

---

## 2. Virtual Environment (môi trường ảo Python)

### 2.1 Định nghĩa
Một **thư mục** chứa: (1) bản trỏ/copy của trình thông dịch Python, (2) thư mục `site-packages` riêng, (3) script `activate` để đổi `PATH`.

### 2.2 Cơ chế hoạt động

| Bước | Cơ chế |
|---|---|
| 1. Tạo | `python -m venv .venv` sinh ra `.venv/pyvenv.cfg`, `.venv/Scripts/python.exe` (Windows) hoặc `.venv/bin/python` (Linux) |
| 2. Python khởi động | Python đọc `pyvenv.cfg` nằm cạnh file thực thi → đặt `sys.prefix` = thư mục venv |
| 3. Tìm thư viện | `sys.path` trỏ vào `.venv/Lib/site-packages` thay vì site-packages toàn cục |
| 4. Activate | Chỉ là đưa `.venv/Scripts` lên đầu biến `PATH` + đổi prompt. **Không activate vẫn dùng được** bằng cách gọi thẳng `.venv/Scripts/python.exe` |

```
Host OS (Windows)
└── Python 3.13 (cài 1 lần)
    ├── project-A/.venv  → numpy 1.26, opencv 4.9
    └── project-B/.venv  → numpy 2.1,  torch 2.5
```

### 2.3 Ưu / nhược

| Ưu | Nhược |
|---|---|
| Rất nhẹ (vài MB đến vài trăm MB), tạo trong < 5 giây | Chỉ cô lập thư viện Python, **không** cô lập OS, thư viện C hệ thống |
| Không cần quyền admin | Không đổi được phiên bản Python (cần pyenv/conda/uv) |
| Có sẵn trong Python ≥ 3.3 (`venv`) | Không mang sang máy khác được (đường dẫn hard-code) → phải dùng `requirements.txt` |

---

## 3. Virtual Machine (máy ảo)

### 3.1 Định nghĩa
Phần mềm **Hypervisor** giả lập một máy tính hoàn chỉnh (CPU, RAM, ổ đĩa, card mạng). Trên đó cài **một hệ điều hành khách (Guest OS) đầy đủ, có kernel riêng**.

### 3.2 Hai loại Hypervisor

| Loại | Chạy ở đâu | Ví dụ | Dùng khi |
|---|---|---|---|
| Type 1 (bare-metal) | Trực tiếp trên phần cứng | VMware ESXi, Microsoft Hyper-V, KVM, Xen | Server, data center, cloud (AWS EC2) |
| Type 2 (hosted) | Là 1 ứng dụng trên Host OS | VirtualBox, VMware Workstation, Parallels | Máy cá nhân, học tập, test |

### 3.3 Kiến trúc

```
┌──────────────┐ ┌──────────────┐
│ App A        │ │ App B        │
│ Bins/Libs    │ │ Bins/Libs    │
│ Guest OS     │ │ Guest OS     │   ← mỗi VM có kernel riêng (vài GB)
│ (Ubuntu)     │ │ (Windows)    │
└──────────────┘ └──────────────┘
┌────────────────────────────────┐
│ Hypervisor (VirtualBox/Hyper-V)│   ← giả lập phần cứng
├────────────────────────────────┤
│ Host OS (Windows 11)           │
├────────────────────────────────┤
│ Phần cứng (CPU có VT-x/AMD-V)  │
└────────────────────────────────┘
```

### 3.4 Ưu / nhược

| Ưu | Nhược |
|---|---|
| Cô lập mạnh nhất (kernel riêng) → an toàn | Nặng: mỗi VM vài GB disk, 1–4 GB RAM |
| Chạy được OS khác hẳn host (Linux trên Windows) | Khởi động chậm (30 s – vài phút) |
| Snapshot/rollback toàn bộ máy | Overhead hiệu năng (CPU, I/O) |

---

## 4. Container (Docker)

### 4.1 Định nghĩa
Một **tiến trình (process) bình thường** của Host, nhưng bị kernel Linux "bịt mắt" và "giới hạn tài nguyên" để nó tưởng mình đang chạy một mình trong một máy riêng.

### 4.2 Hai cơ chế kernel tạo nên container

| Cơ chế | Vai trò | Các loại |
|---|---|---|
| **Namespaces** | Cô lập "cái process **nhìn thấy**" | `pid` (chỉ thấy process của mình, bản thân là PID 1), `mnt` (filesystem riêng), `net` (card mạng riêng), `uts` (hostname riêng), `ipc`, `user` |
| **cgroups** (control groups) | Giới hạn "process được **dùng** bao nhiêu" | CPU, RAM, I/O, số process |
| + Union filesystem (OverlayFS) | Image xếp lớp (layer), chỉ đọc; container thêm 1 lớp ghi | |

→ Demo chứng minh "container = process + namespaces": [demos/07_container_from_scratch](../demos/07_container_from_scratch/).

### 4.3 Khái niệm Docker

| Khái niệm | Giải thích | Tương tự OOP |
|---|---|---|
| **Dockerfile** | File text mô tả cách build image (FROM, RUN, COPY, CMD) | Mã nguồn class |
| **Image** | Gói chỉ-đọc gồm filesystem + metadata, xếp lớp | Class |
| **Container** | Một instance đang chạy của image | Object |
| **Registry** | Kho lưu image (Docker Hub, GHCR) | Package repo (PyPI) |
| **Volume** | Thư mục lưu dữ liệu bền vững ngoài container | — |
| **Docker Compose** | File YAML chạy nhiều container cùng lúc (app + DB) | — |

### 4.4 Docker trên Windows
Container dùng kernel **Linux** → trên Windows, Docker Desktop chạy một **VM Linux nhẹ qua WSL 2** (Hyper-V). Tức là: `Windows → WSL2 VM (Linux kernel) → các container`.

### 4.5 Kiến trúc

```
┌─────────┐ ┌─────────┐ ┌─────────┐
│ App A   │ │ App B   │ │ App C   │
│ Libs    │ │ Libs    │ │ Libs    │   ← không có kernel riêng (MB)
└─────────┘ └─────────┘ └─────────┘
┌───────────────────────────────────┐
│ Container runtime (Docker Engine) │
├───────────────────────────────────┤
│ Host OS — kernel Linux (dùng chung)│
├───────────────────────────────────┤
│ Phần cứng                         │
└───────────────────────────────────┘
```

---

## 5. Bảng so sánh tổng hợp

| Tiêu chí | Virtual Environment | Container (Docker) | Virtual Machine |
|---|---|---|---|
| Cô lập cái gì | Thư viện Python | Filesystem, process, network, user | Toàn bộ OS + kernel |
| Kernel | Dùng chung host | **Dùng chung** host | **Riêng** |
| Kích thước điển hình | 10–500 MB | 50 MB – 2 GB (image) | 5–50 GB |
| Thời gian khởi động | Tức thì | < 1 giây | 30 giây – vài phút |
| Overhead hiệu năng | ~0 | ~0–5 % | 5–20 % |
| Đổi phiên bản Python | Không (trừ uv/conda) | Có (`FROM python:3.12`) | Có |
| Chạy OS khác | Không | Chỉ cùng loại kernel (Linux) | Có (bất kỳ) |
| Tính di động (portable) | Thấp (cần `requirements.txt`) | Cao (image chạy mọi nơi có Docker) | Trung bình (file .ova/.vmdk lớn) |
| Mức an toàn | Thấp | Trung bình | Cao |
| Công cụ | venv, virtualenv, uv, conda | Docker, Podman, containerd | VirtualBox, VMware, Hyper-V, KVM |
| Dùng khi | Dev hằng ngày từng project Python | Deploy, CI/CD, đóng gói app + DB | Cần OS khác, cô lập bảo mật, lab mạng |

## 6. Kết hợp trong thực tế

| Kịch bản | Cách dùng |
|---|---|
| Code AI trên laptop | `uv`/`venv` cho từng project |
| Deploy API model lên server | Docker image `python:3.12-slim` + `requirements.txt` |
| Cloud (AWS/GCP) | VM (EC2) → bên trong chạy Docker → bên trong container có thể vẫn dùng venv |
| Docker Desktop trên Windows | Windows → VM WSL2 → container |

## 7. Tài liệu tham khảo
- Python docs – `venv`: https://docs.python.org/3/library/venv.html
- Docker docs – What is a container: https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-container/
- Linux man page – `namespaces(7)`, `cgroups(7)`
- VirtualBox manual: https://www.virtualbox.org/manual/
