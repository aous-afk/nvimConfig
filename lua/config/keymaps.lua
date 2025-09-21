local map = vim.keymap.set
-- map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
-- map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
-- map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
-- map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

local builtin = require('telescope.builtin')
local telescope = require("telescope")

vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current c[w]ord' })
vim.keymap.set('n', '<leader>sW', builtin.grep_string, { desc = '[S]earch current c[W]ORD' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

vim.keymap.set("n", "<leader>y", function()
	telescope.extensions.neoclip.default()
end, { desc = "Neoclip: Clipboard History" })

vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<C-p>', builtin.git_files, {desc = "Git Files"})
vim.keymap.set('n', '<leader>pws', function()

local word = vim.fn.expand("<cword>")
	builtin.grep_string({ search = word })
end, {desc = "Grep cword"})
vim.keymap.set('n', '<leader>pWs', function()
	local word = vim.fn.expand("<cWORD>")
	builtin.grep_string({ search = word })
end, {desc = "Grep cWORD"})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, {desc = "Grep String"})

vim.api.nvim_set_keymap('n', '<C-b>', '<cmd>DotnetBuild<CR>', { noremap = true, silent = true })

vim.keymap.set("i", "jj", "<ESC>", { silent = true })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set("n", '<leader>vt', ':split +terminal<CR>', {desc = 'open terminal in split'})

--#region easy-dotnet
--easy dotnet keymap s and l are from trouble
local dotnet = require("easy-dotnet")
local diagnostics = require("easy-dotnet.actions.diagnostics")

-- Project view
vim.keymap.set("n", "<leader>cv", dotnet.project_view, { desc = "Project view" })

-- Diagnostics
vim.keymap.set("n", "<leader>cda", function()
  diagnostics.get_workspace_diagnostics()
end, { desc = "Diagnostics (all)" })

vim.keymap.set("n", "<leader>cde", function()
  diagnostics.get_workspace_diagnostics("error")
end, { desc = "Diagnostics (errors)" })

vim.keymap.set("n", "<leader>cdw", function()
  diagnostics.get_workspace_diagnostics("warning")
end, { desc = "Diagnostics (warnings)" })

-- not sure about this
local input = function(prompt, default, cb)
  if vim.ui and vim.ui.input then
    vim.ui.input({ prompt = prompt, default = default or "" }, cb)
  else
    cb(vim.fn.input(prompt, default or ""))
  end
end

local confirm = function(prompt, cb)
  local opts = { "No", "Yes" }
  if vim.ui and vim.ui.select then
    vim.ui.select(opts, { prompt = prompt }, function(choice) cb(choice == "Yes") end)
  else
    cb(vim.fn.confirm(prompt, "&Yes\n&No", 2) == 1)
  end
end

-- List migrations
vim.keymap.set("n", "<leader>cel", function()
  dotnet.ef_migrations_list()
end, { desc = "EF: List migrations" })

-- Add migration (asks for a name)
vim.keymap.set("n", "<leader>cea", function()
  input("EF migration name: ", "", function(name)
    if name and name ~= "" then
      dotnet.ef_migrations_add(name)
    else
      vim.notify("EF: Migration name required", vim.log.levels.WARN)
    end
  end)
end, { desc = "EF: Add migration…" })

-- Remove last migration
vim.keymap.set("n", "<leader>cer", function()
  dotnet.ef_migrations_remove()
end, { desc = "EF: Remove last migration" })

-- Database update (latest)
vim.keymap.set("n", "<leader>ceu", function()
  dotnet.ef_database_update()
end, { desc = "EF: Update database (latest)" })

-- Database update (pick target)
vim.keymap.set("n", "<leader>ceU", function()
  dotnet.ef_database_update_pick()
end, { desc = "EF: Update database (pick target)" })

-- Drop database (with confirmation)
vim.keymap.set("n", "<leader>ced", function()
  confirm("EF: Drop database? This is destructive.", function(yes)
    if yes then dotnet.ef_database_drop() end
  end)
end, { desc = "EF: Drop database (confirm)" })
--#endregion
