return {
  'pwntester/octo.nvim',
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('octo').setup {
      use_local_fs = true,
      reviews = {
        auto_show_threads = false,
      },
    }
    vim.keymap.set('n', '<leader>vt', function()
      require('octo.reviews.thread-panel').show_review_threads(true)
    end, { desc = 'view thread' })
  end,
}
