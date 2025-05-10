local create_ollama_config = function(model)
	return {
		__inherited_from = "openai",
		api_key_name = "",
		endpoint = "http://127.0.0.1:11434/v1",
		model = model,
	}
end

return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
	opts = {
		debug = true,
		provider = "claude",
		claude = {
			endpoint = "https://api.anthropic.com",
			model = "claude-3-7-sonnet-20250219",
			-- model = "claude-3-5-sonnet-20241022",
			timeout = 30000, -- Timeout in milliseconds
			temperature = 0,
			max_tokens = 4096,
			disable_tools = true, -- disable tools!
		},
		-- provider = "deepseek",
		-- provider = "deepseek_R1_1_5b",
		vendors = {
			--@type AvanteProvider
			deepseek_R1_1_5b = create_ollama_config("deepseek-r1:1.5b"),
			deepseek_R1_7b = create_ollama_config("deepseek-r1:7b"),
			deepseek_R1_8b = create_ollama_config("deepseek-r1:8b"),
			deepseekR1_14b = create_ollama_config("deepseek-r1:14b"),
			llama3 = create_ollama_config("llama3.2"),
			deepseek = {
				__inherited_from = "openai",
				api_key_name = "DEEPSEEK_API_KEY",
				endpoint = "https://api.deepseek.com",
				model = "deepseek-coder",
			},
		},
	},
	behaviour = {
		enable_claude_text_editor_tool_mode = true,
	},
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		-- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	-- system_prompt as function ensures LLM always has latest MCP server state
	-- This is evaluated for every message, even in existing chats
	system_prompt = function()
		local hub = require("mcphub").get_hub_instance()
		return hub:get_active_servers_prompt()
	end,
	-- Using function prevents requiring mcphub before it's loaded
	custom_tools = function()
		return {
			require("mcphub.extensions.avante").mcp_tool(),
		}
	end,
	disabled_tools = {
		"list_files", -- Built-in file operations
		"search_files",
		"read_file",
		"create_file",
		"rename_file",
		"delete_file",
		"create_dir",
		"rename_dir",
		"delete_dir",
		"bash", -- Built-in terminal access
	},
}
