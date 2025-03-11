return{
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
	"nvim-tree/nvim-web-devicons",
    },

    config = function ()
	require("nvim-tree").setup({
	    diagnostics = {
		enable = false,
		show_on_dirs = false,
		show_on_open_dirs = true,
		debounce_delay = 500,
		severity = {
		    min = vim.diagnostic.severity.HINT,
		    max = vim.diagnostic.severity.ERROR,
		},
		icons = {
		    hint = "",
		    info = "",
		    warning = "",
		    error = "",
		},
	    },
	    git = {
		enable = true,
	    },
	    sort = {
		sorter = "case_sensitive",
	    },
	    view = {
		width = 30,
	    },
	    renderer = {
		indent_markers = {
		    enable = true,
		},
		highlight_git = true,
		group_empty = true,
	    },
	})
	vim.cmd([[
	:hi      NvimTreeExecFile    guifg=#ffa0a0
	:hi      NvimTreeSpecialFile guifg=#ff80ff gui=underline
	:hi      NvimTreeSymlink     guifg=Yellow  gui=italic
	:hi link NvimTreeImageFile   Title
	]])
   end
}
