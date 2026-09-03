-- Resolves the commit hash under cursor in a fugitive `:Git log`/`:Git show` buffer.
-- fugitive#Cfile() alone only works on oneline formats or the exact "commit <hash>"
-- line; the fallback searches upward so it also works from Author/Date/message lines
-- in the default multi-line `git log` and `git log --stat -p` formats.
local function commit_under_cursor()
  local cfile = vim.fn['fugitive#Cfile']()
  local hash = cfile:match '//(%x%x%x%x%x%x%x+)$'
  if hash then
    return hash
  end
  for i = vim.fn.line '.', 1, -1 do
    local h = vim.fn.getline(i):match '^commit%s+(%x+)'
    if h then
      return h
    end
  end
  return nil
end

return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory', 'DiffviewRefresh' },
  keys = {
    { '<leader>gv', '<cmd>DiffviewOpen<cr>', desc = 'Diffview: working tree changes (side-by-side, editable)' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diffview: current file history' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = 'Diffview: repo history' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Diffview: close' },
  },
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'git', 'fugitive' },
      desc = 'Diffview: commit-under-cursor keymap for fugitive log/show/status buffers',
      callback = function(ev)
        vim.keymap.set('n', '<leader>gV', function()
          local hash = commit_under_cursor()
          if not hash then
            vim.notify('No commit found under cursor', vim.log.levels.WARN)
            return
          end
          vim.cmd('DiffviewOpen ' .. hash .. '^!')
        end, { buffer = ev.buf, desc = 'Diffview: open commit under cursor (side-by-side)' })
      end,
    })
  end,
}
