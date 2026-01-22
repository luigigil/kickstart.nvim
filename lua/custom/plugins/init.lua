-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'luigi/todoist.nvim',
    dir = vim.env.HOME .. '/projects/todoist.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('todoist').setup {
        -- some_param = 'this is my param',
        -- force_sync = false,
        sync_on_load = true,
        filters = {
          'today',
          'tomorrow',
          'overdue',
          '@work',
          '@urgent',
        },
        telescope = {
          layout_strategy = 'vertical',
          layout_config = { width = 0.8 },
        },
      }
    end,
  },
}
