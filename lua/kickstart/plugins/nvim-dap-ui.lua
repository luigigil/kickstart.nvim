return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      dap.configurations.go = {
        {
          type = 'go',
          name = 'Attach to server',
          request = 'attach',
          mode = 'local',
          -- Use dap.utils.pick_process for native process selection
          processId = require('dap.utils').pick_process,
        },
      }

      require('dapui').setup()
      require('dap-go').setup {
        delve = {
          initialize_timeout_sec = 130,
        },
      }

      require('nvim-dap-virtual-text').setup()

      vim.keymap.set('n', '<space>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<space>gb', dap.run_to_cursor)

      vim.keymap.set('n', '<space>?', function()
        require('dapui').eval(nil, { enter = true })
      end)

      vim.keymap.set('n', '<F1>', dap.continue)
      vim.keymap.set('n', '<F2>', dap.step_into)
      vim.keymap.set('n', '<F3>', dap.step_over)
      vim.keymap.set('n', '<F4>', dap.step_out)
      vim.keymap.set('n', '<F5>', dap.step_back)
      vim.keymap.set('n', '<F7>', dap.terminate)
      vim.keymap.set('n', '<F8>', dap.restart)
      vim.keymap.set('n', '<F9>', ui.toggle)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.open()
      end
    end,
  },
}
