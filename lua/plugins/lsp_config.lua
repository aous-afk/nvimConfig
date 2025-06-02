return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
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
		require("fidget").setup({})
	end
}
