return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		local kind_icons = {
			Text = "",
			Method = "󰆧",
			Function = "󰊕",
			Constructor = "",
			Field = "󰇽",
			Variable = "󰂡",
			Class = "󰠱",
			Interface = "",
			Module = "",
			Property = "󰜢",
			Unit = "",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "󰏘",
			File = "󰈙",
			Reference = "",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰏿",
			Struct = "",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "󰅲",
		}

		local cmp = require('cmp')
		local luasnip = require'luasnip'
		cmp.setup({
 			snippet = {
 				expand = function(args)
 					vim.snippet.expand(args.body)
 				end,
			},

			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			mapping = cmp.mapping.preset.insert({
				-- Navigate between completion items
 				['<C-k>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
 				['<C-j>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
 				-- `Enter` key to confirm completion
 				['<CR>'] = cmp.mapping.confirm({ select = false }),
 				-- Ctrl+Space to trigger completion menu
 				['<C-Space>'] = cmp.mapping.complete(),

 				-- Scroll up and down in the completion documentation
 				['<C-u>'] = cmp.mapping.scroll_docs(-4),
 				['<C-d>'] = cmp.mapping.scroll_docs(4),
 				['<Tab>'] = cmp.mapping(function(fallback)
 					if cmp.visible() then
 						cmp.select_next_item()
 					elseif luasnip.expand_or_jumpable() then
 						luasnip.expand_or_jump()
 					else
 						fallback()
 					end
 				end, { 'i', 's' }),
 				['<S-Tab>'] = cmp.mapping(function(fallback)
 					if cmp.visible() then
 						cmp.select_prev_item()
 					elseif luasnip.jumpable(-1) then
 						luasnip.jump(-1)
 					else
 						fallback()
 					end
 				end, { 'i', 's' }),
			}),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'path'	},
			},
			{
				{ name = 'buffer' },
			}),
			formatting = {
				format = function(entry, vim_item)
					vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						luasnip  = "[Snippet]",
						buffer   = "[Buffer]",
					})[entry.source.name]
					return vim_item
				end,
			},
		})
		cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = 'path' }
			}, {
				{
					name = 'cmdline',
					option = {
						ignore_cmds = { 'Man', '!' }
					}
				}
			})
		})
		cmp.setup.cmdline('/', {
			mapping = cmp.mapping.preset.cmdline(),
			view = {
				entries = {name = 'wildmenu', separator = '|' }
			},
			sources = {
				{ name = 'buffer' }
			}
		})
	end
}
