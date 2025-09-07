return{
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function ()
		require("nvim-tree").setup({
			diagnostics = {
				enable = false,
				show_on_dirs = false,
				show_on_open_dirs = true,
				debounce_delay = 500,
				severity = {
					min = vim.diagnostic.severity.HINT,
					max = vim.diagnostic.severity.ERROR,
				},
				icons = {
					hint = "",
					info = "",
					warning = "",
					error = "",
				},
			},
			git = {
				enable = true,
			},
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 30,
				relativenumber = true,
			},
			renderer = {
				indent_markers = {
					enable = true,
					inline_arrows = true,
					icons = {
						corner = "└",
						edge = "│",
						item = "│",
						bottom = "─",
						none = " ",
					},
				},
				highlight_git = true,
				group_empty = true,
			},
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
		})
		vim.cmd([[
		:hi      NvimTreeExecFile    guifg=#ffa0a0
		:hi      NvimTreeSpecialFile guifg=#ff80ff gui=underline
		:hi      NvimTreeSymlink     guifg=Yellow  gui=italic
		:hi link NvimTreeImageFile   Title
		]])
	end
}
