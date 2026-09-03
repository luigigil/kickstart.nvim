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

      require('dapui').setup {
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.2 },
              { id = 'breakpoints', size = 0.2 },
              { id = 'stacks', size = 0.2 },
              { id = 'watches', size = 0.2 },
              { id = 'repl', size = 0.2 },
            },
            size = 60,
            position = 'left',
          },
          {
            elements = { 'console' },
            size = 10,
            position = 'bottom',
          },
        },
      }
      require('dap-go').setup {
        delve = {
          initialize_timeout_sec = 130,
        },
      }

      -- nvim-dap hardcodes all output events (program stdout/stderr) to the
      -- REPL buffer (dap/session.lua Session:event_output). Redirect them to
      -- the dapui console instead so REPL stays free for interactive eval.
      dap.defaults.fallback.on_output = function(_, body)
        if body.category == 'telemetry' then
          return
        end
        local bufnr = ui.elements.console.buffer()
        local text = (body.output or ''):gsub('\r\n', '\n')
        local lines = vim.split(text, '\n')
        local last = vim.api.nvim_buf_line_count(bufnr)
        vim.bo[bufnr].modifiable = true
        if last == 0 then
          vim.api.nvim_buf_set_lines(bufnr, 0, 0, true, lines)
        else
          local last_line = vim.api.nvim_buf_get_lines(bufnr, last - 1, last, true)[1]
          vim.api.nvim_buf_set_text(bufnr, last - 1, #last_line, last - 1, #last_line, lines)
        end
        vim.bo[bufnr].modifiable = false
      end

      -- A project with its own .vscode/launch.json owns its Go debug configs;
      -- drop the generic attach/${file} defaults so dap.continue() runs exactly
      -- what the project defines (no config picker, no ${file}-based fallback).
      if vim.uv.fs_stat(vim.fn.getcwd() .. '/.vscode/launch.json') then
        dap.configurations.go = {}
      end

      require('nvim-dap-virtual-text').setup()

      vim.keymap.set('n', '<space>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<space>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Conditional Breakpoint' })
      vim.keymap.set('n', '<space>H', function()
        dap.set_breakpoint(nil, vim.fn.input 'Hit condition (e.g. > 5, % 3, == 10): ')
      end, { desc = 'Debug: Hit-Condition Breakpoint' })
      vim.keymap.set('n', '<space>gb', dap.run_to_cursor, { desc = 'Debug: Run to Cursor' })
      vim.keymap.set('n', '<space>lb', function()
        dap.list_breakpoints(true)
      end, { desc = 'Debug: List Breakpoints (quickfix)' })

      vim.keymap.set('n', '<space>?', function()
        require('dapui').eval(nil, { enter = true })
      end, { desc = 'Debug: Eval Under Cursor' })

      -- F5/F1/F2/F3/F7 match kickstart.nvim's stock debug.lua convention
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Continue' })
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<F7>', ui.toggle, { desc = 'Debug: Toggle UI' })

      vim.keymap.set('n', '<F6>', dap.pause, { desc = 'Debug: Pause' })
      vim.keymap.set('n', '<F8>', dap.restart, { desc = 'Debug: Restart' })
      vim.keymap.set('n', '<F9>', dap.terminate, { desc = 'Debug: Terminate' })

      dap.listeners.after.event_initialized.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
