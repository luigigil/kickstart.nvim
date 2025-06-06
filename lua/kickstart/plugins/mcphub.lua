return {
  'ravitemer/mcphub.nvim',
  build = 'npm install -g mcp-hub@latest',
  config = function()
    require('mcphub').setup {
      config = vim.fn.expand '/Users/luigigil/.config/mcphub/servers.json', -- Config file path
    }
  end,
}
