
return { {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
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
				{ 'gopls',                condition = function() return vim.fn.executable('go') == 1 end },
				'lua-language-server',
				'vim-language-server',
				'sonarlint-language-server',
				'angular-language-server',
				'shellcheck'
			},

			integrations = {
				['mason-nvim-dap'] = true,
				['nvim-lint'] = true
			},
		}
		require("csharpls_extended").buf_read_cmd_bind()
	end
},
	-- -- Autoformat
	-- {
	-- 	"stevearc/conform.nvim",
	-- 	event = { "BufWritePre" },
	-- 	cmd = { "ConformInfo" },
	-- 	keys = {
	-- 		{
	-- 			"<leader>f",
	-- 			function()
	-- 				require("conform").format({ async = true, lsp_format = "fallback" })
	-- 			end,
	-- 			mode = "",
	-- 			desc = "[F]ormat buffer",
	-- 		},
	-- 	},
	-- 	opts = {
	-- 		notify_on_error = false,
	-- 		format_on_save = function(bufnr)
	-- 			-- Disable "format_on_save lsp_fallback" for languages that don't
	-- 			-- have a well standardized coding style. You can add additional
	-- 			-- languages here or re-enable it for the disabled ones.
	-- 			local disable_filetypes = { c = true, cpp = true }
	-- 			if disable_filetypes[vim.bo[bufnr].filetype] then
	-- 				return nil
	-- 			else
	-- 				return {
	-- 					timeout_ms = 500,
	-- 					lsp_format = "fallback",
	-- 				}
	-- 			end
	-- 		end,
	-- 		formatters_by_ft = {
	-- 			lua = { "stylua" },
	-- 			-- Conform can also run multiple formatters sequentially
	-- 			python = { "isort", "black" },
	-- 			typescript = { "eslint_d", stop_after_first = true },
	-- 			typescriptreact = { "eslint_d" },
	-- 			javascript = { "eslint_d" },
	-- 			javascriptreact = { "eslint_d" },
	-- 			html = { "eslint_d" },
	-- 			--
	-- 			-- You can use 'stop_after_first' to run the first available formatter from the list
	-- 			-- javascript = { "prettierd", "prettier", stop_after_first = true },
	-- 		},
	-- 	},
	-- }
}
