return{
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = 'modern',
	},
	triggers = {
		{ "<leader>", mode = { "n" } },
	},
	layout = { align = 'center' },
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
	config = function (_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.add({
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
			{ "<leader>b", group = "buffers", expand = function()
				return require("which-key.extras").expand.buf()
			end},
			{ "<leader>e","<cmd>NvimTreeToggle<cr>",desc = "open tree"},
			{
				mode = { "n", "v" }, -- NORMAL and VISUAL mode
				{ "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
				{ "<leader>w", group = "write" },
				{ "<leader>ww", "<cmd>w<cr>", desc = "Write" },
				{ "<leader>wq", "<cmd>wq<cr>", desc = "Write and quit" },
				{ "<leader>gi", "<cmd>Neogit<cr>", desc = "open Neogit" },
			}
		})
	end
}
