"""In ra thông tin môi trường Python đang chạy để chứng minh sự cô lập."""
import sys
import importlib.metadata as md

print(f"Python version : {sys.version.split()[0]}")
print(f"sys.executable : {sys.executable}")
print(f"sys.prefix     : {sys.prefix}")
print(f"base_prefix    : {sys.base_prefix}")
print(f"In a venv?     : {sys.prefix != sys.base_prefix}")
for pkg in ("requests", "six"):
    try:
        print(f"{pkg:<15}: {md.version(pkg)}")
    except md.PackageNotFoundError:
        print(f"{pkg:<15}: (not installed)")
