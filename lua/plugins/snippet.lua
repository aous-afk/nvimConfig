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

		vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
		vim.keymap.set({"i", "s"}, "<C-L>",
		function()
				ls.jump(1)
		end,
		{silent = true})
		vim.keymap.set({"i", "s"}, "<C-J>", function()
				ls.jump(-1)
		end,
		{silent = true})

		vim.keymap.set({"i", "s"}, "<C-s>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end, {silent = true})
		vim.keymap.set({"i", "s"}, "<C-w>", function()
			if ls.choice_active() then
				ls.change_choice(-1)
			end
		end, {silent = true})
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
