local function sln_name(msg)
   ---@type string[]
   local t={}
   for str in string.gmatch(msg, '([^'..'/'..']+)') 
    do
    table.insert(t, str)
    end
   return t
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"j-hui/fidget.nvim",
		"Decodetalkers/csharpls-extended-lsp.nvim",
	},
	config = function()
		require('mason').setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		require('mason-tool-installer').setup {
			ensure_installed = {

				{ 'bash-language-server', auto_update = true },
				{ 'gopls', condition = function() return vim.fn.executable('go') == 1  end },
				'lua-language-server',
				'vim-language-server',
				'sonarlint-language-server'
			},

			integrations = {
				['mason-nvim-dap'] = true,
				['nvim-lint'] =true
			},
		}
		local capabilities = require('cmp_nvim_lsp').default_capabilities()
		local config = {
			handlers = {
				["textDocument/definition"] = require('csharpls_extended').handler,
				["textDocument/typeDefinition"] = require('csharpls_extended').handler,
			},
			cmd = { "csharp-ls" },
            capabilities = capabilities,
		}
		require'lspconfig'.csharp_ls.setup(config)


		require("csharpls_extended").buf_read_cmd_bind()
		require("fidget").setup(
			{
				-- Options related to LSP progress subsystem
				progress = {
					poll_rate = 0,                -- How and when to poll for progress messages
					suppress_on_insert = false,   -- Suppress new messages while in insert mode
					ignore_done_already = false,  -- Ignore new tasks that are already complete
					ignore_empty_message = false, -- Ignore new tasks that don't contain a message
					clear_on_detach =             -- Clear notification group when LSP server detaches
					function(client_id)
						local client = vim.lsp.get_client_by_id(client_id)
						return client and client.name or nil
					end,
					notification_group =          -- How to get a progress message's notification group key
					function(msg) return msg.lsp_client.name end,
					ignore = {},                  -- List of LSP servers to ignore

					-- Options related to how LSP progress messages are displayed as notifications
					display = {
						render_limit = 16,          -- How many LSP messages to show at once
						done_ttl = 3,               -- How long a message should persist after completion
						done_icon = "✔",            -- Icon shown when all LSP progress tasks are complete
						done_style = "Constant",    -- Highlight group for completed LSP tasks
						progress_ttl = 10,   -- How long a message should persist when in progress
						progress_icon =             -- Icon shown when LSP progress tasks are in progress
						{ "dots" },
						progress_style =            -- Highlight group for in-progress LSP tasks
						"WarningMsg",
						group_style = "Title",      -- Highlight group for group name (LSP server name)
						icon_style = "Question",    -- Highlight group for group icons
						priority = 30,              -- Ordering priority for LSP notification group
						skip_history = true,        -- Whether progress notifications should be omitted from history
						format_message = function (msg)
							if string.find(msg.title, "indexing") then
								return nil -- ignore "indexing..." progress messages
							end
							if string.find(msg.title, ".sln") then
								return "Loading solution "
							end
							if msg.message then
								return msg.message
							else
								return msg.done and "Completed" or "In progress..."
							end
						end,
						format_annote =             -- How to format a progress annotation
						function(msg)
							if string.find(msg.title, ".sln") then
								local index = (# sln_name(msg.title))
								return  sln_name(msg.title)[index]
							end
						return msg.title
						end,
						format_group_name =         -- How to format a progress notification group's name
						function(group) return tostring(group) end,
					},

					-- Options related to Neovim's built-in LSP client
					lsp = {
						progress_ringbuf_size = 0,  -- Configure the nvim's LSP progress ring buffer size
						log_handler = false,        -- Log `$/progress` handler invocations (for debugging)
					},
				},

				-- Options related to notification subsystem
				notification = {
					poll_rate = 10,               -- How frequently to update and render notifications
					filter = vim.log.levels.INFO, -- Minimum notifications level
					history_size = 128,           -- Number of removed messages to retain in history
					override_vim_notify = true,  -- Automatically override vim.notify() with Fidget
					configs =                     -- How to configure notification groups when instantiated
					{ default = require("fidget.notification").default_config },
					redirect =                    -- Conditionally redirect notifications to another backend
					function(msg, level, opts)
						if opts and opts.on_open then
							return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
						end
					end,

					-- Options related to how notifications are rendered as text
					view = {
						stack_upwards = true,       -- Display notification items from bottom to top
						icon_separator = " ",       -- Separator between group name and icon
						group_separator = "---",    -- Separator between notification groups
						group_separator_hl =        -- Highlight group used for group separator
						"Comment",
						render_message =            -- How to render notification messages
						function(msg, cnt)
							return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
						end,
					},

					-- Options related to the notification window and buffer
					window = {
						normal_hl = "Comment",      -- Base highlight group in the notification window
						winblend = 100,             -- Background color opacity in the notification window
						border = "rounded",            -- Border around the notification window
						zindex = 45,                -- Stacking priority of the notification window
						max_width = 0,              -- Maximum width of the notification window
						max_height = 0,             -- Maximum height of the notification window
						x_padding = 1,              -- Padding from right edge of window boundary
						y_padding = 0,              -- Padding from bottom edge of window boundary
						align = "bottom",           -- How to align the notification window
						relative = "editor",        -- What the notification window position is relative to
					},
				},

				-- Options related to integrating with other plugins
				integration = {
					["nvim-tree"] = {
						enable = true,              -- Integrate with nvim-tree/nvim-tree.lua (if installed)
					},
					["xcodebuild-nvim"] = {
						enable = true,              -- Integrate with wojciech-kulik/xcodebuild.nvim (if installed)
					},
				},

				-- Options related to logging
				logger = {
					level = vim.log.levels.WARN,  -- Minimum logging level
					max_size = 10000,             -- Maximum log file size, in KB
					float_precision = 0.01,       -- Limit the number of decimals displayed for floats
					path =                        -- Where Fidget writes its logs to
					string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
				},
			}
		)
	end
}
