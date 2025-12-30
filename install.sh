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
echo "  1) Todo (Neovim + Yazi + dependencias)"
echo "  2) Solo Neovim (completo con dependencias)"
echo "  3) Solo Yazi (completo con dependencias)"
echo "  4) Neovim + Yazi (sin dependencias)"
echo "  5) Salir"
echo ""
read -p "Opción [1-5]: " option

case $option in
    1)
        print_info "Instalando todo..."
        INSTALL_NVIM=true
        INSTALL_YAZI=true
        ;;
    2)
        print_info "Instalando solo Neovim..."
        INSTALL_NVIM=true
        INSTALL_YAZI=false
        ;;
    3)
        print_info "Instalando solo Yazi..."
        INSTALL_NVIM=false
        INSTALL_YAZI=true
        ;;
    4)
        print_info "Instalando Neovim + Yazi (asumiendo dependencias ya instaladas)..."
        INSTALL_NVIM=true
        INSTALL_YAZI=true
        ;;
    5)
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
# INSTALAR NEOVIM
#################################################

if [ "$INSTALL_NVIM" = true ]; then
    print_info "Ejecutando instalador de Neovim..."
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
# INSTALAR YAZI
#################################################

if [ "$INSTALL_YAZI" = true ]; then
    print_info "Ejecutando instalador de Yazi..."
    echo ""

    if [ -f "$DOTFILES_DIR/yazi/install.sh" ]; then
        cd "$DOTFILES_DIR/yazi"
        bash install.sh
        cd "$DOTFILES_DIR"
    else
        print_error "No se encontró yazi/install.sh"
        exit 1
    fi

    echo ""
fi


#################################################
# RESUMEN FINAL
#################################################

print_success "¡Instalación completada!"
echo ""

if [ "$INSTALL_NVIM" = true ]; then
    print_info "✓ Neovim instalado"
    echo "  Configuración en: ~/.config/nvim"
    echo "  Próximos pasos:"
    echo "    - Ejecuta 'nvim' para abrir Neovim"
    echo "    - Los plugins se instalarán automáticamente"
    echo ""
fi

if [ "$INSTALL_YAZI" = true ]; then
    print_info "✓ Yazi instalado"
    echo "  Configuración en: ~/.config/yazi"
    echo "  Próximos pasos:"
    echo "    - Ejecuta 'yazi' para abrir el file manager"
    echo "    - Usa 'zf' para buscar archivos recursivamente"
    echo "    - Usa 'zg' para buscar por contenido"
    echo ""
fi

print_info "Para actualizar en el futuro:"
echo "  cd $DOTFILES_DIR"
echo "  git pull"
echo "  ./install.sh"
echo ""

print_success "¡Todo listo! 🚀"
