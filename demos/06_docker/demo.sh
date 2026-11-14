#!/usr/bin/env bash
# Demo Docker: build image, run container, port mapping, env var, isolation, layers, cleanup
set -e
cd "$(dirname "$0")"
DOCKERFILE=${DOCKERFILE:-Dockerfile}          # trên máy thật: Dockerfile ; offline: Dockerfile.offline

echo "== [1] docker version =="; docker version --format 'Client {{.Client.Version}} / Server {{.Server.Version}}'

echo; echo "== [2] Build image env-demo:1.0 từ $DOCKERFILE =="
docker build -q -f "$DOCKERFILE" -t env-demo:1.0 .
docker images env-demo

echo; echo "== [3] Lịch sử layer của image =="
docker history --format 'table {{.CreatedBy}}\t{{.Size}}' env-demo:1.0 | cut -c1-90

echo; echo "== [4] Chạy 2 container từ CÙNG 1 image, khác port + biến môi trường =="
docker rm -f c1 c2 >/dev/null 2>&1 || true
docker run -d --name c1 -p 8001:8000 env-demo:1.0 >/dev/null
docker run -d --name c2 -p 8002:8000 -e GREETING="Xin chao tu container 2" --memory 128m --cpus 0.5 env-demo:1.0 >/dev/null
sleep 2
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}'

echo; echo "== [5] Gọi API trong từng container (chú ý hostname khác nhau, pid = 1) =="
IP1=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' c1)
IP2=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' c2)
echo "--- c1 ($IP1) ---"; curl -s --noproxy '*' "http://$IP1:8000/"
echo; echo "--- c2 ($IP2) ---"; curl -s --noproxy '*' "http://$IP2:8000/"

echo; echo; echo "Kernel của HOST: $(uname -r)  -> giống kernel trong container (dùng chung kernel)"
echo; echo "== [6] Từ host: container chỉ là 1 process bình thường =="
docker top c1 -o pid,user,cmd
echo "PID của c1 nhìn từ host: $(docker inspect -f '{{.State.Pid}}' c1)  (bên trong container nó là PID 1)"

echo; echo "== [7] Giới hạn tài nguyên (cgroups) của c2 =="
docker inspect -f 'Memory={{.HostConfig.Memory}} bytes, NanoCpus={{.HostConfig.NanoCpus}}' c2

echo; echo "== [8] Logs =="; docker logs c1

echo; echo "== [9] Dọn dẹp =="
docker rm -f c1 c2
