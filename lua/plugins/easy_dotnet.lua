return{
	"GustavEikaas/easy-dotnet.nvim",
	dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
	config = function()
		require("easy-dotnet").setup({
			diagnostics = {
				default_severity = "error",  -- "error" or "warning" (default: "error")
				setqflist = false,           -- Populate quickfix list automatically (default: false)
			},
		})
	end
}
