return {
  'zbirenbaum/copilot.lua',
  cond = vim.env.WORK == '1',
  lazy = true,
  cmd = 'Copilot',
  config = function()
    require('copilot').setup {
      auth_provider_url = 'https://github.cbhq.net/',
    }
  end,
}
