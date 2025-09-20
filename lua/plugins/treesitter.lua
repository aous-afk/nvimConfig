vim.cmd [[
hi @lsp.type.variable.cs guifg=LightBlue
hi @lsp.type.extensionMethodName.cs guifg=LightYellow
]]
return {
    {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"LiadOz/nvim-dap-repl-highlights",
	},
	build = ":TSUpdate",
	config = function ()
		require('nvim-dap-repl-highlights').setup()
	    require('nvim-treesitter.configs').setup ({
		ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "typescript","javascript", "c_sharp","superhtml", "css", "json", "yaml", "dap_repl" },
		auto_install = true,
		highlight = {
		    enable = true,
		    disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
			    return true
			end
		    end,
		    additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true
		}

	    })

	end
    }
}
