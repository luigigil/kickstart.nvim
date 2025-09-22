return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
  keys = {
    {
      '<leader>uv',
      '<cmd>Oil<CR>',
      mode = 'n',
      desc = 'Oil',
    },
    {
      '<leader>us',
      '<cmd>Oil ' .. vim.env.SECOND_BRAIN .. '<CR>',
      mode = 'n',
      desc = 'Vault',
    },
  },
}
