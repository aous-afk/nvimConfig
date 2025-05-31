require("config.lsp.lua_lsp")
require("config.lsp.csharp_lsp")
require("config.lsp.cmd_nvim")
vim.diagnostic.config({
	virtual_lines = {
		-- Only show virtual line diagnostics for the current cursor line
		current_line = true,
	},
})
