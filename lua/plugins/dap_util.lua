local M = {}
local dap = require("dap")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local project

function select_start_up_project()
	local opts = {}
	print('got into the method')
	pickers.new(opts, {
		prompt_title = "Path to executable",
		-- "-E 'obj'", "-E 'bin'", 
		finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", "csproj" }, {}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(buffer_number)
			actions.select_default:replace(function()
				actions.close(buffer_number)
				project = action_state.get_selected_entry()[1]
				print(project)
			end)
			return true
		end,
	})
	:find()
	return project
end

vim.g.build_projekt = function()
	print('select_start_up_project')
	local path = select_start_up_project()
	print('path' .. path)
	end

vim.g.dotnet_build_project = function()
    local default_path = vim.fn.getcwd() .. '/'
    if vim.g['dotnet_last_proj_path'] ~= nil then
        default_path = vim.g['dotnet_last_proj_path']
    end
    local path = vim.fn.input('Path to your *proj file', default_path, 'file')
    vim.g['dotnet_last_proj_path'] = path
    local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'
    -- print('')
	vim.notify('Cmd to execute: ' .. cmd)
    -- print('Cmd to execute: ' .. cmd)
    local f = os.execute(cmd)
    if f == 0 then
		vim.notify('\nBuild: ✔️ ')
        -- print('\nBuild: ✔️ ')
    else
		vim.notify('\nBuild: ❌ (code: ' .. f .. ')')
        -- print('\nBuild: ❌ (code: ' .. f .. ')')
    end
end

vim.g.dotnet_get_dll_path = function()
    local request = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end

    if vim.g['dotnet_last_dll_path'] == nil then
        vim.g['dotnet_last_dll_path'] = request()
    else
        if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
            vim.g['dotnet_last_dll_path'] = request()
        end
    end

    return vim.g['dotnet_last_dll_path']
end

local config = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
	cwd = "${workspaceFolder}",
    program = function()
    --     if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
    --         vim.g.dotnet_build_project()
    --     end
    --     return vim.g.dotnet_get_dll_path()
return coroutine.create(function(coro)
        local opts = {}
        pickers
          .new(opts, {
            prompt_title = "Path to executable",
            finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", ".dll" }, {}),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(buffer_number)
              actions.select_default:replace(function()
                actions.close(buffer_number)
                coroutine.resume(coro, action_state.get_selected_entry()[1])
              end)
              return true
            end,
          })
          :find()
      end)	  -- return vim.g.dotnet_get_dll_path()
    end,
	env = {
      DOTNET_ENVIRONMENT = "Development",
    },
  },
}
vim.g.build_project_async = function ()
	local co = coroutine.create(function(coro)
		local opts = {}
		pickers
		.new(opts, {
			prompt_title = "Path to executable",
			finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", ".dll" }, {}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(buffer_number)
				actions.select_default:replace(function()
					print("came")
					actions.close(buffer_number)
					coroutine.resume(coro, action_state.get_selected_entry()[1])
				end)
				return true
			end,
		})
		:find()
	end)	  -- return vim.g.dotnet_get_dll_path()
	print(coroutine.status(co))
end
dap.configurations.cs = config
dap.configurations.fsharp = config
vim.api.nvim_set_keymap('n', '<C-s>', ':lua vim.g.build_projekt()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-a>', ':lua vim.g.build_project_async()<CR>', { noremap = true, silent = true })
return M
