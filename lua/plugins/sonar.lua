return{

	url = 'https://gitlab.com/schrieveslaach/sonarlint.nvim',
	ft = { 'javascript', 'typescript', 'cs' },
	config = function ()
		require("sonarlint").setup({
			server = {
				cmd = {
					"sonarlint-language-server",
					"-stdio",
					"-analyzers",
					vim.fn.expand(" ~/.local/share/nvim/mason/share/sonarlint-analyzers/sonarpython.jar"),
					vim.fn.expand(" ~/.local/share/nvim/mason/share/sonarlint-analyzers/sonarcfamily.jar"),
					vim.fn.expand(" ~/.local/share/nvim/mason/share/sonarlint-analyzers/sonarjava.jar"),
				},
				init_options = {
					omnisharpDirectory = vim.fn.expand(" ~/.local/share/nvim/mason/packages/sonarlint-language-server/extension/omnisharp"),
					csharpOssPath = vim.fn.expand(" ~/.local/share/nvim/mason/share/sonarlint-analyzers/sonarcsharp.jar"),
					csharpEnterprisePath = vim.fn.expand(" ~/.local/share/nvim/mason/share/sonarlint-analyzers/csharpenterprise.jar"),
				},

			},
			filetypes = {
				"cs",
				'javascript',
				'typescript',
			},
		})
	end
}
