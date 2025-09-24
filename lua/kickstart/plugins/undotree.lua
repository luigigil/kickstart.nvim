return {
  'mbbill/undotree',
  keys = {
    {
      '<leader>ut',
      vim.cmd.UndotreeToggle,
      mode = 'n',
      desc = '[U]ndo Tree',
    },
  },
}
