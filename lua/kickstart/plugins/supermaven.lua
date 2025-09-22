return {
  'supermaven-inc/supermaven-nvim',
  config = function()
    require('supermaven-nvim').setup {
      keymaps = {
        accept_suggestion = '<C-Tab>',
        clear_suggestion = '<C-]>',
        accept_word = '<C-j>',
      },
    }
  end,
  cond = vim.env.WORK ~= '1',
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
