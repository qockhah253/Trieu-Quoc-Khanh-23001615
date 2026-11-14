# Demo venv trên Windows PowerShell
# Chạy: powershell -ExecutionPolicy Bypass -File C:\dev\TrieuQuocKhanh-2A202603749-Env-Git-RDBMS\demos\01_venv\demo.ps1
$ErrorActionPreference = "Stop"
$Here   = Split-Path -Parent $MyInvocation.MyCommand.Path
$Check  = Join-Path $Here "..\common\check_env.py"
$Root   = "C:\dev\venv_demo"
$Python = "C:\Users\AD\AppData\Local\Programs\Python\Python313\python.exe"

if (Test-Path $Root) { Remove-Item -Recurse -Force $Root }
New-Item -ItemType Directory -Force "$Root\projectA", "$Root\projectB" | Out-Null

Write-Host "== [0] Python toan cuc ==";     & $Python $Check
Write-Host "== [1] Tao 2 venv ==";
& $Python -m venv "$Root\projectA\.venv"
& $Python -m venv "$Root\projectB\.venv"
Get-Content "$Root\projectA\.venv\pyvenv.cfg"

Write-Host "== [2] Cai 2 phien ban requests ==";
& "$Root\projectA\.venv\Scripts\python.exe" -m pip install -q "requests==2.31.0"
& "$Root\projectB\.venv\Scripts\python.exe" -m pip install -q "requests==2.32.3"

Write-Host "== [3] projectA (activate) ==";
& "$Root\projectA\.venv\Scripts\Activate.ps1"
(Get-Command python).Source
python $Check
pip freeze | Out-File -Encoding utf8 "$Root\projectA\requirements.txt"
deactivate

Write-Host "== [4] projectB (goi thang duong dan) ==";
& "$Root\projectB\.venv\Scripts\python.exe" $Check
