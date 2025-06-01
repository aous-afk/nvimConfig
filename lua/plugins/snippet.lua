return {
    {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	dependencies = {
	    "rafamadriz/friendly-snippets",
	    "benfowler/telescope-luasnip.nvim",
	},

	config = function()
	    local ls = require("luasnip")
	    local s = ls.snippet
	    local t = ls.text_node
	    local i = ls.insert_node
	    local extras = require("luasnip.extras")
	    local rep = extras.rep
	    local fmt = require("luasnip.extras.fmt").fmt
	    local c = ls.choice_node
		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})
		-- Yes, we're just executing a bunch of Vimscript, but this is the officially
		-- endorsed method; see https://github.com/L3MON4D3/LuaSnip#keymaps
		vim.cmd[[
		" Use Tab to expand and jump through snippets
		imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
		smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

		" Use Shift-Tab to jump backwards through snippets
		imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
		smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
		]]

		ls.config.set_config({ -- Setting LuaSnip config

			-- Enable autotriggered snippets
			enable_autosnippets = true,

			-- Use Tab (or some other key if you prefer) to trigger visual selection
			store_selection_keys = "<Tab>",
		})

	    ls.filetype_extend("javascript", { "jsdoc" })

	    vim.keymap.set({"i"}, "<C-s>e", function() ls.expand() end, {silent = true})

	    vim.keymap.set({"i", "s"}, "<C-s>;", function() ls.jump(1) end, {silent = true})
	    vim.keymap.set({"i", "s"}, "<C-s>,", function() ls.jump(-1) end, {silent = true})

	    vim.keymap.set({"i", "s"}, "<C-E>", function()
		if ls.choice_active() then
		    ls.change_choice(1)
		end
	    end, {silent = true})

	    vim.api.nvim_set_keymap("i", "<C-s>", "<Plug>luasnip-next-choice", {})
	    vim.api.nvim_set_keymap("s", "<C-s>", "<Plug>luasnip-next-choice", {})
	    vim.api.nvim_set_keymap("i", "<C-w>", "<Plug>luasnip-prev-choice", {})
	    vim.api.nvim_set_keymap("s", "<C-w>", "<Plug>luasnip-prev-choice", {})

	    -- example
	    -- snippets for md
	    -- ls.add_snippets("markdown", {
	    --     s({
	    --         trig = "link",
	    --         name = "trigger link",
	    --         desc = "will create syntx for links",
	    --     }, {
	    --         t('{'),
	    --         i(1),
	    --         t('}('),
	    --         i(2),
	    --         t(')')
	    --     }),
	    -- })
	    ls.add_snippets("all", {
		s("{",{
		    t('{'),
		    i(1),
		    t('}')
		})
	    })
	    ls.add_snippets("all", {
		s("(",{
		    t('('),
		    i(1),
		    t(')')
		})
	    })
	    ls.add_snippets("all", {
		s("[",{
		    t('['),
		    i(1),
		    t(']')
		})
	    })
	    ls.add_snippets("all", {
		s("q",{
		    t("'"),
		    i(1),
		    t("'")
		})
	    })
	    ls.add_snippets("all", {
		s("dq",{
		    t('"'),
		    i(1),
		    t('"')
		})
	    })

	    ls.add_snippets("gitcommit", {
		s("cm",
		    fmt([[ [{}] {} ]],{
			c(1, {
            		    t("DEV"),
            		    t("TST"),
            		    t("REP"),
            		}),
            		i(2),
		})),
	    })
	end,
    },

	{
		'saghen/blink.cmp',
		-- optional: provides snippets for the snippet source
		dependencies = { 'rafamadriz/friendly-snippets' , { 'L3MON4D3/LuaSnip', version = 'v2.*' } },

		-- use a release tag to download pre-built binaries
		version = '1.*',
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap


			snippets = { preset = 'luasnip' },
			keymap = { preset = 'default' },

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = 'mono'
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = false } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" }
		},
		opts_extend = { "sources.default" }
	}
}
