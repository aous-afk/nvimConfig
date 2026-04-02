return {
	handlers = {
		["textDocument/definition"] = require('csharpls_extended').handler,
		["textDocument/typeDefinition"] = require('csharpls_extended').handler,
	},
	cmd = { "csharp-ls" },
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
}
