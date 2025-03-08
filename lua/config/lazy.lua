-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
	vim.api.nvim_echo({
	    { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
	    { out, "WarningMsg" },
	    { "\nPress any key to exit..." },
	}, true, {})
	vim.fn.getchar()
	os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {'folke/tokyonight.nvim'},
    {"scottmckendry/cyberdream.nvim"},
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {"nvim-treesitter/nvim-treesitter"} ,
    {"nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
	"nvim-tree/nvim-web-devicons",
    },
}
})

vim.opt.termguicolors = true
vim.cmd.colorscheme('cyberdream')

vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.clipboard = "unnamedplus"
vim.opt.shiftwidth = 4

require("nvim-tree").setup({
    sort = {
	sorter = "case_sensitive",
    },
    view = {
	width = 30,
    },
    renderer = {
	group_empty = true,
    },
    filters = {
	dotfiles = true,
    },
})

