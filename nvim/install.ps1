#################################################
# INSTALADOR AUTOMÁTICO DE NEOVIM Y DEPENDENCIAS
# Para Windows (PowerShell)
#################################################

# Requerir permisos de administrador para algunas instalaciones
#Requires -Version 5.1

# Configurar strict mode
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

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Función para verificar si un comando existe
function Test-Command {
    param([string]$Command)
    try {
        if (Get-Command $Command -ErrorAction Stop) {
            return $true
        }
    }
    catch {
        return $false
    }
    return $false
}

#################################################
# 1. VERIFICAR WINGET (Windows Package Manager)
#################################################

Write-Info "Verificando winget..."

if (-not (Test-Command "winget")) {
    Write-Error-Custom "winget no está instalado. Por favor instala Windows Package Manager desde:"
    Write-Host "https://aka.ms/getwinget" -ForegroundColor Yellow
    exit 1
}

Write-Success "winget está disponible"

#################################################
# 2. INSTALAR NEOVIM
#################################################

Write-Info "Verificando Neovim..."

if (Test-Command "nvim") {
    Write-Success "Neovim ya está instalado"
} else {
    Write-Info "Instalando Neovim..."
    try {
        winget install --id=Neovim.Neovim -e --source winget
        Write-Success "Neovim instalado correctamente"
    }
    catch {
        Write-Error-Custom "Error instalando Neovim: $_"
        exit 1
    }
}

#################################################
# 3. INSTALAR GIT
#################################################

Write-Info "Verificando Git..."

if (Test-Command "git") {
    Write-Success "Git ya está instalado"
} else {
    Write-Info "Instalando Git..."
    try {
        winget install --id=Git.Git -e --source winget
        Write-Success "Git instalado correctamente"
    }
    catch {
        Write-Error-Custom "Error instalando Git: $_"
        exit 1
    }
}

#################################################
# 4. INSTALAR NODE.JS (para LSP servers)
#################################################

Write-Info "Verificando Node.js..."

if (Test-Command "node") {
    Write-Success "Node.js ya está instalado ($(node --version))"
} else {
    Write-Info "Instalando Node.js..."
    try {
        winget install --id=OpenJS.NodeJS.LTS -e --source winget
        Write-Success "Node.js instalado correctamente"
        Write-Warning "Puede que necesites reiniciar PowerShell para que node esté en el PATH"
    }
    catch {
        Write-Error-Custom "Error instalando Node.js: $_"
        exit 1
    }
}

#################################################
# 5. INSTALAR PYTHON (para algunos plugins)
#################################################

Write-Info "Verificando Python..."

if (Test-Command "python") {
    Write-Success "Python ya está instalado ($(python --version))"
} else {
    Write-Info "Instalando Python..."
    try {
        winget install --id=Python.Python.3.12 -e --source winget
        Write-Success "Python instalado correctamente"
    }
    catch {
        Write-Warning "Error instalando Python (opcional): $_"
    }
}

#################################################
# 6. INSTALAR HERRAMIENTAS CLI
#################################################

Write-Info "Instalando herramientas CLI..."

# ripgrep (para Telescope)
if (Test-Command "rg") {
    Write-Success "ripgrep ya está instalado"
} else {
    Write-Info "Instalando ripgrep..."
    try {
        winget install --id=BurntSushi.ripgrep.MSVC -e --source winget
        Write-Success "ripgrep instalado"
    }
    catch {
        Write-Warning "Error instalando ripgrep: $_"
    }
}

# fd (búsqueda de archivos)
if (Test-Command "fd") {
    Write-Success "fd ya está instalado"
} else {
    Write-Info "Instalando fd..."
    try {
        winget install --id=sharkdp.fd -e --source winget
        Write-Success "fd instalado"
    }
    catch {
        Write-Warning "Error instalando fd: $_"
    }
}

# bat (cat con syntax highlighting)
if (Test-Command "bat") {
    Write-Success "bat ya está instalado"
} else {
    Write-Info "Instalando bat..."
    try {
        winget install --id=sharkdp.bat -e --source winget
        Write-Success "bat instalado"
    }
    catch {
        Write-Warning "Error instalando bat: $_"
    }
}

# fzf (fuzzy finder)
if (Test-Command "fzf") {
    Write-Success "fzf ya está instalado"
} else {
    Write-Info "Instalando fzf..."
    try {
        winget install --id=junegunn.fzf -e --source winget
        Write-Success "fzf instalado"
    }
    catch {
        Write-Warning "Error instalando fzf: $_"
    }
}

# yazi (file manager)
if (Test-Command "yazi") {
    Write-Success "yazi ya está instalado"
} else {
    Write-Info "Instalando yazi..."
    try {
        # Yazi puede no estar en winget, intentar instalación manual
        $yaziUrl = "https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-pc-windows-msvc.zip"
        $yaziZip = "$env:TEMP\yazi.zip"
        $yaziDir = "$env:LOCALAPPDATA\Programs\yazi"

        Write-Info "Descargando yazi desde GitHub..."
        Invoke-WebRequest -Uri $yaziUrl -OutFile $yaziZip

        Write-Info "Extrayendo yazi..."
        Expand-Archive -Path $yaziZip -DestinationPath $yaziDir -Force

        # Agregar al PATH del usuario
        $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($userPath -notlike "*$yaziDir*") {
            [Environment]::SetEnvironmentVariable(
                "Path",
                "$userPath;$yaziDir",
                "User"
            )
            Write-Success "yazi instalado en $yaziDir"
            Write-Warning "Reinicia PowerShell para que yazi esté en el PATH"
        }

        Remove-Item $yaziZip -Force
    }
    catch {
        Write-Warning "Error instalando yazi: $_"
        Write-Info "Puedes instalarlo manualmente desde: https://github.com/sxyazi/yazi/releases"
    }
}

#################################################
# 7. INSTALAR GCC/MinGW (para compilar plugins nativos)
#################################################

Write-Info "Verificando compilador C..."

if (Test-Command "gcc") {
    Write-Success "gcc ya está instalado"
} else {
    Write-Info "Instalando MinGW (compilador C)..."
    try {
        winget install --id=MSYS2.MSYS2 -e --source winget
        Write-Success "MSYS2 instalado"
        Write-Info "Después de la instalación, ejecuta en MSYS2:"
        Write-Host "  pacman -S mingw-w64-x86_64-gcc" -ForegroundColor Yellow
    }
    catch {
        Write-Warning "Error instalando MSYS2: $_"
        Write-Info "Puedes instalarlo manualmente desde: https://www.msys2.org/"
    }
}

#################################################
# 8. VERIFICAR CONFIGURACIÓN DE NEOVIM
#################################################

Write-Info "Verificando configuración de Neovim..."

$nvimConfigPath = "$env:LOCALAPPDATA\nvim"

if (Test-Path $nvimConfigPath) {
    Write-Success "Directorio de configuración existe: $nvimConfigPath"
} else {
    Write-Warning "No se encontró la configuración de Neovim en $nvimConfigPath"
    Write-Info "Para usar esta configuración, copia el directorio .config/nvim a:"
    Write-Host "  $nvimConfigPath" -ForegroundColor Yellow
}

#################################################
# 9. RESUMEN
#################################################

Write-Info ""
Write-Info "Instalación completada!"
Write-Info ""
Write-Info "Próximos pasos:"
Write-Info "1. Reinicia PowerShell para que las variables de entorno se actualicen"
Write-Info "2. Si no has copiado la configuración, copia .config/nvim a: $nvimConfigPath"
Write-Info "3. Ejecuta: nvim"
Write-Info "4. Lazy.nvim instalará automáticamente todos los plugins"
Write-Info "5. Los LSP servers se instalarán automáticamente vía Mason"
Write-Info ""

# Mostrar versiones instaladas
Write-Info "Herramientas instaladas:"
if (Test-Command "nvim") { Write-Host "  - Neovim: $(nvim --version | Select-String 'NVIM' | Select-Object -First 1)" }
if (Test-Command "git") { Write-Host "  - Git: $(git --version)" }
if (Test-Command "node") { Write-Host "  - Node.js: $(node --version)" }
if (Test-Command "python") { Write-Host "  - Python: $(python --version)" }
if (Test-Command "rg") { Write-Host "  - ripgrep: $(rg --version | Select-Object -First 1)" }
if (Test-Command "fd") { Write-Host "  - fd: $(fd --version)" }
if (Test-Command "bat") { Write-Host "  - bat: $(bat --version)" }
if (Test-Command "fzf") { Write-Host "  - fzf: $(fzf --version)" }
if (Test-Command "yazi") { Write-Host "  - yazi: $(yazi --version | Select-Object -First 1)" }

Write-Success "¡Todo listo!"
