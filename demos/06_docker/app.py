"""Web app tối giản (chỉ dùng thư viện chuẩn) để chạy trong container.
GET /  -> JSON thông tin môi trường bên trong container.
"""
import json, os, platform, socket, sys
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = int(os.environ.get("PORT", 8000))


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        body = json.dumps({
            "message": os.environ.get("GREETING", "Hello from Docker container!"),
            "hostname": socket.gethostname(),
            "pid": os.getpid(),
            "python": sys.version.split()[0],
            "kernel": platform.release(),
            "cwd": os.getcwd(),
            "files_in_root": sorted(os.listdir("/")),
        }, indent=2).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(body)


if __name__ == "__main__":
    print(f"Listening on 0.0.0.0:{PORT}", flush=True)
    HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
