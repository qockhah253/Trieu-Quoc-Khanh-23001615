# Demo 08 — Virtual Machine (VirtualBox + Vagrant) trên Windows

> Không chạy được trong môi trường Linux sinh output (không có `/dev/kvm`, không có hypervisor) → demo này **chạy trên máy Windows cá nhân**. Chụp màn hình các bước vào `C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS\screenshots\`.

## Bước 1 — Cài đặt

| # | Lệnh PowerShell (Admin) | Kết quả mong đợi |
|---|---|---|
| 1 | `winget install -e --id Oracle.VirtualBox` | VirtualBox 7.x |
| 2 | `winget install -e --id Hashicorp.Vagrant` | Vagrant 2.4.x |
| 3 | Đóng/mở lại PowerShell, chạy `vagrant --version` | `Vagrant 2.4.x` |

> Nếu đã bật Hyper-V/WSL2 (Docker Desktop), VirtualBox 7 vẫn chạy được nhưng chậm hơn. Thay thế: dùng provider `hyperv` (`vagrant up --provider=hyperv`, chạy PowerShell Admin).

## Bước 2 — Tạo và khởi động VM

| # | Lệnh | Đầu ra cần chụp |
|---|---|---|
| 1 | `cd C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS\demos\08_virtual_machine` | — |
| 2 | `vagrant up` (lần đầu tải box ~1 GB) | Dòng `Guest kernel` in ra kernel Ubuntu (khác Windows) |
| 3 | `vagrant ssh -c "uname -a; hostname; free -h"` | hostname `khanh-vm`, RAM ~2 GB |
| 4 | Mở trình duyệt `http://localhost:8080` | JSON có `"kernel": "6.8.x-generic"` |
| 5 | Mở VirtualBox GUI | Thấy VM `env-demo-vm` đang Running |

## Bước 3 — Snapshot & dọn dẹp

| # | Lệnh | Ý nghĩa |
|---|---|---|
| 1 | `vagrant snapshot save clean` | Chụp toàn bộ trạng thái máy |
| 2 | `vagrant snapshot restore clean` | Quay về trạng thái cũ |
| 3 | `vagrant halt` | Tắt VM |
| 4 | `vagrant destroy -f` | Xoá VM (giải phóng vài GB) |

## So sánh quan sát được (điền sau khi chạy)

| Tiêu chí | VM (Vagrant) | Container (Docker) |
|---|---|---|
| Thời gian khởi động | ____ s | < 1 s |
| Dung lượng | ____ GB | ~150 MB |
| `uname -r` | kernel Ubuntu riêng | giống kernel host (WSL2) |
