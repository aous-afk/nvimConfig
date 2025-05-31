return {
	-- "neovim/nvim-lspconfig",
	-- dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
--		"williamboman/mason-lspconfig.nvim",
	-- 	"hrsh7th/cmp-nvim-lsp",
	-- 	"hrsh7th/cmp-buffer",
	-- 	"hrsh7th/cmp-path",
	-- 	"hrsh7th/cmp-cmdline",
	-- 	"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		-- "saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
--		"rshkarin/mason-nvim-lint",

	-- },
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

-- 		require('mason-lspconfig').setup({
-- 			ensure_installed = {
-- 				'sonarlint-language-server',
-- 				'lua_ls',
-- 				'gopls',
-- 				'csharp_ls',
-- 				'omnisharp',
-- 				'ts_ls',
-- 				'eslint',
-- 				'angularls',
-- 				'superhtml',
-- 				'lemminx'
-- 			},
-- 			handlers = {
-- 				function(server_name)
-- 					require('lspconfig')[server_name].setup({})
-- 				end,
-- 			}
-- 		})
		-- Add cmp_nvim_lsp capabilities settings to lspconfig
		-- This should be executed before you configure any language server
		-- local lspconfig_defaults = require('lspconfig').util.default_config
	-- 	lspconfig_defaults.capabilities = vim.tbl_deep_extend(
	-- 		'force',
	-- 		lspconfig_defaults.capabilities,
	-- 		require('cmp_nvim_lsp').default_capabilities()
	-- 	)

		-- This is where you enable features that only work
		-- if there is a language server active in the file

		require('mason-nvim-lint').setup({
			--ensure_installed = { 'ast-grep', 'prettier'},
		})

		require("fidget").setup({})

		local luasnip = require('luasnip')
		require('luasnip.loaders.from_vscode').lazy_load()
		luasnip.config.setup {}


-- 		local cmp = require('cmp')
-- 
-- 		cmp.setup({
-- 
-- 			snippet = {
-- 				expand = function(args)
-- 					vim.snippet.expand(args.body)
-- 				end,
-- 			},
-- 
-- 			mapping = cmp.mapping.preset.insert({
-- 				-- Navigate between completion items
-- 				['<C-k>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
-- 				['<C-j>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
-- 				-- `Enter` key to confirm completion
-- 				['<CR>'] = cmp.mapping.confirm({ select = false }),
-- 				-- Ctrl+Space to trigger completion menu
-- 				['<C-Space>'] = cmp.mapping.complete(),
-- 
-- 				-- Scroll up and down in the completion documentation
-- 				['<C-u>'] = cmp.mapping.scroll_docs(-4),
-- 				['<C-d>'] = cmp.mapping.scroll_docs(4),
-- 				['<Tab>'] = cmp.mapping(function(fallback)
-- 					if cmp.visible() then
-- 						cmp.select_next_item()
-- 					elseif luasnip.expand_or_jumpable() then
-- 						luasnip.expand_or_jump()
-- 					else
-- 						fallback()
-- 					end
-- 				end, { 'i', 's' }),
-- 				['<S-Tab>'] = cmp.mapping(function(fallback)
-- 					if cmp.visible() then
-- 						cmp.select_prev_item()
-- 					elseif luasnip.jumpable(-1) then
-- 						luasnip.jump(-1)
-- 					else
-- 						fallback()
-- 					end
-- 				end, { 'i', 's' }),
-- 			}),
-- 			sources = cmp.config.sources({
-- 				{ name = 'nvim_lsp' },
-- 				{ name = 'luasnip' },
-- 			}),
-- 		})
-- 		vim.diagnostic.config({
-- 			-- update_in_insert = true,
-- 			float = {
-- 				focusable = false,
-- 				style = "minimal",
-- 				border = "rounded",
-- 				source = "always",
-- 				header = "",
-- 				prefix = "",
-- 			},
-- 		})
 	end

}
