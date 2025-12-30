#################################################
# INSTALADOR AUTOMÁTICO DE YAZI
# Para Windows 10/11
#################################################

# Requiere ejecutar como administrador para algunas instalaciones
# O usar winget que maneja permisos automáticamente

# Colores para output
function Write-Info { Write-Host "[INFO] $args" -ForegroundColor Blue }
function Write-Success { Write-Host "[OK] $args" -ForegroundColor Green }
function Write-Warning { Write-Host "[WARN] $args" -ForegroundColor Yellow }
function Write-Error { Write-Host "[ERROR] $args" -ForegroundColor Red }

# Banner
Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║  Instalador de Yazi                    ║" -ForegroundColor Blue
Write-Host "║  Sistema: Windows                      ║" -ForegroundColor Blue
Write-Host "║  (Versión básica sin plugins bash)     ║" -ForegroundColor Blue
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""

#################################################
# 1. VERIFICAR WINGET
#################################################

Write-Info "Verificando winget..."

if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Success "winget está disponible"
} else {
    Write-Error "winget no está instalado"
    Write-Info "Por favor instala winget (Windows Package Manager) desde:"
    Write-Info "https://aka.ms/getwinget"
    exit 1
}

#################################################
# 2. INSTALAR YAZI
#################################################

Write-Info "Verificando Yazi..."

if (Get-Command yazi -ErrorAction SilentlyContinue) {
    $yaziVersion = (yazi --version) -split '\n' | Select-Object -First 1
    Write-Success "Yazi ya está instalado ($yaziVersion)"
} else {
    Write-Info "Instalando Yazi via winget..."

    try {
        winget install --id sxyazi.yazi --accept-source-agreements --accept-package-agreements
        Write-Success "Yazi instalado correctamente"
    } catch {
        Write-Error "Error al instalar Yazi: $_"
        exit 1
    }
}

#################################################
# 3. COPIAR CONFIGURACIONES
#################################################

Write-Info "Copiando configuraciones de Yazi..."

# Crear directorio de configuración de Yazi en Windows
$yaziConfigDir = "$env:APPDATA\yazi\config"
New-Item -ItemType Directory -Force -Path $yaziConfigDir | Out-Null

# Obtener directorio del script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Copiar configuración común
Copy-Item "$scriptDir\yazi.toml" "$yaziConfigDir\yazi.toml" -Force
Write-Success "yazi.toml copiado"

# Copiar keymap para Windows (sin plugins bash)
Copy-Item "$scriptDir\keymap-windows.toml" "$yaziConfigDir\keymap.toml" -Force
Write-Success "keymap.toml copiado (versión Windows sin plugins bash)"

Write-Warning "Los plugins bash (zf, zg) NO están disponibles en Windows"
Write-Info "Usa los atajos nativos de Yazi:"
Write-Host "  /   - Buscar archivos por nombre" -ForegroundColor Cyan
Write-Host "  f   - Filtrar directorio actual" -ForegroundColor Cyan
Write-Host "  ?   - Mostrar ayuda" -ForegroundColor Cyan

#################################################
# 4. INFORMACIÓN ADICIONAL
#################################################

Write-Host ""
Write-Info "NOTA: Para usar los plugins avanzados en Windows:"
Write-Info "1. Instala WSL2 (Windows Subsystem for Linux)"
Write-Info "2. Instala Yazi en WSL usando install.sh"
Write-Info "3. Ejecuta Yazi desde el terminal de WSL"
Write-Host ""

#################################################
# VERIFICACIÓN FINAL
#################################################

Write-Host ""
Write-Info "Verificando instalación..."

if (Get-Command yazi -ErrorAction SilentlyContinue) {
    $yaziVersion = (yazi --version) -split '\n' | Select-Object -First 1
    Write-Host "  ✓ yazi: $yaziVersion" -ForegroundColor Green
} else {
    Write-Warning "yazi no se encuentra en PATH"
    Write-Info "Reinicia tu terminal e intenta nuevamente"
}

#################################################
# FINALIZACIÓN
#################################################

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✓ Instalación completada             ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Info "Yazi está listo para usar!"
Write-Host ""
Write-Info "Atajos de teclado dentro de Yazi:"
Write-Host "  /   - Buscar archivos por nombre (nativo)" -ForegroundColor Cyan
Write-Host "  f   - Filtrar directorio actual (nativo)" -ForegroundColor Cyan
Write-Host "  F   - Filtro inteligente" -ForegroundColor Cyan
Write-Host "  ?   - Ayuda completa" -ForegroundColor Cyan
Write-Host ""
Write-Info "Ejecuta 'yazi' para comenzar"
Write-Host ""
Write-Warning "RECORDATORIO: Los plugins bash (zf, zg) solo funcionan en Linux/WSL"
Write-Host ""
