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
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
		vim.keymap.set('n', '<C-p>', builtin.git_files, {})
		vim.keymap.set('n', '<leader>pws', function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set('n', '<leader>pWs', function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end)
		vim.keymap.set('n', '<leader>ps', function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
		vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
		-- to resume the last search
		-- vim.keymap.set('n', '<leader>fr', builtin.resume, {})
		require("telescope").load_extension("csharpls_definition")
	end
}
