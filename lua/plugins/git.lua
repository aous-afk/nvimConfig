return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",         -- required
			"sindrets/diffview.nvim",        -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua",              -- optional
			"echasnovski/mini.pick",         -- optional
		},
		config = true
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function ()
			require('gitsigns').setup {
				signs = {
					add          = { text = '┃' },
					change       = { text = '┃' },
					delete       = { text = '_' },
					topdelete    = { text = '‾' },
					changedelete = { text = '~' },
					untracked    = { text = '┆' },
				},
				signs_staged = {
					add          = { text = '┃' },
					change       = { text = '┃' },
					delete       = { text = '_' },
					topdelete    = { text = '‾' },
					changedelete = { text = '~' },
					untracked    = { text = '┆' },
				},
				signs_staged_enable = true,
				signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
				numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					follow_files = true
				},
				auto_attach = true,
				attach_to_untracked = false,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
					delay = 500,
					ignore_whitespace = false,
					virt_text_priority = 100,
					use_focus = true,
				},
				current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					border = 'single',
					style = 'minimal',
					relative = 'cursor',
					row = 0,
					col = 1
				},

				on_attach = function(bufnr)
					local gitsigns = require 'gitsigns'

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map('n', ']c', function()
						if vim.wo.diff then
							vim.cmd.normal { ']c', bang = true }
						else
							gitsigns.nav_hunk 'next'
						end
					end, { desc = 'Jump to next git [c]hange' })

					map('n', '[c', function()
						if vim.wo.diff then
							vim.cmd.normal { '[c', bang = true }
						else
							gitsigns.nav_hunk 'prev'
						end
					end, { desc = 'Jump to previous git [c]hange' })

					-- Actions
					-- visual mode
					map('v', '<leader>hs', function()
						gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
					end, { desc = 'git [s]tage hunk' })
					map('v', '<leader>hr', function()
						gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
					end, { desc = 'git [r]eset hunk' })
					-- normal mode
					map('n', '<leader>gss', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
					map('n', '<leader>gsr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
					map('n', '<leader>gsS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
					map('n', '<leader>gsu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
					map('n', '<leader>gsR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
					map('n', '<leader>gsp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
					map('n', '<leader>gsb', gitsigns.blame_line, { desc = 'git [b]lame line' })
					map('n', '<leader>gsd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
					map('n', '<leader>gsD', function()
						gitsigns.diffthis '@'
					end, { desc = 'git [D]iff against last commit' })
					-- Toggles
					map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
					map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
				end,
			}
		end,
	},
	-- Diffview: pin a consistent layout everywhere
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
		dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
		config = function()
			local actions = require("diffview.actions")

			require("diffview").setup({
				-- general toggles
				diff_binaries = false,
				enhanced_diff_hl = false,
				use_icons = true,
				show_help_hints = true,
				watch_index = true,
				view = {
					default = {
						layout = "diff2_horizontal",
						disable_diagnostics = false,
						winbar_info = false,
					},
					merge_tool = {
						layout = "diff3_horizontal",
						disable_diagnostics = true,
						winbar_info = true,
					},
					file_history = {
						layout = "diff2_vertical",
						disable_diagnostics = false,
						winbar_info = false,
					},
				},

				file_panel = {
					listing_style = "tree",
					tree_options = {
						flatten_dirs = true,
						folder_statuses = "only_folded",
					},
					win_config = { position = "right", width = 35 },
				},

				file_history_panel = {
					log_options = {
						git = {
							single_file = { diff_merges = "combined" },
							multi_file  = { diff_merges = "first-parent" },
						},
					},
				},

				keymaps = {
					view = {
						{ "n", "<leader>gde", actions.toggle_files, { desc = "Toggle file panel" } },
					},
				},
			})
		end,
	},

	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	}
}
