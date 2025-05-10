return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup()
    -- REQUIRED

    vim.keymap.set('n', '<leader>fa', function()
      harpoon:list():add()
    end, { desc = 'Add file' })

    vim.keymap.set('n', '<leader>fh', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle menu' })

    vim.keymap.set('n', '<leader>fj', function()
      harpoon:list():select(1)
    end, { desc = 'Select file 1' })

    vim.keymap.set('n', '<leader>fk', function()
      harpoon:list():select(2)
    end, { desc = 'Select file 2' })
    vim.keymap.set('n', '<leader>ff', function()
      harpoon:list():select(3)
    end, { desc = 'Select file 3' })
    vim.keymap.set('n', '<leader>fd', function()
      harpoon:list():select(4)
    end, { desc = 'Select file 4' })
  end,
}
