#!/usr/bin/env bash
# Tạo base image tối thiểu từ con số 0 (không cần registry):
# rootfs = CPython 3.12 standalone + đúng các thư viện .so mà python cần (theo ldd)
set -e
R=/tmp/rootfs; rm -rf $R; mkdir -p $R/opt $R/tmp $R/etc
PY=$(dirname "$(dirname "$(readlink -f "$(uv python find 3.12)")")")
cp -a "$PY" $R/opt/python
for l in $(ldd $R/opt/python/bin/python3.12 | grep -o '/[^ ]*'); do
  mkdir -p "$R$(dirname "$l")"; cp -L "$l" "$R$l"
done
echo "root:x:0:0:root:/:/bin/sh" > $R/etc/passwd
du -sh $R
tar -C $R -c . | docker import - local/python-minimal:3.12
