return {
    {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	build = "make install_jsregexp",
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

		vim.keymap.set({"i"}, "<C-K>",
		function()
			ls.expand() end,
		{silent = true, desc = "LuaSnip: expand snippet" })
		vim.keymap.set({"i", "s"}, "<C-L>",
		function()
			ls.jump(1)
		end,
		{silent = true, desc = "LuaSnip: jump forward" })
		vim.keymap.set({"i", "s"}, "<C-J>",
		function()
			ls.jump(-1) 
		end,
		{silent = true, desc = "LuaSnip: jump backward" })

		vim.keymap.set({"i", "s"}, "<C-s>",
		function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end,
		{silent = true, desc = "LuaSnip: next choice" })
		vim.keymap.set({"i", "s"}, "<C-w>",
		function()
			if ls.choice_active() then
				ls.change_choice(-1)
			end
		end,
		{silent = true, desc = "LuaSnip: previous choice" })
		ls.config.set_config({
			enable_autosnippets = true,
		})
		ls.filetype_extend("javascript", { "jsdoc" })
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
}
