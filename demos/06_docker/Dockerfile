# Dockerfile chuẩn - dùng trên máy cá nhân có Docker Desktop
# Build : docker build -t env-demo:1.0 .
# Run   : docker run -d -p 8000:8000 --name env-demo env-demo:1.0
FROM python:3.12-slim

WORKDIR /app

# Layer cài thư viện tách riêng để tận dụng cache khi chỉ sửa code
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

ENV PORT=8000 \
    GREETING="Hello from Docker container!"
EXPOSE 8000

CMD ["python", "app.py"]
