local java_root_files = { 'build.gradle', 'pom.xml', '.git' }

-- Detectar el ejecutable de jdtls según el sistema operativo
local jdtls_bin = "jdtls"
local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin/"

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  -- Windows
  jdtls_bin = mason_bin_path .. "jdtls.cmd"
  if vim.fn.executable(jdtls_bin) ~= 1 then
    jdtls_bin = mason_bin_path .. "jdtls"
  end
else
  -- Linux/macOS
  jdtls_bin = mason_bin_path .. "jdtls"
end

-- Fallback al comando global si no existe en Mason
if vim.fn.executable(jdtls_bin) ~= 1 then
  jdtls_bin = "jdtls"
end

local config = {
  cmd = { jdtls_bin },
  root_dir = vim.fs.dirname(vim.fs.find(java_root_files, { upward = true})[1]),
}

require("jdtls").start_or_attach(config)
