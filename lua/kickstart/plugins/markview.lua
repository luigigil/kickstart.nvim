return {
  'OXY2DEV/markview.nvim',
  lazy = false, -- Recommended
  ft = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },

  -- For `nvim-treesitter` users.
  priority = 49,

  config = function()
    local presets = require 'markview.presets'

    require('markview').setup {
      preview = {
        filetypes = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
      },
      max_length = 99999,
      markdown = {
        headings = presets.headings.glow,
      },
    }

    require('markview.extras.checkboxes').setup {
      --- Default checkbox state(used when adding checkboxes).
      ---@type string
      default = 'X',

      --- Changes how checkboxes are removed.
      ---@type
      ---| "disable" Disables the checkbox.
      ---| "checkbox" Removes the checkbox.
      ---| "list_item" Removes the list item markers too.
      remove_style = 'disable',

      --- Various checkbox states.
      ---
      --- States are in sets to quickly change between them
      --- when there are a lot of states.
      ---@type string[][]
      states = {
        { ' ', '/', 'X' },
        { '<', '>' },
        { '?', '!', '*' },
        { '"' },
        { 'l', 'b', 'i' },
        { 'S', 'I' },
        { 'p', 'c' },
        { 'f', 'k', 'w' },
        { 'u', 'd' },
      },
    }
  end,

  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'saghen/blink.cmp',
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
    {
      '<leader>mct',
      '<cmd>Checkbox toggle<CR>',
      mode = 'n',
      desc = '[M]arkdown [c]heckbox [t]oggle',
    },
    {
      '<leader>mci',
      '<cmd>Checkbox interactive<CR>',
      mode = 'n',
      desc = '[M]arkdown [c]heckbox [i]nteractive',
    },
  },
}
