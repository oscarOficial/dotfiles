#!/usr/bin/env bash
# install.sh — Ubuntu (o Ubuntu en WSL)
# Instala Neovim (versión estable oficial), tmux y lo que necesita la config,
# y enlaza los dotfiles del repo a su sitio.
#   Uso:  cd ~/dotfiles && ./install.sh
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IS_WSL=false; grep -qi microsoft /proc/version && IS_WSL=true

case "$(uname -m)" in
  x86_64)  NVIM_ARCH=x86_64; TS_ARCH=x64 ;;
  aarch64) NVIM_ARCH=arm64;  TS_ARCH=arm64 ;;
  *) echo "Arquitectura no soportada: $(uname -m)"; exit 1 ;;
esac

info() { printf '\n\033[1;36m==> %s\033[0m\n' "$1"; }

# --- Paquetes ----------------------------------------------------------------
info "Instalando paquetes"
sudo apt update
sudo apt install -y git curl unzip make gcc ripgrep fd-find xclip tmux fontconfig

mkdir -p "$HOME/.local/bin"
# En Ubuntu fd se llama fdfind
ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"

# tree-sitter CLI: del repositorio si existe, si no el binario oficial
if ! sudo apt install -y tree-sitter-cli 2>/dev/null; then
  info "Instalando tree-sitter CLI desde GitHub"
  curl -fL "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-${TS_ARCH}.gz" \
    | gunzip > "$HOME/.local/bin/tree-sitter"
  chmod +x "$HOME/.local/bin/tree-sitter"
fi

# --- Neovim estable (el de apt suele estar desfasado) --------------------------
info "Instalando Neovim estable"
tmp="$(mktemp -d)"
curl -fL -o "$tmp/nvim.tar.gz" \
  "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-${NVIM_ARCH}.tar.gz"
sudo rm -rf "/opt/nvim-linux-${NVIM_ARCH}"
sudo tar -C /opt -xzf "$tmp/nvim.tar.gz"
sudo ln -sf "/opt/nvim-linux-${NVIM_ARCH}/bin/nvim" /usr/local/bin/nvim
rm -rf "$tmp"

# --- Nerd Font (en WSL la fuente se instala en Windows con apps.ps1) ----------
if ! $IS_WSL && ! fc-list | grep -qi "JetBrainsMono Nerd"; then
  info "Instalando JetBrainsMono Nerd Font"
  mkdir -p "$HOME/.local/share/fonts/JetBrainsMono"
  curl -fL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" \
    | tar -xJ -C "$HOME/.local/share/fonts/JetBrainsMono"
  fc-cache -f >/dev/null
fi

# --- Enlaces simbólicos --------------------------------------------------------
# Si ya existe un archivo real, se guarda una copia .bak antes de enlazar.
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"
    echo "Copia de seguridad: $dst.bak.*"
  fi
  ln -sfn "$src" "$dst"
  echo "Enlazado: $dst -> $src"
}

info "Enlazando dotfiles"
link "$DOTFILES/nvim"             "$HOME/.config/nvim"
link "$DOTFILES/linux/.tmux.conf" "$HOME/.tmux.conf"
[ -f "$DOTFILES/linux/.bashrc" ] && link "$DOTFILES/linux/.bashrc" "$HOME/.bashrc"

# Asegura ~/.local/bin en el PATH
if ! grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

info "Listo"
echo "Abre una terminal nueva y ejecuta: nvim   (la primera vez descarga los plugins)"
$IS_WSL || echo "Selecciona 'JetBrainsMono Nerd Font' en tu terminal para ver los iconos."
