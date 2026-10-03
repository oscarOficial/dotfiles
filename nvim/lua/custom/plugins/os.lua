-- Ajustes según el sistema operativo.
-- Todo lo demás de la configuración es común a Windows y Ubuntu.

local is_windows = vim.fn.has 'win32' == 1
local is_wsl = vim.fn.has 'wsl' == 1

if is_windows then
  -- Usar PowerShell 7 como shell de :terminal y :!comandos
  if vim.fn.executable 'pwsh' == 1 then
    vim.o.shell = 'pwsh'
    vim.o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
      .. '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.o.shellquote = ''
    vim.o.shellxquote = ''
  end
end

if is_wsl then
  -- Portapapeles compartido con Windows desde WSL
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = { ['+'] = 'clip.exe', ['*'] = 'clip.exe' },
    paste = {
      ['+'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
