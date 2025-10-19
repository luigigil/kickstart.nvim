-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'luigi/todoist.nvim',
    dir = vim.env.HOME .. '/projects/todoist.nvim',
    config = function()
      require('todoist').setup {
        some_param = 'this is my param',
        force_sync = false,
      }
    end,
  },
}
