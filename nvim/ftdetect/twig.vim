" Detectar archivos .twig como tipo 'html.twig'
" Twiggy Language Server requiere este formato específico
autocmd BufRead,BufNewFile *.twig set filetype=html.twig
autocmd BufRead,BufNewFile *.twig.html set filetype=html.twig
