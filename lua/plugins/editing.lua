return {
	{
		"nvim-mini/mini.surround",
		config = function()
			require('mini.surround').setup({
				mappings = {
					add = 'sa', -- Add surrounding in Normal and Visual modes
					delete = 'sd', -- Delete surrounding
					find = 'sf', -- Find surrounding (to the right)
					find_left = 'sF', -- Find surrounding (to the left)
					highlight = 'sh', -- Highlight surrounding
					replace = 'sr', -- Replace surrounding

					suffix_last = 'l', -- Suffix to search with "prev" method
					suffix_next = 'n', -- Suffix to search with "next" method
				},
				custom_surroundings = {
					-- XML/HTML tag  →  saat  wraps with <tag></tag>
					t = {
						input = { '<(%w+)[^>]*>', '</%w+>' },
						output = function()
							local tag = vim.fn.input('Tag: ')
							return { left = '<' .. tag .. '>', right = '</' .. tag .. '>' }
						end,
					},
					-- C# interpolated string  →  sa$  wraps with $"..."
					['$'] = {
						input = { '%$"', '"' },
						output = { left = '$"', right = '"' },
					},
					-- Null-forgiving operator: sa! → expr!
					['!'] = {
						input = { '%S+', '!' },
						output = { left = '', right = '!' },
					},

					-- Null-conditional: sa? → expr?
					['?'] = {
						input = { '%S+', '%?' },
						output = { left = '', right = '?' },
					},

					-- nameof(): saN → nameof(expr)
					['N'] = {
						input = { 'nameof%(', '%)' },
						output = { left = 'nameof(', right = ')' },
					},

					-- typeof(): saT → typeof(expr)
					['T'] = {
						input = { 'typeof%(', '%)' },
						output = { left = 'typeof(', right = ')' },
					},

					-- async Task<>: saA → Task<expr>
					['A'] = {
						input = { 'Task<', '>' },
						output = { left = 'Task<', right = '>' },
					},

					-- List<>: saL → List<expr>
					['L'] = {
						input = { 'List<', '>' },
						output = { left = 'List<', right = '>' },
					},

					-- IEnumerable<>: saE → IEnumerable<expr>
					['E'] = {
						input = { 'IEnumerable<', '>' },
						output = { left = 'IEnumerable<', right = '>' },
					},

					-- Verbatim string: sa@ → @"..."
					['@'] = {
						input = { '%@"', '"' },
						output = { left = '@"', right = '"' },
					},

					-- Raw string literal (C# 11+): sar → """..."""
					['r'] = {
						input = { '"""%s*', '%s*"""' },
						output = { left = '"""', right = '"""' },
					},

					-- Attribute brackets: saB → [expr]  (useful for [Obsolete], [Required] etc)
					['B'] = {
						input = { '%[', '%]' },
						output = { left = '[', right = ']' },
					},
				},
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require('nvim-autopairs').setup({
				check_ts = true,
				fast_wrap = {},
			})
		end,
	}
};
