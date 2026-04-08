$ErrorActionPreference = "Stop"

$proyecto = "C:\Repositorio\MURIC\biblioteca_sqlalchemy"
$venv = Join-Path $proyecto ".venv"
$pythonVenv = Join-Path $venv "Scripts\python.exe"

if (!(Test-Path $proyecto)) {
    throw "No existe la carpeta del proyecto: $proyecto"
}

Set-Location $proyecto

if (!(Test-Path $pythonVenv)) {
    python -m venv .venv
}

& $pythonVenv -m pip install --upgrade pip
& $pythonVenv -m pip install -r requirements.txt
& $pythonVenv -m pytest -q