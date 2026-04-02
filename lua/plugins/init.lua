return {
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("cyberdream").setup({
				variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
				-- Reduce the overall saturation of colours for a more muted look
				saturation = 1, -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)
				-- Enable italics comments
				italic_comments = true,
				-- Replace all fillchars with ' ' for the ultimate clean look
				hide_fillchars = false,
				-- Set terminal colors used in `:terminal`
				terminal_colors = true,
				-- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
				cache = false,
				overrides = function(colors)
					return {
						["@property"] = { fg = colors.magenta, bold = true },
					}
				end,

				-- Override colors
				colors = { green = "#00ff00" },
				-- Disable or enable colorscheme extensions
				extensions = {
					telescope = true,
					notify = true,
					mini = true,
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

		config = function ()
			vim.notify("Copilot activated", vim.log.levels.INFO, { title = "Copilot" })
			vim.keymap.set("i", '<C-Tab>','copilot#Accept("\\<CR>")',{
				expr = true,
				replace_keycodes = false,
				desc = "Accept Copilot suggestion"
			})
			vim.g.copilot_no_tab_map = true
			vim.keymap.set('i', '<C-A>', '<Plug>(copilot-accept-word)', { desc = "Accept Copilot suggestion word by word" })
		end
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim"
	}
}
