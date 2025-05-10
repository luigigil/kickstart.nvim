-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Make .env files highlighted as sh
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '.env*' },
  command = 'set filetype=sh',
})

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  command = 'res -15',
})

-- Load markdown-specific settings
-- require('kickstart.markdown').setup()

