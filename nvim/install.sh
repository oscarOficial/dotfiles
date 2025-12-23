#!/bin/bash
#################################################
# INSTALADOR AUTOMÁTICO DE NEOVIM Y DEPENDENCIAS
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

# Función para instalar un paquete si no existe
install_if_missing() {
    local cmd=$1
    local package=${2:-$1}

    if command_exists "$cmd"; then
        print_success "$cmd ya está instalado"
        return 0
    fi

    print_info "Instalando $package..."
    sudo apt install -y "$package"
    print_success "$package instalado correctamente"
}

#################################################
# 1. VERIFICAR SISTEMA OPERATIVO
#################################################

print_info "Verificando sistema operativo..."

if [[ ! -f /etc/os-release ]]; then
    print_error "No se pudo detectar el sistema operativo"
    exit 1
fi

source /etc/os-release
print_success "Sistema detectado: $NAME $VERSION"

#################################################
# 2. ACTUALIZAR REPOSITORIOS
#################################################

print_info "Actualizando repositorios..."
sudo apt update
print_success "Repositorios actualizados"

#################################################
# 3. INSTALAR DEPENDENCIAS BÁSICAS
#################################################

print_info "Instalando dependencias básicas..."

# Build tools (requerido para compilar plugins nativos)
install_if_missing gcc build-essential
install_if_missing make build-essential
install_if_missing git git

# Neovim
if command_exists nvim; then
    print_success "Neovim ya está instalado ($(nvim --version | head -n1))"
else
    print_info "Instalando Neovim..."

    # Intentar instalar desde repositorio oficial
    if sudo apt install -y neovim 2>/dev/null; then
        print_success "Neovim instalado desde repositorio"
    else
        # Fallback: instalar desde PPA (versión más reciente)
        print_warning "Intentando instalar Neovim desde PPA..."
        sudo add-apt-repository ppa:neovim-ppa/unstable -y
        sudo apt update
        sudo apt install -y neovim
        print_success "Neovim instalado desde PPA"
    fi
fi

# Node.js (requerido para muchos LSP servers)
if command_exists node; then
    print_success "Node.js ya está instalado ($(node --version))"
else
    print_info "Instalando Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    print_success "Node.js instalado"
fi

# Python y pip (requerido para algunos plugins)
install_if_missing python3 python3
install_if_missing pip3 python3-pip

#################################################
# 4. INSTALAR HERRAMIENTAS CLI
#################################################

print_info "Instalando herramientas CLI..."

# ripgrep (para Telescope live grep)
install_if_missing rg ripgrep

# fd (búsqueda rápida de archivos)
if ! command_exists fd && ! command_exists fdfind; then
    print_info "Instalando fd-find..."
    sudo apt install -y fd-find
    # Crear symlink si es necesario
    if command_exists fdfind && ! command_exists fd; then
        mkdir -p ~/.local/bin
        ln -sf "$(which fdfind)" ~/.local/bin/fd
        print_success "Symlink fd creado"
    fi
    print_success "fd-find instalado"
else
    print_success "fd ya está instalado"
fi

# bat (cat con syntax highlighting)
if ! command_exists bat && ! command_exists batcat; then
    print_info "Instalando bat..."
    sudo apt install -y bat
    # Crear symlink si es necesario
    if command_exists batcat && ! command_exists bat; then
        mkdir -p ~/.local/bin
        ln -sf "$(which batcat)" ~/.local/bin/bat
        print_success "Symlink bat creado"
    fi
    print_success "bat instalado"
else
    print_success "bat ya está instalado"
fi

# fzf (fuzzy finder)
if ! command_exists fzf; then
    print_info "Instalando fzf..."

    # Clonar repositorio
    if [[ ! -d ~/.fzf ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fi

    # Instalar binario
    ~/.fzf/install --bin

    # Crear symlink
    mkdir -p ~/.local/bin
    ln -sf ~/.fzf/bin/fzf ~/.local/bin/fzf

    print_success "fzf instalado"
else
    print_success "fzf ya está instalado"
fi

# Yazi (file manager)
if ! command_exists yazi; then
    print_info "Instalando yazi..."

    # Intentar instalar desde snap primero
    if command_exists snap; then
        sudo snap install yazi
        print_success "yazi instalado desde snap"
    else
        # Fallback: descargar binario
        print_info "Descargando binario de yazi..."
        mkdir -p /tmp/yazi_install
        cd /tmp/yazi_install

        curl -L https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip -o yazi.zip
        unzip -o yazi.zip

        # Instalar binarios
        mkdir -p ~/.local/bin
        cp yazi-x86_64-unknown-linux-gnu/yazi ~/.local/bin/
        cp yazi-x86_64-unknown-linux-gnu/ya ~/.local/bin/
        chmod +x ~/.local/bin/yazi ~/.local/bin/ya

        # Limpiar
        cd ~
        rm -rf /tmp/yazi_install

        print_success "yazi instalado en ~/.local/bin"
    fi
else
    print_success "yazi ya está instalado"
fi

# Ya (yazi CLI helper)
if ! command_exists ya; then
    if [[ -f ~/.local/bin/ya ]]; then
        print_success "ya ya está instalado en ~/.local/bin"
    else
        print_info "Instalando ya..."
        mkdir -p /tmp/ya_install
        cd /tmp/ya_install

        curl -L https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip -o yazi.zip
        unzip -o yazi.zip

        mkdir -p ~/.local/bin
        cp yazi-x86_64-unknown-linux-gnu/ya ~/.local/bin/
        chmod +x ~/.local/bin/ya

        cd ~
        rm -rf /tmp/ya_install

        print_success "ya instalado"
    fi
else
    print_success "ya ya está instalado"
fi

#################################################
# 5. AGREGAR ~/.local/bin AL PATH SI NO ESTÁ
#################################################

print_info "Verificando PATH..."

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    print_warning "~/.local/bin no está en el PATH"

    # Detectar shell
    if [[ -n "$ZSH_VERSION" ]] || [[ "$SHELL" == *"zsh"* ]]; then
        shell_rc="$HOME/.zshrc"
    elif [[ -n "$BASH_VERSION" ]] || [[ "$SHELL" == *"bash"* ]]; then
        shell_rc="$HOME/.bashrc"
    else
        shell_rc="$HOME/.profile"
    fi

    print_info "Agregando ~/.local/bin al PATH en $shell_rc"

    echo '' >> "$shell_rc"
    echo '# Add ~/.local/bin to PATH (added by nvim installer)' >> "$shell_rc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$shell_rc"

    print_success "PATH actualizado. Ejecuta 'source $shell_rc' o reinicia la terminal"
else
    print_success "~/.local/bin ya está en el PATH"
fi

#################################################
# 6. INICIAR NEOVIM PARA INSTALAR PLUGINS
#################################################

print_info "Configuración de dependencias completada"
print_info ""
print_info "Próximos pasos:"
print_info "1. Cierra y reabre la terminal (o ejecuta: source ~/.bashrc o source ~/.zshrc)"
print_info "2. Ejecuta: nvim"
print_info "3. Lazy.nvim instalará automáticamente todos los plugins"
print_info "4. Los LSP servers se instalarán automáticamente vía Mason"
print_info ""
print_success "¡Instalación completada!"

# Mostrar versiones instaladas
echo ""
print_info "Versiones instaladas:"
echo "  - Neovim: $(nvim --version | head -n1)"
echo "  - Git: $(git --version)"
echo "  - Node.js: $(node --version 2>/dev/null || echo 'N/A')"
echo "  - ripgrep: $(rg --version | head -n1 2>/dev/null || echo 'N/A')"
echo "  - fd: $(fd --version 2>/dev/null || fdfind --version 2>/dev/null || echo 'N/A')"
echo "  - bat: $(bat --version 2>/dev/null || batcat --version 2>/dev/null || echo 'N/A')"
echo "  - fzf: $(fzf --version 2>/dev/null || echo 'N/A')"
echo "  - yazi: $(yazi --version 2>/dev/null || echo 'N/A')"
