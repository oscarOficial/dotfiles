--------------------------------------------------
-- OS UTILITIES - Detección de sistema operativo
--------------------------------------------------

local M = {}

-- Detectar el sistema operativo actual
function M.get_os()
  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    return "windows"
  elseif vim.fn.has("mac") == 1 then
    return "macos"
  else
    return "linux"
  end
end

-- Verificar si es Windows
function M.is_windows()
  return M.get_os() == "windows"
end

-- Verificar si es Linux
function M.is_linux()
  return M.get_os() == "linux"
end

-- Verificar si es macOS
function M.is_macos()
  return M.get_os() == "macos"
end

-- Obtener el separador de rutas según el OS
function M.path_separator()
  return M.is_windows() and "\\" or "/"
end

-- Expandir path de forma portable
function M.expand_path(path)
  return vim.fn.expand(path)
end

-- Encontrar ejecutable en el PATH
function M.find_executable(name, alternatives)
  alternatives = alternatives or {}

  -- Intentar el nombre principal
  local exe = vim.fn.executable(name) == 1 and name or nil
  if exe then return exe end

  -- Intentar alternativas
  for _, alt in ipairs(alternatives) do
    exe = vim.fn.executable(alt) == 1 and alt or nil
    if exe then return exe end
  end

  return nil
end

-- Find yazi executable based on operating system
function M.find_yazi()
  local os_type = M.get_os()

  if os_type == "windows" then
    -- En Windows, buscar en paths comunes
    local paths = {
      vim.fn.expand("$LOCALAPPDATA/Programs/yazi/yazi.exe"),
      vim.fn.expand("$PROGRAMFILES/yazi/yazi.exe"),
      "yazi.exe",
      "yazi",
    }
    for _, path in ipairs(paths) do
      if vim.fn.executable(path) == 1 then
        return path
      end
    end
  elseif os_type == "linux" then
    -- En Linux, buscar en paths comunes (snap, local, system)
    local paths = {
      "/snap/bin/yazi",
      vim.fn.expand("~/.local/bin/yazi"),
      "/usr/local/bin/yazi",
      "/usr/bin/yazi",
      "yazi",
    }
    for _, path in ipairs(paths) do
      if vim.fn.executable(path) == 1 then
        return path
      end
    end
  else
    -- macOS
    local paths = {
      "/opt/homebrew/bin/yazi",
      "/usr/local/bin/yazi",
      vim.fn.expand("~/.local/bin/yazi"),
      "yazi",
    }
    for _, path in ipairs(paths) do
      if vim.fn.executable(path) == 1 then
        return path
      end
    end
  end

  -- Fallback: usar 'yazi' del PATH
  return "yazi"
end

-- Find ya executable (yazi CLI helper)
function M.find_ya()
  local os_type = M.get_os()

  if os_type == "windows" then
    local paths = {
      vim.fn.expand("$LOCALAPPDATA/Programs/yazi/ya.exe"),
      vim.fn.expand("$PROGRAMFILES/yazi/ya.exe"),
      "ya.exe",
      "ya",
    }
    for _, path in ipairs(paths) do
      if vim.fn.executable(path) == 1 then
        return path
      end
    end
  else
    -- Linux y macOS
    local paths = {
      vim.fn.expand("~/.local/bin/ya"),
      "/usr/local/bin/ya",
      "/usr/bin/ya",
      "ya",
    }
    for _, path in ipairs(paths) do
      if vim.fn.executable(path) == 1 then
        return path
      end
    end
  end

  return "ya"
end

-- Obtener shell según el sistema operativo
function M.get_shell()
  if M.is_windows() then
    return vim.o.shell or "powershell"
  else
    return vim.o.shell or "bash"
  end
end

-- Obtener archivo de configuración del shell
function M.get_shell_config()
  if M.is_windows() then
    return vim.fn.expand("$USERPROFILE/_vimrc")
  else
    -- Detectar el shell actual
    local shell = vim.o.shell or "bash"
    if shell:match("zsh") then
      return vim.fn.expand("~/.zshrc")
    elseif shell:match("fish") then
      return vim.fn.expand("~/.config/fish/config.fish")
    else
      return vim.fn.expand("~/.bashrc")
    end
  end
end

return M
