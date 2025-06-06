return {
  'olimorris/codecompanion.nvim',
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = {
          adapter = 'anthropic',
          keymaps = {
            close = {
              modes = {
                n = '<C-x>',
                i = '<C-x>',
              },
              index = 4,
              callback = 'keymaps.close',
              description = 'Close Chat',
            },
          },
        },
        inline = {
          adapter = 'anthropic',
        },
      },
      adapters = {
        opts = {
          show_model_choices = true,
        },
      },
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            show_result_in_chat = true, -- Show mcp tool results in chat
            make_vars = true, -- Convert resources to #variables
            make_slash_commands = true, -- Add prompts as /slash commands
          },
        },
      },
      display = {
        chat = {
          show_settings = false,
        },
      },
    }
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/mcphub.nvim',
  },
}
