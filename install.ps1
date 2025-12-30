#################################################
# INSTALADOR PRINCIPAL DE DOTFILES
# Para Windows (PowerShell)
#################################################

#Requires -Version 5.1

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Colores para output
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Obtener directorio del script
$DOTFILES_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Info "Dotfiles directory: $DOTFILES_DIR"
Write-Host ""

#################################################
# BANNER
#################################################

Write-Host @"
╔══════════════════════════════════════════════════╗
║                                                  ║
║        🏠  DOTFILES INSTALLATION                 ║
║           Oscar's Dev Environment               ║
║                                                  ║
╚══════════════════════════════════════════════════╝
"@

Write-Host ""

#################################################
# MENÚ DE INSTALACIÓN
#################################################

Write-Info "Selecciona qué instalar:"
Write-Host ""
Write-Host "  1) Todo (Neovim + Yazi + dependencias)"
Write-Host "  2) Solo Neovim (completo con dependencias)"
Write-Host "  3) Solo Yazi (básico, sin plugins bash)"
Write-Host "  4) Neovim + Yazi (sin dependencias)"
Write-Host "  5) Salir"
Write-Host ""
$option = Read-Host "Opción [1-5]"

$INSTALL_NVIM = $false
$INSTALL_YAZI = $false

switch ($option) {
    "1" {
        Write-Info "Instalando todo..."
        $INSTALL_NVIM = $true
        $INSTALL_YAZI = $true
    }
    "2" {
        Write-Info "Instalando solo Neovim..."
        $INSTALL_NVIM = $true
    }
    "3" {
        Write-Info "Instalando solo Yazi..."
        $INSTALL_YAZI = $true
    }
    "4" {
        Write-Info "Instalando Neovim + Yazi (asumiendo dependencias ya instaladas)..."
        $INSTALL_NVIM = $true
        $INSTALL_YAZI = $true
    }
    "5" {
        Write-Info "Saliendo..."
        exit 0
    }
    default {
        Write-Error-Custom "Opción inválida"
        exit 1
    }
}

Write-Host ""

#################################################
# INSTALAR NEOVIM
#################################################

if ($INSTALL_NVIM) {
    Write-Info "Ejecutando instalador de Neovim..."
    Write-Host ""

    $nvimInstaller = Join-Path $DOTFILES_DIR "nvim\install.ps1"

    if (Test-Path $nvimInstaller) {
        Push-Location (Join-Path $DOTFILES_DIR "nvim")
        & $nvimInstaller
        Pop-Location
    }
    else {
        Write-Error-Custom "No se encontró nvim\install.ps1"
        exit 1
    }

    Write-Host ""
}

#################################################
# INSTALAR YAZI
#################################################

if ($INSTALL_YAZI) {
    Write-Info "Ejecutando instalador de Yazi..."
    Write-Host ""

    $yaziInstaller = Join-Path $DOTFILES_DIR "yazi\install.ps1"

    if (Test-Path $yaziInstaller) {
        Push-Location (Join-Path $DOTFILES_DIR "yazi")
        & $yaziInstaller
        Pop-Location
    }
    else {
        Write-Error-Custom "No se encontró yazi\install.ps1"
        exit 1
    }

    Write-Host ""
}


#################################################
# RESUMEN FINAL
#################################################

Write-Success "¡Instalación completada!"
Write-Host ""

if ($INSTALL_NVIM) {
    Write-Info "✓ Neovim instalado"
    Write-Host "  Configuración en: $env:LOCALAPPDATA\nvim"
    Write-Host "  Próximos pasos:"
    Write-Host "    - Ejecuta 'nvim' para abrir Neovim"
    Write-Host "    - Los plugins se instalarán automáticamente"
    Write-Host ""
}

if ($INSTALL_YAZI) {
    Write-Info "✓ Yazi instalado"
    Write-Host "  Configuración en: $env:APPDATA\yazi\config"
    Write-Host "  Próximos pasos:"
    Write-Host "    - Ejecuta 'yazi' para abrir el file manager"
    Write-Host "    - Usa '/' para buscar archivos (nativo)"
    Write-Host "    - Los plugins bash NO están disponibles en Windows"
    Write-Host ""
}

Write-Info "Para actualizar en el futuro:"
Write-Host "  cd $DOTFILES_DIR"
Write-Host "  git pull"
Write-Host "  .\install.ps1"
Write-Host ""

Write-Success "¡Todo listo! 🚀"
