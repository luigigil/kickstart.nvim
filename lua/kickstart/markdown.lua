-- Markdown-specific settings
local M = {}

M.setup = function()
  -- Create an autocommand group for markdown settings
  vim.api.nvim_create_augroup('MarkdownSettings', { clear = true })

  -- Set textwidth for markdown files (doesn't change the file, just for display)
  vim.api.nvim_create_autocmd('FileType', {
    group = 'MarkdownSettings',
    pattern = 'markdown',
    callback = function()
      -- Set the text width to 80 chars (this is just for display in the buffer)
      vim.opt_local.textwidth = 80

      -- Enable soft word wrap at the 80 char mark
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
      vim.opt_local.breakindent = true

      -- This adds visual indicators for the soft wrapped lines
      vim.opt_local.showbreak = '↪ '

      -- Optional: Add a colorcolumn to show the 80 char boundary
      vim.opt_local.colorcolumn = '80'
    end,
  })

  -- Add markdown to the conform.nvim formatter list
  local ok, conform = pcall(require, 'conform')
  if ok then
    local formatters_by_ft = conform.formatters_by_ft
    if formatters_by_ft then
      formatters_by_ft.markdown = { 'prettier' }
    end
  end
end

return M

