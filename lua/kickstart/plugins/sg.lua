-- Use your favorite package manager to install, for example in lazy.nvim
--  Optionally, you can also install nvim-telescope/telescope.nvim to use some search functionality.
return {
  {
    'sourcegraph/sg.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim', --[[ "nvim-telescope/telescope.nvim ]]
    },

    -- If you have a recent version of lazy.nvim, you don't need to add this!
    build = 'nvim -l build/init.lua',
    keys = {
      {
        '<leader>sS',
        function()
          require('sg.extensions.telescope').fuzzy_search_results()
        end,
        mode = 'n',
        desc = 'Search [S]ourcegraph',
      },
    },
  },
}
