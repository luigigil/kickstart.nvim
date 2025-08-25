-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv") -- move selected line up or down
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', 'J', 'mzJ`z') -- join lines

vim.keymap.set('n', '<C-d>', '<C-d>zz') -- scroll while keeping cursor centered
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set('n', 'n', 'nzzzv') -- search while keeping cursor centered
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', '<C-j>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-k>', '<cmd>cprev<CR>zz')

-- greatest remap ever
vim.keymap.set('x', '<leader>p', [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>y', [["+Y]])

vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

vim.keymap.set('n', '<leader>uv', vim.cmd.Oil) -- opens oil

vim.keymap.set('n', 'grs', function()
  vim.api.nvim_command 'vsplit'
  vim.wait(100, function()
    return true
  end)
  vim.api.nvim_command 'normal grd'
end, {})

vim.keymap.set('t', '<C-w><C-k>', '<C-\\><C-N><C-w><C-k>')
vim.keymap.set('t', '<C-c><C-c>', '<C-\\><C-N>')

vim.keymap.set('i', '<C-c>', '<Esc>')

-- Make current file executable
vim.keymap.set('n', '<leader>cx', function()
  local current_file = vim.fn.expand '%'
  vim.fn.system('chmod +x ' .. current_file)
  vim.notify('Made ' .. current_file .. ' executable', vim.log.levels.INFO)
end, { desc = 'Make current file executable' })

vim.keymap.set('n', '<leader>rs', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
