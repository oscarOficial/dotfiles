# Configuración de Neovim Portable (Windows + Linux/Ubuntu)

Configuración completa y portable de Neovim con soporte para desarrollo PHP (Laravel), JavaScript/TypeScript, Lua, Java, Twig y más.

## 📋 Características

- ✅ **100% Portable**: Funciona en Windows y Linux/Ubuntu sin cambios
- 🚀 **Instalación automática**: Scripts de instalación para ambos sistemas
- 🎨 **Colorscheme**: Kanagawa
- 📦 **Plugin Manager**: lazy.nvim
- 🔍 **Fuzzy Finder**: Telescope con preview
- 🗂️ **File Manager**: Yazi integrado
- 💻 **LSP completo**: Intelephense (PHP), TypeScript, Lua, Java, Twig, JSON
- ✨ **Autocompletado**: nvim-cmp con múltiples sources
- 🌳 **Treesitter**: Syntax highlighting avanzado
- 📊 **Statusline**: Lualine con breadcrumbs (nvim-navic)
- 🎯 **Navegación**: Harpoon, Marks, Oil

## 🔧 Requisitos

### Linux/Ubuntu

- Ubuntu 20.04+ (o distribución basada en Debian)
- Conexión a internet
- Permisos sudo (para instalación)

### Windows

- Windows 10/11
- PowerShell 5.1+
- winget (Windows Package Manager)

## 📥 Instalación Automática

### Linux/Ubuntu

```bash
# 1. Clonar o copiar la configuración
git clone <tu-repo> ~/.config/nvim
# O si ya tienes la configuración:
# cp -r /ruta/a/nvim ~/.config/

# 2. Ejecutar el instalador
cd ~/.config/nvim
chmod +x install.sh
./install.sh

# 3. Reiniciar la terminal o ejecutar:
source ~/.bashrc  # o ~/.zshrc si usas zsh

# 4. Iniciar Neovim
nvim
```

### Windows

```powershell
# 1. Abrir PowerShell como Administrador

# 2. Clonar o copiar la configuración
# La configuración debe estar en: $env:LOCALAPPDATA\nvim
# Ejemplo:
git clone <tu-repo> $env:LOCALAPPDATA\nvim
# O copiar manualmente la carpeta

# 3. Navegar al directorio
cd $env:LOCALAPPDATA\nvim

# 4. Ejecutar el instalador
.\install.ps1

# 5. Reiniciar PowerShell

# 6. Iniciar Neovim
nvim
```

## 🛠️ Instalación Manual

Si prefieres instalar manualmente, sigue estos pasos:

### Linux/Ubuntu

```bash
# Dependencias básicas
sudo apt update
sudo apt install -y build-essential git curl

# Neovim (versión 0.9+)
sudo apt install -y neovim
# O desde PPA para versión más reciente:
# sudo add-apt-repository ppa:neovim-ppa/unstable
# sudo apt update && sudo apt install neovim

# Node.js (para LSP servers)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Herramientas CLI
sudo apt install -y ripgrep fd-find bat

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --bin
ln -sf ~/.fzf/bin/fzf ~/.local/bin/fzf

# Yazi
sudo snap install yazi
# O descargar binario:
# curl -L https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip -o /tmp/yazi.zip
# unzip /tmp/yazi.zip -d /tmp
# cp /tmp/yazi-x86_64-unknown-linux-gnu/{yazi,ya} ~/.local/bin/
```

### Windows

```powershell
# Instalar winget si no lo tienes:
# https://aka.ms/getwinget

# Neovim
winget install Neovim.Neovim

# Git
winget install Git.Git

# Node.js
winget install OpenJS.NodeJS.LTS

# Python (opcional)
winget install Python.Python.3.12

# Herramientas CLI
winget install BurntSushi.ripgrep.MSVC
winget install sharkdp.fd
winget install sharkdp.bat
winget install junegunn.fzf

# Yazi (descarga manual)
# Descargar desde: https://github.com/sxyazi/yazi/releases
# Extraer a: $env:LOCALAPPDATA\Programs\yazi
# Agregar al PATH
```

## 📦 Dependencias Instaladas

### Obligatorias

| Herramienta | Propósito | Linux | Windows |
|------------|-----------|-------|---------|
| Neovim | Editor | ✅ | ✅ |
| Git | Control de versiones + lazy.nvim | ✅ | ✅ |
| Node.js | LSP servers (TypeScript, etc.) | ✅ | ✅ |
| build-essential/gcc | Compilar plugins nativos | ✅ | ✅* |

\* En Windows se instala via MSYS2

### Recomendadas

| Herramienta | Propósito | Linux | Windows |
|------------|-----------|-------|---------|
| ripgrep (rg) | Búsqueda rápida en Telescope | ✅ | ✅ |
| fd | Búsqueda de archivos | ✅ | ✅ |
| bat | Preview con syntax highlighting | ✅ | ✅ |
| fzf | Fuzzy finder para yazi | ✅ | ✅ |
| yazi + ya | File manager integrado | ✅ | ✅ |

### LSP Servers (instalados automáticamente vía Mason)

- **intelephense**: PHP, Blade, Twig
- **lua_ls**: Lua
- **ts_ls**: TypeScript/JavaScript
- **jsonls**: JSON con schemas
- **twiggy_language_server**: Twig templates
- **jdtls**: Java

## 🎯 Uso Rápido

### Keymaps Principales

#### General
- `<Space>`: Leader key
- `<Space>e`: Abrir Yazi (file manager)
- `<Space>E`: Abrir Yazi en directorio actual
- `<Space>w`: Guardar archivo
- `<Space>q`: Cerrar ventana

#### Navegación entre ventanas
- `Ctrl+h`: Ventana izquierda
- `Ctrl+j`: Ventana inferior
- `Ctrl+k`: Ventana superior
- `Ctrl+l`: Ventana derecha

#### Telescope (Búsqueda)
- `<Space>ff`: Buscar archivos
- `<Space>fg`: Live grep (buscar en contenido)
- `<Space>fb`: Buscar en buffers
- `<Space>fh`: Buscar en historial
- `<Space>fc`: Buscar en configuración de nvim

#### LSP
- `gd`: Ir a definición
- `gr`: Ver referencias
- `K`: Mostrar documentación
- `<Space>ca`: Code actions
- `<Space>rn`: Renombrar símbolo
- `<Space>f`: Formatear código

#### Harpoon (Navegación rápida)
- `<Space>a`: Agregar archivo a harpoon
- `<Space>h`: Mostrar menú de harpoon
- `<Space>1-5`: Ir a archivo marcado

#### Yazi (dentro de yazi en nvim)
- `Ctrl+f`: Buscar archivos con fzf + preview
- `zf`: Búsqueda rápida sin preview

## 📂 Estructura del Proyecto

```
~/.config/nvim/          # Linux
$env:LOCALAPPDATA\nvim\  # Windows

├── init.lua             # Punto de entrada
├── install.sh           # Instalador para Linux
├── install.ps1          # Instalador para Windows
├── README.md            # Este archivo
├── lazy-lock.json       # Lock file de plugins
├── lua/
│   ├── config/
│   │   ├── filetypes.lua
│   │   ├── highlights.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   ├── options.lua
│   │   └── telescope-highlight-fix.lua
│   ├── plugins/         # 31+ plugins
│   │   ├── yazi.lua
│   │   ├── lualine.lua
│   │   ├── telescope.lua
│   │   ├── cmp.lua
│   │   ├── lspconfig.lua
│   │   └── ...
│   └── utils/
│       └── os.lua       # Detección de sistema operativo
└── ftplugin/
    ├── java.lua
    ├── json.lua
    └── twig.lua
```

## 🔄 Actualización

```bash
# Linux
cd ~/.config/nvim
git pull

# Windows
cd $env:LOCALAPPDATA\nvim
git pull
```

Luego abre Neovim y ejecuta `:Lazy sync` para actualizar plugins.

## 🐛 Solución de Problemas

### Linux

**Problema**: yazi no se encuentra después de instalar
```bash
# Verificar si está en el PATH
echo $PATH | grep -o '.local/bin'

# Agregar al PATH si no está
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Problema**: fd/bat no se encuentran
```bash
# En Ubuntu, fd y bat se instalan como fdfind y batcat
# El script crea symlinks automáticamente, pero si no:
ln -s $(which fdfind) ~/.local/bin/fd
ln -s $(which batcat) ~/.local/bin/bat
```

**Problema**: LSP servers no se instalan
```bash
# Abrir Mason en nvim y verificar
nvim
:Mason
# Presiona 'i' para instalar manualmente
```

### Windows

**Problema**: "nvim: command not found" después de instalar
```powershell
# Reiniciar PowerShell completamente
# O agregar manualmente al PATH del usuario
```

**Problema**: yazi no se encuentra
```powershell
# Verificar si está en el PATH
$env:PATH -split ';' | Select-String yazi

# Agregar manualmente al PATH si es necesario
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
[Environment]::SetEnvironmentVariable("Path", "$userPath;$env:LOCALAPPDATA\Programs\yazi", "User")
```

**Problema**: Error compilando plugins nativos
```powershell
# Instalar MSYS2 y gcc
winget install MSYS2.MSYS2
# Luego en MSYS2:
pacman -S mingw-w64-x86_64-gcc
```

## 📝 Notas

### Portabilidad

La configuración usa el módulo `lua/utils/os.lua` para detectar automáticamente el sistema operativo y ajustar paths en consecuencia. No necesitas cambiar nada manualmente.

### Mason

Los LSP servers, linters y formatters se instalan automáticamente vía Mason al abrir archivos del tipo correspondiente. La primera vez puede tomar unos minutos.

### Lazy.nvim

Los plugins se instalan automáticamente la primera vez que abres Neovim. Verás una ventana con el progreso de instalación.

## 🤝 Contribuir

Si encuentras algún problema o tienes sugerencias:

1. Abre un issue
2. Envía un pull request
3. Comparte tu feedback

## 📄 Licencia

Esta configuración es de código abierto y está disponible bajo la licencia MIT.

## 🙏 Créditos

Basado en las mejores prácticas de la comunidad de Neovim y utilizando plugins increíbles de la comunidad.

### Plugins Principales

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Autocompletado
- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP installer
- [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) - File manager
- [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) - Colorscheme
- Y muchos más...

---

**¡Feliz coding! 🚀**
