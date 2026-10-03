<#
  install.ps1 — Windows
  Enlaza la configuración del repo a su sitio en Windows.
  Necesita PowerShell como administrador o el Modo de desarrollador activado.
  Uso:  cd ~\dotfiles; .\install.ps1
#>

$DOTFILES = $PSScriptRoot

function Link($src, $dst) {
    $item = Get-Item $dst -Force -ErrorAction SilentlyContinue
    if ($item -and -not $item.LinkType) {
        $bak = "$dst.bak." + (Get-Date -Format "yyyyMMddHHmmss")
        Move-Item $dst $bak
        Write-Host "Copia de seguridad: $bak" -ForegroundColor Yellow
    } elseif ($item) {
        $item.Delete()   # borra solo el enlace antiguo, no su contenido
    }
    New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null
    New-Item -ItemType SymbolicLink -Path $dst -Target $src | Out-Null
    Write-Host "Enlazado: $dst -> $src" -ForegroundColor Green
}

# Neovim (misma configuración que en Ubuntu)
Link "$DOTFILES\nvim" "$env:LOCALAPPDATA\nvim"

# Perfil de PowerShell (si lo tienes en el repo)
$PROFILE_PS7 = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
if (Test-Path "$DOTFILES\windows\profile.ps1") {
    Link "$DOTFILES\windows\profile.ps1" $PROFILE_PS7
}

Write-Host "`nListo. Abre una terminal nueva y ejecuta: nvim" -ForegroundColor Cyan
