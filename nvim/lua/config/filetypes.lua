-- Detección de tipos de archivo personalizados

vim.filetype.add({
  extension = {
    twig = "twig",
  },
  pattern = {
    [".*%.twig%.html"] = "twig",
    [".*%.html%.twig"] = "twig",
  },
})
