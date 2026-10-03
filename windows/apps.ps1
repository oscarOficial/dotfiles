<#
  apps.ps1 — Instala las aplicaciones base en un Windows recién instalado.
  Uso (PowerShell como administrador, con el repo clonado en ~\dotfiles).
  Son dos comandos: ejecútalos por separado, pulsando Enter tras cada uno.
      Set-ExecutionPolicy Bypass -Scope Process -Force
      .\windows\apps.ps1
  Para añadir o quitar programas, edita la lista $apps.
  Si un ID falla, búscalo con:  winget search <nombre>
#>

# --- Comprobar que se ejecuta como administrador ---------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
           ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Ejecuta este script en PowerShell como administrador." -ForegroundColor Red
    exit 1
}

# --- Lista de aplicaciones (ID de winget) ----------------------------------
$apps = @(
    # Base y terminal
    "Microsoft.WindowsTerminal"
    "Microsoft.PowerShell"
    "Git.Git"
    "Neovim.Neovim"
    "DEVCOM.JetBrainsMonoNerdFont"     # fuente con iconos para Neovim
    "Chocolatey.Chocolatey"            # para las dependencias de Neovim (ver abajo)
    "Microsoft.VisualStudioCode"
    "Python.Python.3.14"
    "7zip.7zip"
    "voidtools.Everything"

    # Virtualización
    "Oracle.VirtualBox"

    # Ciberseguridad
    "WiresharkFoundation.Wireshark"
    "PortSwigger.BurpSuite.Community"
    "Insecure.Nmap"
    "Microsoft.Sysinternals.Suite"
    "OpenVPNTechnologies.OpenVPN"
    "EclipseAdoptium.Temurin.21.JDK"   # Java, necesario para Ghidra

    # Navegador, contraseñas y apuntes
    "Mozilla.Firefox"
    "Bitwarden.Bitwarden"               # o cámbialo por "KeePassXCTeam.KeePassXC"
    "Obsidian.Obsidian"
)

# --- Instalación ------------------------------------------------------------
$fallidas = @()

foreach ($app in $apps) {
    Write-Host "`n==> Instalando $app" -ForegroundColor Cyan
    winget install --id $app --exact --silent `
        --accept-package-agreements --accept-source-agreements
    # 0 = instalado; -1978335189 = ya estaba instalado
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) {
        $fallidas += $app
    }
}

# --- Dependencias de Neovim (compilador, make, ripgrep, fd, tree-sitter) ---
Write-Host "`n==> Instalando dependencias de Neovim" -ForegroundColor Cyan
$choco = "$env:ProgramData\chocolatey\bin\choco.exe"
if (Test-Path $choco) {
    & $choco install -y ripgrep fd unzip gzip mingw make tree-sitter
    if ($LASTEXITCODE -ne 0) { $fallidas += "Dependencias de Neovim (choco)" }
} else {
    $fallidas += "Dependencias de Neovim (no se encontró Chocolatey)"
}

# En Windows, tree-sitter busca el compilador de Visual Studio (cl.exe).
# Con esto usa gcc (instalado arriba con mingw) para compilar los parsers de Neovim.
[Environment]::SetEnvironmentVariable("CC", "gcc", "User")

# --- Ghidra (no está en winget: se descarga la última versión de GitHub) ---
Write-Host "`n==> Instalando Ghidra" -ForegroundColor Cyan
if (Test-Path "C:\Tools\ghidra_*") {
    Write-Host "Ghidra ya está instalado en C:\Tools" -ForegroundColor Green
} else {
    try {
        $ProgressPreference = 'SilentlyContinue'   # sin esto la descarga es muy lenta
        $release = Invoke-RestMethod "https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest"
        $asset   = $release.assets | Where-Object { $_.name -like "*.zip" } | Select-Object -First 1
        $zip     = "$env:TEMP\$($asset.name)"
        Invoke-WebRequest $asset.browser_download_url -OutFile $zip
        New-Item -ItemType Directory -Force -Path "C:\Tools" | Out-Null
        tar -xf $zip -C "C:\Tools"                  # mucho más rápido que Expand-Archive
        if ($LASTEXITCODE -ne 0) { throw "Error al descomprimir" }
        Remove-Item $zip
        Write-Host "Ghidra instalado en C:\Tools (ejecuta ghidraRun.bat)" -ForegroundColor Green
    } catch {
        $fallidas += "Ghidra"
    }
}

# --- WSL con Ubuntu y Kali --------------------------------------------------
Write-Host "`n==> Instalando WSL (Ubuntu y Kali)" -ForegroundColor Cyan
wsl --install -d Ubuntu --no-launch
wsl --install -d kali-linux --no-launch

# --- Enlazar la configuración del repo (Neovim, perfil de PowerShell) ------
Write-Host "`n==> Enlazando dotfiles" -ForegroundColor Cyan
& "$PSScriptRoot\..\install.ps1"

# --- Resumen ----------------------------------------------------------------
Write-Host "`n===================================" -ForegroundColor Cyan
if ($fallidas.Count -eq 0) {
    Write-Host "Todo instalado correctamente." -ForegroundColor Green
} else {
    Write-Host "Fallaron estas instalaciones:" -ForegroundColor Yellow
    $fallidas | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
}
Write-Host "Reinicia el equipo para terminar de configurar WSL." -ForegroundColor Cyan
Write-Host "Luego, dentro de Ubuntu (WSL), clona tu repo en ~/dotfiles y ejecuta ./install.sh (instala tmux y Neovim)" -ForegroundColor Cyan
Write-Host "En Windows Terminal elige la fuente 'JetBrainsMono Nerd Font' para ver los iconos." -ForegroundColor Cyan
