return {
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				variant = "default",
				transparent = false,
				saturation = 1,
				italic_comments = false,
				hide_fillchars = false,
				borderless_pickers = false,
				terminal_colors = true,
				cache = false,
				colors = {
					bg = "#161515",
					green = "#00ff00",
					dark = {
						magenta = "#ff00ff",
						fg = "#eeeeee",
					},
					light = {
						red = "#ff5c57",
						cyan = "#5ef1ff",
					},
				},
				extensions = {
					telescope = true,
					cmp = true,
					gitsigns = true,
					whichkey = true,
					treesitter = true,
				},
			})
		end
	},
	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
	{
		"github/copilot.vim",

		config = function()
			vim.keymap.set("i", '<C-Tab>', 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
				desc = "Accept Copilot suggestion"
			})
			vim.g.copilot_no_tab_map = true
			vim.keymap.set('i', '<C-A>', '<Plug>(copilot-accept-word)',
				{ desc = "Accept Copilot suggestion word by word" })
		end
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim"
	}
}
