# 03. Git & GitHub

## 1. Khái niệm

| Khái niệm | Giải thích |
|---|---|
| **Git** | Hệ thống quản lý phiên bản **phân tán** (DVCS), chạy trên máy cá nhân, do Linus Torvalds viết năm 2005 |
| **GitHub** | Dịch vụ web lưu trữ repository Git từ xa + công cụ cộng tác (Pull Request, Issues, Actions) |
| Repository (repo) | Thư mục dự án + thư mục ẩn `.git` chứa toàn bộ lịch sử |
| Commit | Một "ảnh chụp" (snapshot) trạng thái các file, có mã hash SHA-1, tác giả, thời gian, message |
| Branch | Con trỏ di động trỏ tới 1 commit; nhánh mặc định: `main` |
| HEAD | Con trỏ cho biết đang đứng ở commit/branch nào |
| Remote | Bản repo ở nơi khác (vd. `origin` = GitHub) |
| `.gitignore` | Danh sách file KHÔNG theo dõi (`.venv/`, `__pycache__/`, `.env`) |

## 2. Ba vùng làm việc

```
Working Directory  --git add-->  Staging Area (Index)  --git commit-->  Local Repo (.git)  --git push-->  Remote (GitHub)
        ^                                                                     |                              |
        +------------------------- git checkout / restore -------------------+<-------- git pull/fetch ----+
```

## 3. Lệnh cơ bản

| Nhóm | Lệnh | Tác dụng |
|---|---|---|
| Cấu hình (1 lần) | `git config --global user.name "Trieu Quoc Khanh"` | Tên tác giả |
| | `git config --global user.email "<email GitHub>"` | Email tác giả |
| Khởi tạo | `git init` | Tạo repo mới |
| | `git clone <url>` | Tải repo về |
| Theo dõi | `git status` | Xem trạng thái |
| | `git add <file>` / `git add .` | Đưa vào staging |
| | `git commit -m "message"` | Tạo commit |
| | `git log --oneline --graph` | Xem lịch sử |
| | `git diff` | Xem thay đổi chưa stage |
| Nhánh | `git switch -c feature/x` | Tạo + chuyển nhánh |
| | `git merge feature/x` | Gộp nhánh |
| Remote | `git remote add origin <url>` | Gắn remote |
| | `git push -u origin main` | Đẩy lên |
| | `git pull` | Kéo về + merge |
| Hoàn tác | `git restore <file>` | Bỏ thay đổi chưa stage |
| | `git revert <hash>` | Tạo commit đảo ngược (an toàn) |

## 4. Quy ước commit message (Conventional Commits)

| Tiền tố | Dùng khi | Ví dụ |
|---|---|---|
| `feat:` | Thêm tính năng/nội dung | `feat: add uv demo` |
| `docs:` | Tài liệu | `docs: add theory of VM vs container` |
| `fix:` | Sửa lỗi | `fix: wrong activate path on Windows` |
| `chore:` | Việc vặt (gitignore, cấu hình) | `chore: add .gitignore` |

## 5. Quy trình nộp bài lên GitHub
Xem [SUBMIT.md](../SUBMIT.md).

## 6. Lịch sử commit của chính repo này
Chạy `git log --oneline --graph --all` trong thư mục repo — repo được tạo theo đúng quy trình: nhánh `main`, nhánh `feature/sql` rồi merge.
