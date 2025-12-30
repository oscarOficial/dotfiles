#!/bin/bash
#################################################
# INSTALADOR AUTOMÁTICO DE YAZI Y DEPENDENCIAS
# Para Ubuntu/Debian/Linux
#################################################

set -e  # Exit on error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con color
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Banner
echo ""
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Instalador de Yazi + Plugins         ║${NC}"
echo -e "${BLUE}║  Sistema: Linux                        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

#################################################
# 1. INSTALAR YAZI
#################################################

print_info "Verificando Yazi..."

if command_exists yazi; then
    print_success "Yazi ya está instalado ($(yazi --version))"
else
    print_info "Instalando Yazi via snap..."
    sudo snap install yazi
    print_success "Yazi instalado correctamente"
fi

#################################################
# 2. INSTALAR DEPENDENCIAS PARA PLUGINS
#################################################

print_info "Instalando dependencias para plugins..."

# fd (file finder)
if command_exists fd; then
    print_success "fd ya está instalado"
else
    print_info "Instalando fd..."

    # Intentar con cargo primero (más reciente)
    if command_exists cargo; then
        cargo install fd-find
    else
        # Fallback: descargar binario
        FD_VERSION="10.2.0"
        wget -q "https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-x86_64-unknown-linux-gnu.tar.gz" -O /tmp/fd.tar.gz
        tar -xzf /tmp/fd.tar.gz -C /tmp
        mkdir -p ~/.local/bin
        cp "/tmp/fd-v${FD_VERSION}-x86_64-unknown-linux-gnu/fd" ~/.local/bin/
        rm -rf /tmp/fd*
    fi

    print_success "fd instalado correctamente"
fi

# fzf (fuzzy finder)
if command_exists fzf; then
    print_success "fzf ya está instalado"
else
    print_info "Instalando fzf..."

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --bin --no-update-rc --no-bash --no-zsh --no-fish

    mkdir -p ~/.local/bin
    cp ~/.fzf/bin/fzf ~/.local/bin/

    print_success "fzf instalado correctamente"
fi

# ripgrep (content search)
if command_exists rg; then
    print_success "ripgrep ya está instalado"
else
    print_info "Instalando ripgrep..."

    if command_exists cargo; then
        cargo install ripgrep
    else
        sudo apt update
        sudo apt install -y ripgrep
    fi

    print_success "ripgrep instalado correctamente"
fi

# bat (file previewer)
if command_exists bat; then
    print_success "bat ya está instalado"
else
    print_info "Instalando bat..."

    if command_exists cargo; then
        cargo install bat
    else
        # Descargar binario
        BAT_VERSION="0.24.0"
        wget -q "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-x86_64-unknown-linux-gnu.tar.gz" -O /tmp/bat.tar.gz
        tar -xzf /tmp/bat.tar.gz -C /tmp
        mkdir -p ~/.local/bin
        cp "/tmp/bat-v${BAT_VERSION}-x86_64-unknown-linux-gnu/bat" ~/.local/bin/
        rm -rf /tmp/bat*
    fi

    print_success "bat instalado correctamente"
fi

#################################################
# 3. COPIAR CONFIGURACIONES
#################################################

print_info "Copiando configuraciones de Yazi..."

# Crear directorio de configuración
mkdir -p ~/.config/yazi/plugins

# Obtener directorio del script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copiar configuración común
cp "$SCRIPT_DIR/yazi.toml" ~/.config/yazi/yazi.toml
print_success "yazi.toml copiado"

# Copiar keymap para Linux
cp "$SCRIPT_DIR/keymap-linux.toml" ~/.config/yazi/keymap.toml
print_success "keymap.toml copiado (versión Linux con plugins)"

# Copiar package.toml
cp "$SCRIPT_DIR/package.toml" ~/.config/yazi/package.toml
print_success "package.toml copiado"

# Copiar plugins
cp -r "$SCRIPT_DIR/plugins/"* ~/.config/yazi/plugins/
chmod +x ~/.config/yazi/plugins/fazif.yazi/faziffd
chmod +x ~/.config/yazi/plugins/fazif.yazi/fazifrg
chmod +x ~/.config/yazi/plugins/fazif.yazi/fazifrga
print_success "Plugins copiados y permisos configurados"

#################################################
# 4. INSTALAR PLUGINS DE YAZI
#################################################

print_info "Instalando plugins de Yazi..."

# Verificar si ya existen para evitar duplicados
if [ -d ~/.config/yazi/plugins/jump-to-char.yazi ]; then
    print_warning "Plugins ya instalados, actualizando..."
    ya pack -u
else
    print_info "Instalando plugins por primera vez..."
    ya pack -i
fi

print_success "Plugins de Yazi instalados"

#################################################
# 5. VERIFICACIÓN FINAL
#################################################

echo ""
print_info "Verificando instalación..."

# Verificar PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    print_warning "~/.local/bin no está en tu PATH"
    print_info "Agrega esta línea a tu ~/.bashrc o ~/.zshrc:"
    echo -e "${YELLOW}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
fi

# Verificar herramientas
echo ""
print_info "Herramientas instaladas:"
command_exists yazi && echo -e "  ${GREEN}✓${NC} yazi: $(yazi --version | head -1)"
command_exists fd && echo -e "  ${GREEN}✓${NC} fd: $(fd --version)"
command_exists fzf && echo -e "  ${GREEN}✓${NC} fzf: $(fzf --version)"
command_exists rg && echo -e "  ${GREEN}✓${NC} ripgrep: $(rg --version | head -1)"
command_exists bat && echo -e "  ${GREEN}✓${NC} bat: $(bat --version)"

#################################################
# FINALIZACIÓN
#################################################

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✓ Instalación completada             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
print_info "Yazi está listo para usar!"
echo ""
print_info "Atajos de teclado dentro de Yazi:"
echo "  zf  - Buscar archivos recursivamente (fd + fzf)"
echo "  zg  - Buscar por contenido (ripgrep + fzf)"
echo "  F   - Filtro inteligente"
echo "  f   - Saltar a carácter (vim-like)"
echo ""
print_info "Ejecuta 'yazi' para comenzar"
echo ""
