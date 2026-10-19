<#
  check.ps1 — Comprueba que todo lo de apps.ps1 está instalado.
  Uso (no hace falta administrador):  .\windows\check.ps1
#>

function Ok($msg)   { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Fail($msg) { Write-Host "  [--] $msg" -ForegroundColor Red; $script:faltan++ }
$faltan = 0

# --- Programas instalados con winget ----------------------------------------
$apps = [ordered]@{
    "Windows Terminal"     = "Microsoft.WindowsTerminal"
    "PowerShell 7"         = "Microsoft.PowerShell"
    "Git"                  = "Git.Git"
    "Neovim"               = "Neovim.Neovim"
    "VS Code"              = "Microsoft.VisualStudioCode"
    "Python 3"             = "Python.Python.3.14"
    "7-Zip"                = "7zip.7zip"
    "Everything"           = "voidtools.Everything"
    "Node.js LTS"          = "OpenJS.NodeJS.LTS"
    "Pandoc (md2pdf)"      = "JohnMacFarlane.Pandoc"
    "MiKTeX (md2pdf)"      = "MiKTeX.MiKTeX"
    "VirtualBox"           = "Oracle.VirtualBox"
    "Wireshark"            = "WiresharkFoundation.Wireshark"
    "Burp Suite Community" = "PortSwigger.BurpSuite.Community"
    "Nmap"                 = "Insecure.Nmap"
    "Sysinternals Suite"   = "Microsoft.Sysinternals.Suite"
    "OpenVPN"              = "OpenVPNTechnologies.OpenVPN"
    "Java (para Ghidra)"   = "EclipseAdoptium.Temurin.21.JDK"
    "Firefox"              = "Mozilla.Firefox"
    "Bitwarden"            = "Bitwarden.Bitwarden"
    "Obsidian"             = "Obsidian.Obsidian"
    "JetBrainsMono Nerd Font" = "DEVCOM.JetBrainsMonoNerdFont"
}

Write-Host "`nProgramas" -ForegroundColor Cyan
foreach ($name in $apps.Keys) {
    winget list --id $apps[$name] --exact --accept-source-agreements *> $null
    if ($LASTEXITCODE -eq 0) { Ok $name } else { Fail $name }
}

# --- Ghidra ------------------------------------------------------------------
Write-Host "`nGhidra" -ForegroundColor Cyan
if (Test-Path "C:\Tools\ghidra_*\ghidraRun.bat") { Ok "Ghidra en C:\Tools" } else { Fail "Ghidra (C:\Tools)" }

# --- Herramientas para Neovim -------------------------------------------------
Write-Host "`nDependencias de Neovim" -ForegroundColor Cyan
foreach ($cmd in "gcc", "make", "rg", "fd", "tree-sitter") {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) { Ok $cmd } else { Fail $cmd }
}
if ([Environment]::GetEnvironmentVariable("CC", "User") -eq "gcc") { Ok "Variable CC=gcc" } else { Fail "Variable CC=gcc" }

# --- md2pdf (mmdc: diagramas Mermaid) ------------------------------------------
Write-Host "`nmd2pdf" -ForegroundColor Cyan
foreach ($cmd in "pandoc", "xelatex", "mmdc") {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) { Ok $cmd } else { Fail $cmd }
}

# --- Enlaces de la configuración ---------------------------------------------
Write-Host "`nConfiguración" -ForegroundColor Cyan
$nvim = Get-Item "$env:LOCALAPPDATA\nvim" -Force -ErrorAction SilentlyContinue
if ($nvim -and $nvim.LinkType) { Ok "Neovim enlazado a $($nvim.Target)" } else { Fail "Neovim no está enlazado (ejecuta install.ps1)" }
$perfil = Get-Item "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Force -ErrorAction SilentlyContinue
if ($perfil -and $perfil.LinkType) { Ok "Perfil de PowerShell enlazado a $($perfil.Target)" } else { Fail "Perfil de PowerShell no está enlazado (ejecuta install.ps1)" }

# --- WSL -----------------------------------------------------------------------
Write-Host "`nWSL" -ForegroundColor Cyan
$distros = (wsl -l -q 2>$null) -replace "`0", "" | Where-Object { $_.Trim() }
foreach ($d in "Ubuntu", "kali-linux") {
    if ($distros -contains $d) { Ok $d } else { Fail "$d (instálalo con: wsl --install -d $d)" }
}

# --- SSH -------------------------------------------------------------------------
Write-Host "`nSSH" -ForegroundColor Cyan
if ((Get-Service ssh-agent -ErrorAction SilentlyContinue).Status -eq "Running") { Ok "Agente SSH en marcha" } else { Fail "Agente SSH parado" }
ssh -T -o BatchMode=yes -o ConnectTimeout=5 git@github.com *> $null
if ($LASTEXITCODE -eq 1) { Ok "Conexión con GitHub" } else { Fail "Conexión con GitHub (prueba: ssh -T git@github.com)" }

# --- Resumen -------------------------------------------------------------------
Write-Host ""
if ($faltan -eq 0) {
    Write-Host "Todo instalado." -ForegroundColor Green
} else {
    Write-Host "Faltan $faltan cosas. Puedes volver a ejecutar apps.ps1: se salta lo que ya está." -ForegroundColor Yellow
}
Write-Host "Revisa a mano las extensiones de Firefox: FoxyProxy, uBlock Origin y Wappalyzer." -ForegroundColor Cyan
