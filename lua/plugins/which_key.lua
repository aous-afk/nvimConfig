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
			{ "<leader>bu", "<cmd>Telescope buffers <cr>", desc = "buffers", mode = "n" },
			{ "<leader>e","<cmd>NvimTreeToggle<cr>",desc = "open tree"},
			{
				mode = { "n", "v" }, -- NORMAL and VISUAL mode
				{ "<leader>q", group = "Quit" },
				{ "<leader>qf", "<cmd>q!<cr>", desc = "Quit without save" },
				{ "<leader>qq", "<cmd>q<cr>", desc = "Quit" },
				{ "<leader>qa", "<cmd>wqall<cr>", desc = "Quit and Save all" },
				{ "<leader>w", group = "write" },
				{ "<leader>ww", "<cmd>w<cr>", desc = "Write" },
				{ "<leader>wa", "<cmd>wall<cr>", desc = "Save all" },
				{ "<leader>wq", "<cmd>wq<cr>", desc = "Write and quit" },

				-- Git
				{ "<leader>g", group = "Git" },
				{ "<leader>gl", "<cmd>LazyGit<cr>", desc = "LazyGit" },
				{ "<leader>gi", "<cmd>wall | Neogit<cr>", desc = "open Neogit" },
				{ "<leader>gd", group = "Diffview" },
				{ "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "[o]pen the Diffview" },
				{ "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "[c]lose the Diffview" },
				{ "<leader>gdh", "<cmd>DiffviewFileHistory<cr>", desc = "open file [h]istory" },
				{ "<leader>gd%", "<cmd>DiffviewFileHistory %<cr>", desc = "open current file history" },
			},
			{
				mode = {"n"},
				{ "gs", group = "vim LSP" },
			}
		})
	end
}
