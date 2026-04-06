vim.cmd [[
hi @lsp.type.variable.cs guifg=LightBlue
hi @lsp.type.extensionMethodName.cs guifg=LightYellow
]]
return {
	-- {
	--        "nvim-treesitter/nvim-treesitter-textobjects",
	--        lazy = false,  -- force it to load at startup
	--    },
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"LiadOz/nvim-dap-repl-highlights",
			"nvim-treesitter/nvim-treesitter-textobjects",
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
				},
				-- textobjects = {
				-- 	select = {
				-- 		enable = true,
				-- 		lookahead = true, -- jump forward to next textobj automatically
				-- 		keymaps = {
				-- 			["af"] = "@function.outer", -- select whole method
				-- 			["if"] = "@function.inner", -- select method body only
				-- 			["ac"] = "@class.outer",    -- select whole class
				-- 			["ic"] = "@class.inner",    -- select class body
				-- 			["aa"] = "@parameter.outer",-- select parameter incl. comma
				-- 			["ia"] = "@parameter.inner",-- select parameter only
				-- 		},
				-- 	},
				-- 	move = {
				-- 		enable = true,
				-- 		set_jumps = true, -- adds to jumplist, so <C-o> goes back
				-- 		goto_next_start = {
				-- 			["]m"] = "@function.outer", -- next method
				-- 			["]c"] = "@class.outer",    -- next class
				-- 		},
				-- 		goto_prev_start = {
				-- 			["[m"] = "@function.outer", -- prev method
				-- 			["[c"] = "@class.outer",    -- prev class
				-- 		},
				-- 	},
				-- },

			})
			require('nvim-treesitter-textobjects').setup()
			local sel = require('nvim-treesitter-textobjects.select')

			local maps = {
				{ 'af', '@function.outer', 'Select outer function' },
				{ 'if', '@function.inner', 'Select inner function' },
				{ 'ac', '@class.outer',    'Select outer class' },
				{ 'ic', '@class.inner',    'Select inner class' },
				{ 'aa', '@parameter.outer','Select outer parameter' },
				{ 'ia', '@parameter.inner','Select inner parameter' },
			}

			for _, map in ipairs(maps) do
				vim.keymap.set({ 'x', 'o' }, map[1], function()
					sel.select_textobject(map[2], 'textobjects')
				end, { desc = map[3] })
			end
		end
	},
	-- {
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	-- branch = "main",
	-- 	-- init = function()
	-- 	-- 	vim.g.no_plugin_maps = true
	-- 	-- end,
	-- }
}
