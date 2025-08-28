return{
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = { -- set to setup table
		},
		config = function ()
			require("colorizer").setup({
				filetypes = {
					"*",
					css = { rgb_fn = true, names = false }, -- Enable parsing rgb(...) functions in css.
					scss = { rgb_fn = true, names = false }, -- Enable parsing rgb(...) functions in css.
					html = { names = true }, -- Disable parsing "names" like Blue or Gray
				},
				user_default_options = { mode = "background"},
			})
		end
	}
}
