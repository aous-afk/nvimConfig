local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config.csharp_ls = {
			handlers = {
				["textDocument/definition"] = require('csharpls_extended').handler,
				["textDocument/typeDefinition"] = require('csharpls_extended').handler,
			},
			cmd = { "csharp-ls" },
			capabilities = capabilities,
}
