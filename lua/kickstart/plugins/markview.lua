return {
  'OXY2DEV/markview.nvim',
  lazy = false, -- Recommended
  ft = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },

  dependencies = {
    -- "nvim-treesitter/nvim-treesitter",
    'nvim-tree/nvim-web-devicons',
    'saghen/blink.cmp',
  },
  opts = {
    preview = {
      filetypes = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
    },
    max_length = 99999,
  },
}
