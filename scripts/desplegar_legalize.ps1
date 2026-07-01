# Despliega Legalize (vicodingchile) en modo fullstack.
# Usa Docker Compose para construir e iniciar el contenedor,
# luego crea todos los agentes disponibles y activa todas las manos.

# 1) Inicia Docker Compose
Write-Host "Iniciando stack Docker..." -ForegroundColor Cyan
docker compose up --build -d
if ($LASTEXITCODE -ne 0) {
    Write-Error "Error al ejecutar docker compose up --build -d"
    exit 1
}

# 2) Espera unos segundos para que el servicio arranque
Write-Host "Esperando que el daemon se inicie..." -ForegroundColor Cyan
Start-Sleep -Seconds 8

# 3) Comprueba que el servicio responde en el contenedor
Write-Host "Verificando estado del servicio..." -ForegroundColor Cyan
$health = docker compose exec openfang bash -lc 'curl -sSf http://127.0.0.1:4200/api/health || true'
if (-not $health) {
    Write-Warning "No se pudo verificar el servicio en http://127.0.0.1:4200/api/health. Revisa los logs."
} else {
    Write-Host "Servicio activo." -ForegroundColor Green
}

# 4) Despliega todos los agentes del directorio de agentes copiado al contenedor
Write-Host "Spawn de todos los agentes disponibles..." -ForegroundColor Cyan
docker compose exec openfang bash -lc '
    find /opt/openfang/agents -type f -name agent.toml -print0 | while IFS= read -r -d "" manifest; do
        echo "Spawn: $manifest"
        openfang agent spawn "$manifest" || true
    done
'

# 5) Activa todas las manos disponibles
Write-Host "Activando todas las manos disponibles..." -ForegroundColor Cyan
docker compose exec openfang bash -lc '
    python3 - <<"PY"
import json, subprocess, sys
try:
    out = subprocess.check_output(["openfang", "hand", "list", "--json"], text=True)
    data = json.loads(out)
except Exception as e:
    print(f"Error al listar manos: {e}")
    sys.exit(1)

hands = data.get("hands") if isinstance(data, dict) else data
if not isinstance(hands, list):
    print("Formato inesperado al listar manos.")
    sys.exit(1)

for hand in hands:
    hid = hand.get("id")
    name = hand.get("name", "?")
    if hid:
        print(f"Activando mano: {name} ({hid})")
        subprocess.run(["openfang", "hand", "activate", hid], check=False)
PY
'

# 6) Verificación final
Write-Host "Verificando agentes y manos activas..." -ForegroundColor Cyan
docker compose exec openfang bash -lc 'openfang agent list'
docker compose exec openfang bash -lc 'openfang hand active'

Write-Host "Despliegue completo. Revisa los logs si fue necesario." -ForegroundColor Green

# 7) Abrir dashboard automáticamente
$dashboardUrl = 'http://localhost:4200'
try {
    Write-Host "Abriendo el dashboard en $dashboardUrl..." -ForegroundColor Cyan
    Start-Process $dashboardUrl
} catch {
    Write-Warning "No se pudo abrir el navegador automáticamente. Abre manualmente $dashboardUrl"
}
