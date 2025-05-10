return {
	"olimorris/codecompanion.nvim",
	config = function()
		require("codecompanion").setup({
			strategies = {
				chat = {
					adapter = "anthropic",
					keymaps = {
						close = {
							modes = {
								n = "<C-x>",
								i = "<C-x>",
							},
							index = 4,
							callback = "keymaps.close",
							description = "Close Chat",
						},
					},
				},
				inline = {
					adapter = "anthropic",
				},
			},
			adapters = {
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						schema = {
							model = {
								default = "claude-3-7-sonnet-20250219",
								-- default = "claude-3-5-sonnet-20241022",
							},
						},
					})
				end,
			},
		})
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
}
