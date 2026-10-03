# dotfiles

Configuración compartida entre Windows y Ubuntu (también Ubuntu en WSL).

```
dotfiles/
├── nvim/               Neovim (kickstart.nvim), común a los dos sistemas
│   └── lua/custom/plugins/os.lua   ajustes por sistema (shell, portapapeles WSL)
├── linux/.tmux.conf    tmux (solo Linux/WSL)
├── windows/apps.ps1    instala las aplicaciones en un Windows nuevo
├── install.sh          Ubuntu: instala Neovim, tmux y dependencias, y enlaza la config
└── install.ps1         Windows: enlaza la config
```

## Windows nuevo

PowerShell **como administrador**. Ejecuta cada comando por separado:

```powershell
git clone https://github.com/<tu-usuario>/dotfiles $HOME\dotfiles
cd $HOME\dotfiles
Set-ExecutionPolicy Bypass -Scope Process -Force
.\windows\apps.ps1
```

Después, reinicia el equipo y en Windows Terminal elige la fuente
`JetBrainsMono Nerd Font`.

## Ubuntu / WSL

```bash
git clone https://github.com/<tu-usuario>/dotfiles ~/dotfiles
cd ~/dotfiles && ./install.sh
```

## Día a día

La configuración está enlazada, así que se edita en su sitio (`nvim`, `~/.tmux.conf`)
y el cambio ya está en el repo. Solo falta `git commit` y `git push`.

- Neovim: `:lua vim.pack.update()` actualiza los plugins; sube `nvim/nvim-pack-lock.json`
  para tener las mismas versiones en los dos sistemas.
- tmux: `Ctrl+b r` recarga la configuración.

## Añadir programas

- **Windows:** busca el ID con `winget search nombre` y añádelo a la lista `$apps`
  de `windows/apps.ps1`. Si no está en winget, prueba `choco search nombre` y
  añádelo a la línea de `choco install`.
- **Ubuntu:** añade el paquete a la línea `sudo apt install -y ...` de `install.sh`.
- **Su configuración:** mueve el archivo al repo (`linux/` o `windows/`) y añade
  una línea `link` en `install.sh` o `Link` en `install.ps1`.

## Claves SSH en Windows

Cada equipo tiene su propia clave. Las claves privadas **nunca** van al repo.

1. Elegir el nombre de la clave y crearla (sin administrador):
   ```powershell
   $KEY = "nombre_clave"
   ssh-keygen -t ed25519 -C "nombre-equipo" -f $HOME\.ssh\$KEY
   ```

2. Activar el agente SSH (PowerShell **como administrador**, un comando cada vez):
   ```powershell
   Set-Service ssh-agent -StartupType Automatic
   Start-Service ssh-agent
   ```
   Si no encuentra el servicio, instala el cliente OpenSSH (como administrador):
   `Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0`

3. Cargar la clave en el agente (sin administrador). Pide la frase solo esta vez:
   ```powershell
   ssh-add $HOME\.ssh\$KEY
   ssh-add -l
   ```

4. Indicar a SSH qué clave usar para GitHub, en `$HOME\.ssh\config` (sin extensión).
   Sustituye `nombre_clave` por el nombre real:
   ```
   Host github.com
       HostName github.com
       User git
       IdentityFile ~/.ssh/nombre_clave
       IdentitiesOnly yes
   ```

5. Copiar la clave pública y añadirla en GitHub → Settings → SSH and GPG keys:
   ```powershell
   Get-Content $HOME\.ssh\$KEY.pub | Set-Clipboard
   ```

6. Hacer que Git use el SSH de Windows (para que no pida la frase):
   ```powershell
   git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
   ```

7. Probar la conexión:
   ```powershell
   ssh -T git@github.com
   ```

> La variable `$KEY` solo existe en la ventana de PowerShell donde la defines.
> Si abres otra ventana, vuelve a definirla antes de usar los comandos.

### Problemas frecuentes
- `Permission denied (publickey)`: comprueba con `ssh-add -l` que la clave está cargada, y que el `config` apunta a ella.
- Pide la frase todo el rato: el servicio `ssh-agent` no está en marcha (paso 2), o falta el paso 6.

## Problemas frecuentes en Windows

- **`tree-sitter build` falla buscando `cl.exe`:** falta la variable `CC=gcc`
  (`apps.ps1` ya la crea). A mano:
  `[Environment]::SetEnvironmentVariable("CC", "gcc", "User")`, abre una terminal
  nueva y ejecuta `:TSUpdate` en Neovim.
- **`Set-ExecutionPolicy` da error de parámetro:** ejecútalo solo, en su propia
  línea, y después lanza el script.
