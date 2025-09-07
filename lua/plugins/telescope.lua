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
		local telescope = require("telescope")
		local themes = require("telescope.themes")
		local action_layout = require("telescope.actions.layout")

		telescope.setup({
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
						["<esc>"] = actions.close,
						["<C-u>"] = false,
						["<c-d>"] = actions.delete_buffer + actions.move_to_top,
						["<M-p>"] = action_layout.toggle_preview,
					},
					n={
						["<M-p>"] = action_layout.toggle_preview
					},
				}
			},

   pickers = {
        find_files = { theme = "ivy" },
        -- Example: give LSP references a bottom list with preview
        lsp_references = {
          theme = "ivy",
          show_line = false,
          fname_width = 60,
          trim_text = true,
          layout_config = { height = 15 },
        },
      },

      -- Extensions config
      extensions = {
        fzf = {
          fuzzy = true,
          case_mode = "smart_case",
        },

        -- Telescope-powered vim.ui.select with special styling for code actions
        ["ui-select"] = {
          themes.get_dropdown({
            previewer = false,
            prompt_title = "Select",
			      layout_config = { height = 10 },
          }),
          specific_opts = {
            codeactions = themes.get_cursor({
              previewer = false,
              prompt_title = "Code Action",
			      layout_config = { height = 10 },
            }),
            -- some servers use singular
            codeaction = themes.get_cursor({
              previewer = false,
              prompt_title = "Code Action",
			      layout_config = { height = 10 },
            }),
          },
        },

        -- Neoclip UI inside Telescope
        neoclip = {
          prompt_title = "Clipboard",
          theme = "dropdown",
          previewer = false,
          layout_strategy = "cursor",
          layout_config = { width = 0.6, height = 0.4 },
          path_display = { "truncate" },
          initial_mode = "insert",
          -- mappings = {
          --   i = {
          --     ["<CR>"] = require("neoclip.telescope").actions.select,
          --     ["<C-p>"] = require("neoclip.telescope").actions.paste,
          --     ["<C-b>"] = require("neoclip.telescope").actions.paste_behind,
          --     ["<C-q>"] = require("neoclip.telescope").actions.replay,
          --     ["<C-d>"] = require("neoclip.telescope").actions.delete,
          --     ["<C-e>"] = require("neoclip.telescope").actions.edit,
          --   },
          --   n = {
          --     ["<CR>"] = require("neoclip.telescope").actions.select,
          --     ["p"]    = require("neoclip.telescope").actions.paste,
          --     ["P"]    = require("neoclip.telescope").actions.paste_behind,
          --     ["q"]    = require("neoclip.telescope").actions.replay,
          --     ["d"]    = require("neoclip.telescope").actions.delete,
          --     ["e"]    = require("neoclip.telescope").actions.edit,
          --   },
          -- },
        },
      },
    })

		require("neoclip").setup({
			history = 200,
			enable_persistent_history = false, -- set true if you add sqlite.lua
			continuous_sync = true,
			length_limit = 1048576,
			enable_macro_history = true,
			default_register = '"',
			default_register_macros = "q",
			content_spec_column = true,
			on_select = { move_to_front = true, close_telescope = true },
			on_paste  = { set_reg = false, move_to_front = true, close_telescope = true },
			on_replay = { set_reg = false, move_to_front = true, close_telescope = true },
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
