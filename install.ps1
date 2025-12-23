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
Write-Host "  1) Todo (Neovim + dependencias)"
Write-Host "  2) Solo Neovim (sin dependencias)"
Write-Host "  3) Solo dependencias (sin configuración)"
Write-Host "  4) Salir"
Write-Host ""
$option = Read-Host "Opción [1-4]"

$INSTALL_DEPS = $false
$INSTALL_NVIM = $false

switch ($option) {
    "1" {
        Write-Info "Instalando todo..."
        $INSTALL_DEPS = $true
        $INSTALL_NVIM = $true
    }
    "2" {
        Write-Info "Instalando solo configuración de Neovim..."
        $INSTALL_NVIM = $true
    }
    "3" {
        Write-Info "Instalando solo dependencias..."
        $INSTALL_DEPS = $true
    }
    "4" {
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
# INSTALAR DEPENDENCIAS
#################################################

if ($INSTALL_DEPS) {
    Write-Info "Ejecutando instalador de dependencias de Neovim..."
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
# CREAR SYMLINKS DE CONFIGURACIÓN
#################################################

if ($INSTALL_NVIM) {
    Write-Info "Creando symlinks de configuración..."
    Write-Host ""

    # Neovim
    $NVIM_CONFIG_DIR = "$env:LOCALAPPDATA\nvim"
    $NVIM_DOTFILES_DIR = Join-Path $DOTFILES_DIR "nvim"

    # Backup de configuración existente
    if ((Test-Path $NVIM_CONFIG_DIR) -and (-not (Get-Item $NVIM_CONFIG_DIR).LinkType)) {
        Write-Warning-Custom "Encontrada configuración existente de Neovim"
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $BACKUP_DIR = "$env:LOCALAPPDATA\nvim.backup.$timestamp"
        Write-Info "Creando backup en: $BACKUP_DIR"
        Move-Item $NVIM_CONFIG_DIR $BACKUP_DIR -Force
        Write-Success "Backup creado"
    }

    # Eliminar symlink existente
    if (Test-Path $NVIM_CONFIG_DIR) {
        if ((Get-Item $NVIM_CONFIG_DIR).LinkType -eq "SymbolicLink") {
            Write-Info "Eliminando symlink existente..."
            Remove-Item $NVIM_CONFIG_DIR -Force
        }
    }

    # Crear symlink (requiere permisos de administrador en algunas versiones de Windows)
    Write-Info "Creando symlink: $NVIM_CONFIG_DIR -> $NVIM_DOTFILES_DIR"

    try {
        New-Item -ItemType SymbolicLink -Path $NVIM_CONFIG_DIR -Target $NVIM_DOTFILES_DIR -Force | Out-Null
        Write-Success "Symlink de Neovim creado"
    }
    catch {
        Write-Warning-Custom "No se pudo crear symlink (puede requerir permisos de administrador)"
        Write-Info "Creando junction en su lugar..."
        cmd /c mklink /J "$NVIM_CONFIG_DIR" "$NVIM_DOTFILES_DIR"
        Write-Success "Junction de Neovim creada"
    }

    Write-Host ""
}

#################################################
# RESUMEN FINAL
#################################################

Write-Success "¡Instalación completada!"
Write-Host ""

if ($INSTALL_NVIM) {
    Write-Info "Configuración de Neovim instalada en:"
    Write-Host "  $env:LOCALAPPDATA\nvim -> $NVIM_DOTFILES_DIR"
    Write-Host ""
    Write-Info "Próximos pasos para Neovim:"
    Write-Host "  1. Abre Neovim: nvim"
    Write-Host "  2. Lazy.nvim instalará automáticamente los plugins"
    Write-Host "  3. Los LSP servers se instalarán vía Mason automáticamente"
    Write-Host ""
}

Write-Info "Para actualizar en el futuro:"
Write-Host "  cd $DOTFILES_DIR"
Write-Host "  git pull"
Write-Host "  .\install.ps1"
Write-Host ""

Write-Success "¡Todo listo! 🚀"
