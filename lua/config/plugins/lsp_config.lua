return{
    "neovim/nvim-lspconfig",
    dependencies = {
	"stevearc/conform.nvim",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"j-hui/fidget.nvim",
	"rshkarin/mason-nvim-lint",

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

	require('mason-lspconfig').setup({
	    -- Replace the language servers listed here
	    -- with the ones you want to install
	    ensure_installed = {'lua_ls', 'gopls', 'omnisharp', 'ts_ls', 'eslint', 'angularls','superhtml'},
	    handlers = {
		function(server_name)
		    require('lspconfig')[server_name].setup({})
		end,
	    }
	})

	-- Add cmp_nvim_lsp capabilities settings to lspconfig
	-- This should be executed before you configure any language server
	local lspconfig_defaults = require('lspconfig').util.default_config
	lspconfig_defaults.capabilities = vim.tbl_deep_extend(
	'force',
	lspconfig_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
	)

	-- This is where you enable features that only work
	-- if there is a language server active in the file
	vim.api.nvim_create_autocmd('LspAttach', {
	    desc = 'LSP actions',
	    callback = function(event)
		local opts = {buffer = event.buf}

		vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
		vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
		vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
		vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
		vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
		vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
		vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
		vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
		vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
		vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
	    end,
	})

	require ('mason-nvim-lint').setup({
	    ensure_installed = { 'ast-grep', 'prettier'},
	})

	require("fidget").setup({})
	local cmp = require('cmp')

	cmp.setup({
	    sources = {
		{name = 'nvim_lsp'},
	    },
	    mapping = cmp.mapping.preset.insert({
		-- Navigate between completion items
		['<C-p>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
		['<C-n>'] = cmp.mapping.select_next_item({behavior = 'select'}),
		-- `Enter` key to confirm completion
		['<CR>'] = cmp.mapping.confirm({select = false}),
		-- Ctrl+Space to trigger completion menu
		['<C-Space>'] = cmp.mapping.complete(),

		-- Scroll up and down in the completion documentation
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
	    }),
	    snippet = {
		expand = function(args)
		    vim.snippet.expand(args.body)
		end,
	    },
	})
	vim.diagnostic.config({
	    -- update_in_insert = true,
	    float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	    },
	})
    end

}

