return {
  'OXY2DEV/markview.nvim',
  lazy = false, -- Recommended
  ft = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },

  -- For `nvim-treesitter` users.
  priority = 49,

  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'saghen/blink.cmp',
  },
  opts = {
    preview = {
      filetypes = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
    },
    max_length = 99999,
  },
  keys = {
    {
      '<leader>mt',
      function()
        require('markview').commands['toggle']()
      end,
      mode = 'n',
      desc = '[M]arkview toggle',
    },
    {
      '<leader>ms',
      function()
        require('markview').commands['splitToggle']()
      end,
      mode = 'n',
      desc = '[M]arkview [s]plit toggle',
    },
  },
}
