#!/bin/bash
#################################################
# INSTALADOR PRINCIPAL DE DOTFILES
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

# Obtener directorio del script
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

print_info "Dotfiles directory: $DOTFILES_DIR"
echo ""

#################################################
# BANNER
#################################################

cat << "EOF"
╔══════════════════════════════════════════════════╗
║                                                  ║
║        🏠  DOTFILES INSTALLATION                 ║
║           Oscar's Dev Environment               ║
║                                                  ║
╚══════════════════════════════════════════════════╝
EOF

echo ""

#################################################
# MENÚ DE INSTALACIÓN
#################################################

print_info "Selecciona qué instalar:"
echo ""
echo "  1) Todo (Neovim + dependencias)"
echo "  2) Solo Neovim (sin dependencias)"
echo "  3) Solo dependencias (sin configuración)"
echo "  4) Salir"
echo ""
read -p "Opción [1-4]: " option

case $option in
    1)
        print_info "Instalando todo..."
        INSTALL_DEPS=true
        INSTALL_NVIM=true
        ;;
    2)
        print_info "Instalando solo configuración de Neovim..."
        INSTALL_DEPS=false
        INSTALL_NVIM=true
        ;;
    3)
        print_info "Instalando solo dependencias..."
        INSTALL_DEPS=true
        INSTALL_NVIM=false
        ;;
    4)
        print_info "Saliendo..."
        exit 0
        ;;
    *)
        print_error "Opción inválida"
        exit 1
        ;;
esac

echo ""

#################################################
# INSTALAR DEPENDENCIAS
#################################################

if [ "$INSTALL_DEPS" = true ]; then
    print_info "Ejecutando instalador de dependencias de Neovim..."
    echo ""

    if [ -f "$DOTFILES_DIR/nvim/install.sh" ]; then
        cd "$DOTFILES_DIR/nvim"
        bash install.sh
        cd "$DOTFILES_DIR"
    else
        print_error "No se encontró nvim/install.sh"
        exit 1
    fi

    echo ""
fi

#################################################
# CREAR SYMLINKS DE CONFIGURACIÓN
#################################################

if [ "$INSTALL_NVIM" = true ]; then
    print_info "Creando symlinks de configuración..."
    echo ""

    # Neovim
    NVIM_CONFIG_DIR="$HOME/.config/nvim"
    NVIM_DOTFILES_DIR="$DOTFILES_DIR/nvim"

    # Backup de configuración existente
    if [ -d "$NVIM_CONFIG_DIR" ] && [ ! -L "$NVIM_CONFIG_DIR" ]; then
        print_warning "Encontrada configuración existente de Neovim"
        BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Creando backup en: $BACKUP_DIR"
        mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
        print_success "Backup creado"
    fi

    # Eliminar symlink existente
    if [ -L "$NVIM_CONFIG_DIR" ]; then
        print_info "Eliminando symlink existente..."
        rm "$NVIM_CONFIG_DIR"
    fi

    # Crear symlink
    print_info "Creando symlink: $NVIM_CONFIG_DIR -> $NVIM_DOTFILES_DIR"
    ln -sf "$NVIM_DOTFILES_DIR" "$NVIM_CONFIG_DIR"
    print_success "Symlink de Neovim creado"

    echo ""
fi

#################################################
# RESUMEN FINAL
#################################################

print_success "¡Instalación completada!"
echo ""

if [ "$INSTALL_NVIM" = true ]; then
    print_info "Configuración de Neovim instalada en:"
    echo "  ~/.config/nvim -> $NVIM_DOTFILES_DIR"
    echo ""
    print_info "Próximos pasos para Neovim:"
    echo "  1. Abre Neovim: nvim"
    echo "  2. Lazy.nvim instalará automáticamente los plugins"
    echo "  3. Los LSP servers se instalarán vía Mason automáticamente"
    echo ""
fi

print_info "Para actualizar en el futuro:"
echo "  cd $DOTFILES_DIR"
echo "  git pull"
echo "  ./install.sh"
echo ""

print_success "¡Todo listo! 🚀"
