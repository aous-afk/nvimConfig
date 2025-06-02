return {
	"nvim-telescope/telescope.nvim",

	tag = "0.1.8",

	dependencies = {
		"nvim-lua/plenary.nvim",
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
	},

	config = function()
		local actions = require("telescope.actions")
		require('telescope').setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i={
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-c>"] = actions.close,
					},
					n={},
				}
			},
			pickers = {
				find_files = {
					theme = "ivy"
				}
			},
			extentions = {
				fzf = {}
			}
		})
		require('telescope').load_extension('fzf')
		-- to resume the last search
		-- vim.keymap.set('n', '<leader>fr', builtin.resume, {})
		require("telescope").load_extension("csharpls_definition")
	end
}
