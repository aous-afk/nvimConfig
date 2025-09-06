return {
	"nvim-telescope/telescope.nvim",

	tag = "0.1.8",

	dependencies = {
		"nvim-lua/plenary.nvim",
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		{'nvim-telescope/telescope-ui-select.nvim' },
		{"AckslD/nvim-neoclip.lua"}
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
						["<C-s>"] = function(bufnr)
							require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = nil
							return require("telescope.actions").preview_scrolling_down(bufnr)
						end,
						["<C-w>"] = function(bufnr)
							require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = nil
							return require("telescope.actions").preview_scrolling_up(bufnr)
						end,
						["<C-e>"] = function(bufnr)
							require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = 1
							return require("telescope.actions").preview_scrolling_down(bufnr)
						end,
						["<C-y>"] = function(bufnr)
							require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = 1
							return require("telescope.actions").preview_scrolling_up(bufnr)
						end,
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
				fzf = {},
				['ui-select'] = {
					require('telescope.themes').get_dropdown(),
				},
				neoclip ={},
				-- undo = {
				-- 	use_delta = true,
				-- 	use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
				-- 	side_by_side = false,
				-- 	vim_diff_opts = { ctxlen = vim.o.scrolloff },
				-- 	entry_format = "state #$ID, $STAT, $TIME",
				-- 	mappings = {
				-- 		i = {
				-- 			["<C-cr>"] = require("telescope-undo.actions").yank_additions,
				-- 			["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
				-- 			["<cr>"] = require("telescope-undo.actions").restore,
				-- 		},
				-- 	},
				-- },
			}
		})
		require('telescope').load_extension('fzf')
		require("telescope").load_extension("neoclip")
		-- to resume the last search
		-- vim.keymap.set('n', '<leader>fr', builtin.resume, {})
		require("telescope").load_extension("csharpls_definition")
		require("telescope").load_extension("ui-select")

		-- init dotnet engine after telescope
		require("features.dotnet.startup").setup({
			build_cfg = "Debug",
			icon = "",
		})
	end
}
