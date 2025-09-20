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
				width = 45,
				relativenumber = true
			},
			on_attach = function(bufnr)
				local api = require('nvim-tree.api')

				api.config.mappings.default_on_attach(bufnr)
				local function opts(desc)
					return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				vim.keymap.set('n', 'A', function()
					local node = api.tree.get_node_under_cursor()
					local path = node.type == "directory" and node.absolute_path or vim.fs.dirname(node.absolute_path)
					require("easy-dotnet").create_new_item(path)
				end, opts('Create file from dotnet template'))
				vim.keymap.set('n', 'l',  api.node.navigate.sibling.next,        opts('next sibling'))
				vim.keymap.set('n', 'h',  api.node.navigate.parent,  opts('Up'))
				vim.keymap.set('n', 'v',  api.node.open.vertical,    opts('Open: Vertical Split'))
				vim.keymap.set('n', 's',  api.node.open.horizontal,  opts('Open: Horizontal Split'))
			end,
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
