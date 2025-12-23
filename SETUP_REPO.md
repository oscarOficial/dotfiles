# 🚀 Instrucciones para Subir a GitHub

## 📋 Pasos para Crear el Repositorio

### 1. Inicializar Git en el Directorio Local

```bash
cd ~/dotfiles

# Inicializar repositorio git
git init

# Agregar todos los archivos
git add .

# Crear primer commit
git commit -m "Initial commit: Neovim portable configuration"
```

### 2. Crear Repositorio en GitHub

1. Ve a: https://github.com/new
2. Nombre del repositorio: `dotfiles`
3. Descripción: `🏠 My personal development environment configuration files (Neovim, Zsh, Tmux, etc.)`
4. Visibilidad: **Public** (o Private si prefieres)
5. **NO** inicialices con README, .gitignore o licencia (ya los tenemos)
6. Click en "Create repository"

### 3. Conectar Repositorio Local con GitHub

```bash
# Agregar remote origin
git remote add origin https://github.com/oscarOficial/dotfiles.git

# Renombrar branch a main si es necesario
git branch -M main

# Subir al repositorio
git push -u origin main
```

### 4. Verificar

Visita: https://github.com/oscarOficial/dotfiles

Deberías ver:
- ✅ README.md con el banner y descripción
- ✅ Carpeta `nvim/` con toda la configuración
- ✅ Scripts de instalación
- ✅ Licencia MIT
- ✅ .gitignore

## 🔄 Workflow de Actualización

### Hacer Cambios en la Configuración Actual

1. **Edita tu configuración de Neovim normalmente:**
   ```bash
   nvim ~/.config/nvim/init.lua
   ```

2. **Los cambios se reflejan automáticamente en ~/dotfiles/nvim/** (porque es un symlink)

3. **Commitea y pushea los cambios:**
   ```bash
   cd ~/dotfiles
   git status
   git add .
   git commit -m "Descripción de los cambios"
   git push
   ```

### Instalar en una Nueva Máquina

```bash
# Linux/Ubuntu
git clone https://github.com/oscarOficial/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh

# Windows
git clone https://github.com/oscarOficial/dotfiles.git $env:USERPROFILE\dotfiles
cd $env:USERPROFILE\dotfiles
.\install.ps1
```

## 📝 Recomendaciones

### 1. Agregar Topics al Repo

En GitHub, ve a Settings → Topics y agrega:
- `dotfiles`
- `neovim`
- `nvim`
- `linux`
- `windows`
- `portable`
- `lua`
- `lsp`

### 2. Agregar Badges al README

Puedes agregar badges como:
```markdown
![Neovim](https://img.shields.io/badge/Neovim-0.9+-green.svg)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)
```

### 3. GitHub Actions (Opcional)

Podrías agregar un workflow para:
- Verificar sintaxis de Lua
- Probar instalación en diferentes sistemas
- Auto-generar documentación

### 4. Capturas de Pantalla

Agrega screenshots en `docs/screenshots/`:
```bash
# Tomar screenshot de Neovim
nvim
# Presiona PrintScreen o usa un screenshot tool
# Guarda en: ~/dotfiles/docs/screenshots/nvim-main.png
```

Luego agrégalas al README.

## 🎯 Comandos Git Útiles

```bash
# Ver cambios
git status
git diff

# Agregar archivos específicos
git add nvim/lua/plugins/nueva-configuracion.lua

# Commit con mensaje descriptivo
git commit -m "feat(nvim): add new plugin for X"

# Push
git push

# Ver historial
git log --oneline --graph

# Crear branch para experimentar
git checkout -b experiment/new-feature
git push -u origin experiment/new-feature
```

## 🔧 Convenciones de Commits (Opcional)

Usar conventional commits:

- `feat(nvim):` - Nueva característica
- `fix(nvim):` - Corrección de bug
- `docs:` - Documentación
- `refactor(nvim):` - Refactorización
- `chore:` - Mantenimiento

Ejemplos:
```bash
git commit -m "feat(nvim): add yazi file manager integration"
git commit -m "fix(nvim): correct path detection on Windows"
git commit -m "docs: update installation instructions"
```

## 📦 Siguientes Pasos

Una vez que el repo esté en GitHub:

1. **Compartir en la Comunidad:**
   - r/neovim en Reddit
   - Twitter/X con hashtag #neovim
   - Dev.to article

2. **Expandir Dotfiles:**
   - Agregar configuración de Zsh/Bash
   - Agregar Tmux configuration
   - Agregar Git config (.gitconfig)
   - Agregar terminal config (Alacritty, WezTerm)

3. **Documentar más:**
   - Crear guías en `docs/guides/`
   - Agregar video de demo
   - Crear troubleshooting guide

## 🎉 ¡Listo!

Una vez que hayas hecho `git push`, tu configuración estará:
- ✅ Versionada
- ✅ Respaldada en la nube
- ✅ Lista para compartir
- ✅ Sincronizable entre máquinas

---

**Recuerda:** Este archivo (SETUP_REPO.md) es solo para tu referencia. Puedes eliminarlo después de subir el repo si quieres.
