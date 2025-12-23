-- General Keymaps	
vim.keymap.set('n', '<leader>r', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>R', ':restart<CR>', { nowait=true})
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')

-- Window navigation with Ctrl+h/j/k/l
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = 'Move to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = 'Move to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = 'Move to right window' })

-- Create and close windows
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>sh', ':split<CR>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>sc', '<C-w>c', { desc = 'Close current window' })
vim.keymap.set('n', '<leader>so', '<C-w>o', { desc = 'Close all except current' })

--- Copy messages to temp buffer
vim.keymap.set('n', '<leader>M', function()
  vim.cmd('new | put =execute("messages") | setlocal buftype=nofile bufhidden=wipe noswapfile')
end, { desc = "Open :messages in buffer" })

-- Re-apply navigation keymaps after all plugins load
-- to prevent them from being overwritten
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = 'Move to left window' })
    vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = 'Move to lower window' })
    vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = 'Move to upper window' })
    vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = 'Move to right window' })
  end,
})
