return {
  {
    'pwntester/octo.nvim',
    cond = not vim.env.WORK,
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('octo').setup {
        use_local_fs = true,
      }
    end,
  },
  {
    'octo.custom.nvim',
    dir = vim.fn.stdpath 'config' .. '/lua/custom/plugins/octo.custom.nvim',
    cond = vim.env.WORK,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('octo').setup {
        use_local_fs = true,
      }
    end,
  },
}
