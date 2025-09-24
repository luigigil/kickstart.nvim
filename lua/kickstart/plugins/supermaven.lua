return {
  'supermaven-inc/supermaven-nvim',
  cond = vim.env.WORK ~= '1',
  opts = {
    keymaps = {
      accept_suggestion = '<C-l>',
      clear_suggestion = '<C-]>',
      accept_word = '<C-j>',
    },
  },
  keys = {
    {
      -- start
      '<leader>Ss',
      function()
        require('supermaven-nvim.api').start()
      end,
      mode = 'n',
      desc = '[S]upermaven start',
    },
    -- pause
    {
      '<leader>Sp',
      function()
        require('supermaven-nvim.api').stop()
      end,
      mode = 'n',
      desc = '[S]upermaven pause',
    },
    -- toggle
    {
      '<leader>St',
      function()
        require('supermaven-nvim.api').toggle()
      end,
      mode = 'n',
      desc = '[S]upermaven toggle',
    },
  },
}
