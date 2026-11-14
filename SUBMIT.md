# Quy trình nộp bài lên GitHub (Windows PowerShell)

Repo đã có sẵn lịch sử commit (thư mục `.git`). Chỉ cần tạo repo trống trên GitHub rồi push.

## Bước 1 — Giải nén
Giải nén file zip vào `C:\dev\` → được thư mục `C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS`.

## Bước 2 — Cấu hình Git (nếu chưa làm)
```powershell
git config --global user.name  "Trieu Quoc Khanh"
git config --global user.email "<email tài khoản GitHub>"
```

## Bước 3 — Tạo repo trống trên GitHub
https://github.com/new → Repository name: `TrieuQuocKhanh-2A202603749-Env-Git-RDBMS` → Public → **KHÔNG** tick "Add a README" → **Create repository**.

## Bước 4 — Push
```powershell
cd C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS
git remote add origin https://github.com/qockhah253/TrieuQuocKhanh-2A202603749-Env-Git-RDBMS.git
git push -u origin main
```

## Bước 5 — Thêm ảnh chụp và push lần 2
```powershell
cd C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS
git add screenshots
git commit -m "docs: add screenshots from Windows machine"
git push
```

## Bước 6 — Nộp link
`https://github.com/qockhah253/TrieuQuocKhanh-2A202603749-Env-Git-RDBMS`
