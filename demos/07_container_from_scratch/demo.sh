#!/usr/bin/env bash
# Chứng minh: container = process Linux bình thường + namespaces + chroot (+ cgroups)
# Không dùng Docker. Cần quyền root. Rootfs dùng lại /tmp/rootfs (xem 06_docker/build_base_image.sh)
set -e
R=/tmp/rootfs
[ -x $R/opt/python/bin/python3.12 ] || bash "$(dirname "$0")/../06_docker/build_base_image.sh"

echo "== [1] Nhìn từ HOST =="
echo "hostname          : $(hostname)"
echo "số process thấy   : $(ls /proc | grep -c '^[0-9]')"
echo "PID của shell này : $$"

echo; echo "== [2] Tạo 'container' bằng: unshare (uts+pid+mount+ipc+net namespace) + chroot =="
unshare --uts --pid --mount --ipc --net --fork bash -c "
  hostname my-container
  mount -t proc proc $R/proc 2>/dev/null || { mkdir -p $R/proc; mount -t proc proc $R/proc; }
  mkdir -p $R/dev; mount --rbind /dev $R/dev
  exec chroot $R /opt/python/bin/python3.12 -c '
import os, socket
print(\"hostname          :\", socket.gethostname())
print(\"PID của chính nó  :\", os.getpid())
print(\"process thấy được :\", [p for p in os.listdir(\"/proc\") if p.isdigit()])
print(\"thư mục gốc /     :\", sorted(os.listdir(\"/\")))
print(\"card mạng         :\", [l.split(\":\")[0].strip() for l in open(\"/proc/net/dev\").read().splitlines()[2:]])
'
"

echo; echo "== [3] Sau khi thoát, hostname của HOST không đổi: $(hostname) =="
