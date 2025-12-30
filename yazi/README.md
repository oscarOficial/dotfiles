# 🗂️ Yazi - Terminal File Manager

Configuración de [Yazi](https://github.com/sxyazi/yazi), un file manager de terminal blazing-fast escrito en Rust.

## 📋 Características

### Linux 🐧
- ✅ Yazi instalado vía snap
- ✅ Plugins bash para búsqueda avanzada (fazif)
- ✅ Búsqueda recursiva con `fd` + `fzf` (keybind: `zf`)
- ✅ Búsqueda por contenido con `ripgrep` + `fzf` (keybind: `zg`)
- ✅ Preview de archivos con `bat`
- ✅ Filtros inteligentes y vim-like navigation

### Windows 🪟
- ✅ Yazi instalado vía winget
- ✅ Funcionalidad básica completa
- ⚠️ Sin plugins bash (no disponibles en Windows nativo)
- ℹ️ Usa búsqueda nativa de Yazi (`/` para buscar)
- 💡 Para plugins avanzados: usar WSL2

## 🚀 Instalación

### Linux/Ubuntu

```bash
cd ~/dotfiles/yazi
./install.sh
```

El script instalará:
1. Yazi (via snap)
2. Dependencias: `fd`, `fzf`, `ripgrep`, `bat`
3. Plugins de Yazi (fazif, jump-to-char, smart-filter)
4. Configuraciones optimizadas

### Windows

```powershell
cd $env:USERPROFILE\dotfiles\yazi
.\install.ps1
```

El script instalará:
1. Yazi (via winget)
2. Configuración básica (sin plugins bash)

**Para usar plugins avanzados en Windows:**
1. Instala [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)
2. Dentro de WSL, ejecuta `./install.sh`

## ⌨️ Keybindings

### Linux - Plugins Avanzados

| Keybind | Acción | Descripción |
|---------|--------|-------------|
| `zf` | Buscar archivos | Búsqueda recursiva con fd + fzf |
| `zg` | Buscar contenido | Buscar dentro de archivos con ripgrep |
| `F` | Filtro inteligente | Filtrado mejorado en directorio actual |
| `f` | Jump to char | Salto vim-like a carácter |

#### Dentro del buscador (`zf`):
- `Ctrl+w` - Buscar archivos en HOME
- `Ctrl+e` - Buscar directorios en HOME
- `Ctrl+t` - Buscar archivos en CWD
- `Alt+c` - Buscar directorios en CWD
- `Ctrl+p` - Toggle preview (derecha/abajo/oculto)
- `Tab` - Seleccionar múltiples archivos

### Windows - Nativos de Yazi

| Keybind | Acción | Descripción |
|---------|--------|-------------|
| `/` | Buscar | Búsqueda nativa por nombre |
| `f` | Filtrar | Filtro en directorio actual |
| `F` | Filtro inteligente | Filtrado mejorado |
| `?` | Ayuda | Mostrar todos los atajos |

### Navegación Común (Ambos sistemas)

| Keybind | Acción |
|---------|--------|
| `h/j/k/l` | Navegación vim-like |
| `Enter` | Entrar a directorio / Abrir archivo |
| `Esc` | Salir / Cancelar |
| `q` | Salir de Yazi |
| `g` | Ir al inicio |
| `G` | Ir al final |
| `Space` | Seleccionar archivo |
| `v` | Selección visual |
| `d` | Borrar |
| `y` | Copiar |
| `p` | Pegar |
| `r` | Renombrar |
| `n` | Nuevo archivo/directorio |

## 📂 Estructura de Archivos

```
yazi/
├── README.md                 # Este archivo
├── install.sh               # Instalador Linux (completo con plugins)
├── install.ps1              # Instalador Windows (básico)
├── yazi.toml                # Configuración principal (común)
├── package.toml             # Lista de plugins (solo Linux)
├── keymap-linux.toml        # Keymaps con plugins bash
├── keymap-windows.toml      # Keymaps nativos (sin bash)
└── plugins/                 # Plugins (solo Linux)
    └── fazif.yazi/          # Plugin de búsqueda avanzada
        ├── main.lua
        ├── faziffd          # Búsqueda de archivos
        ├── fazifrg          # Búsqueda por contenido
        └── fazifrga         # Búsqueda en PDFs
```

## 🛠️ Dependencias

### Linux
- **Yazi** - File manager principal
- **fd** - Búsqueda rápida de archivos
- **fzf** - Fuzzy finder
- **ripgrep (rg)** - Búsqueda por contenido
- **bat** - Preview mejorado de archivos

### Windows
- **Yazi** - File manager principal
- Todo lo demás es opcional (funcionalidad nativa)

## 🔧 Personalización

### Cambiar tema
Edita `yazi.toml`:
```toml
[manager]
# Tus preferencias aquí
```

### Agregar keybindings
- **Linux**: Edita `keymap-linux.toml`
- **Windows**: Edita `keymap-windows.toml`

### Agregar plugins (solo Linux)
1. Agrega el plugin a `package.toml`
2. Ejecuta `ya pack -i`
3. Configura keybindings en `keymap-linux.toml`

## 🐛 Troubleshooting

### Linux

**Problema**: `zf` no funciona
- Verifica que fd y fzf estén instalados: `which fd fzf`
- Verifica que estén en PATH: `echo $PATH | grep .local/bin`
- Agrega a tu `.bashrc` o `.zshrc`:
  ```bash
  export PATH="$HOME/.local/bin:$PATH"
  ```

**Problema**: Preview no se muestra
- Instala bat: `cargo install bat` o descarga desde releases

### Windows

**Problema**: Yazi no se encuentra después de instalar
- Reinicia tu terminal
- Verifica instalación: `winget list yazi`

**Problema**: Quiero usar `zf` y `zg`
- Instala WSL2 y usa el instalador de Linux dentro de WSL

## 📚 Recursos

- [Documentación oficial de Yazi](https://yazi-rs.github.io/)
- [GitHub de Yazi](https://github.com/sxyazi/yazi)
- [Plugin fazif](https://github.com/Shallow-Seek/fazif)
- [Yazi plugins oficiales](https://github.com/yazi-rs/plugins)

## 🔄 Actualización

Para actualizar Yazi y las configuraciones:

```bash
# Linux
cd ~/dotfiles/yazi
git pull
./install.sh

# Windows
cd $env:USERPROFILE\dotfiles\yazi
git pull
.\install.ps1
```

## 📝 Notas

- **Linux**: Instalación completa con todos los plugins
- **Windows**: Instalación básica, funcional pero sin plugins bash
- **WSL**: Para la mejor experiencia en Windows, usa WSL2 + instalación Linux

## 💡 Tips

1. **Usa `zf` frecuentemente**: Es mucho más rápido que navegar manualmente
2. **Preview siempre visible**: Ayuda a identificar archivos rápidamente
3. **Selección múltiple**: Usa `Space` + `Tab` para operaciones en batch
4. **Integración con nvim**: El plugin yazi.nvim ya está configurado (`<leader>e`)

---

**¿Preguntas o problemas?** Abre un issue en el repositorio.
