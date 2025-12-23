# 🏠 Dotfiles de Oscar

Configuración personal de herramientas de desarrollo para Windows y Linux.

## 📦 Contenido

### [Neovim](./nvim/)

Configuración completa de Neovim con soporte para:
- PHP (Laravel), JavaScript/TypeScript, Lua, Java, Twig
- LSP completo (Intelephense, TypeScript, Lua, Java)
- Autocompletado, Fuzzy finder, File manager integrado
- **100% Portable** entre Windows y Linux

[Ver documentación completa de Neovim →](./nvim/README.md)

### Próximamente

- [ ] Zsh/Bash configuration
- [ ] Tmux configuration
- [ ] Git configuration
- [ ] Terminal (Alacritty/WezTerm) configuration

## 🚀 Instalación Rápida

### Linux/Ubuntu

```bash
# Clonar el repositorio
git clone https://github.com/oscarOficial/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Instalar Neovim y todas las dependencias
./install.sh
```

### Windows

```powershell
# Clonar el repositorio
git clone https://github.com/oscarOficial/dotfiles.git $env:USERPROFILE\dotfiles
cd $env:USERPROFILE\dotfiles

# Instalar Neovim y todas las dependencias
.\install.ps1
```

## 📋 Instalación Manual por Componente

Si prefieres instalar solo ciertas configuraciones:

### Neovim

```bash
# Linux
cd ~/dotfiles/nvim
./install.sh

# Windows
cd $env:USERPROFILE\dotfiles\nvim
.\install.ps1
```

## 🛠️ Requisitos

### Linux/Ubuntu

- Ubuntu 20.04+ (o distribución basada en Debian)
- Git
- Curl
- Permisos sudo

### Windows

- Windows 10/11
- PowerShell 5.1+
- Git
- winget (Windows Package Manager)

## 📂 Estructura del Repositorio

```
dotfiles/
├── README.md                 # Este archivo
├── LICENSE                   # Licencia MIT
├── install.sh               # Instalador principal (Linux)
├── install.ps1              # Instalador principal (Windows)
├── nvim/                    # Configuración de Neovim
│   ├── README.md            # Documentación de Neovim
│   ├── install.sh           # Instalador de Neovim (Linux)
│   ├── install.ps1          # Instalador de Neovim (Windows)
│   ├── init.lua             # Configuración principal
│   └── lua/                 # Módulos Lua
│       ├── config/
│       ├── plugins/
│       └── utils/
└── docs/                    # Documentación adicional
    ├── screenshots/
    └── guides/
```

## 🔄 Actualización

Para actualizar las configuraciones:

```bash
# Linux
cd ~/dotfiles
git pull
./install.sh

# Windows
cd $env:USERPROFILE\dotfiles
git pull
.\install.ps1
```

## 🎨 Screenshots

### Neovim

*(Agrega aquí capturas de pantalla de tu setup)*

## 🤝 Contribuir

Si encuentras algún problema o tienes sugerencias, siéntete libre de:

1. Abrir un [issue](https://github.com/oscarOficial/dotfiles/issues)
2. Enviar un pull request
3. Compartir tu feedback

## 📝 Notas

### Filosofía

Estas configuraciones siguen estos principios:

- ✅ **Portabilidad**: Funcionan en Windows y Linux sin cambios
- ✅ **Automatización**: Todo se instala con un comando
- ✅ **Minimalismo**: Solo lo esencial, sin bloat
- ✅ **Documentación**: Todo está documentado
- ✅ **Comunidad**: Basado en las mejores prácticas

### Inspiración

Este repositorio está inspirado en:
- [craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public)
- [ThePrimeagen/.dotfiles](https://github.com/ThePrimeagen/.dotfiles)
- [jesseduffield/dotfiles](https://github.com/jesseduffield/dotfiles)

## 📄 Licencia

MIT License - siéntete libre de usar y modificar como quieras.

## 👤 Autor

**Oscar** - [@oscarOficial](https://github.com/oscarOficial)

---

**¡Feliz coding! 🚀**

<sub>Si encuentras útil este repositorio, considera darle una ⭐</sub>
