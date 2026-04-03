local M = {}

local launch_cache = nil

get_program_and_args = function()
	-- if launch_cache then
	-- 	return launch_cache.program, launch_cache.args
	-- end
	if launch_cache then
		local choice = vim.fn.confirm(

			"Reuse previous CLI args?",
			"&Yes\n&No",
			1

		)
		if choice == 1 then
			return launch_cache.program, launch_cache.args
		end

		-- user selected No → clear cache
		launch_cache = nil
	end

	local program = vim.fn.input(
		"Path to dll: ",
		vim.fn.getcwd() .. "/bin/Debug/",
		"file"

	)

	local arg_string = vim.fn.input("CLI args: ")

	-- split on whitespace
	local args = {}
	if arg_string ~= "" then
		args = vim.fn.split(arg_string, [[\s\+]])
	end

	launch_cache = { program = program, args = args }
	return program, args
end

local args_cache = nil

local function get_args()
  if args_cache then
    local choice = vim.fn.confirm(
      "CLI args: reuse previous?",
      "&Yes\n&Re-enter\n&Clear",
      1
    )

    if choice == 1 then
      return args_cache
    elseif choice == 3 then
      args_cache = {}
      return args_cache
    end
    -- choice == 2 → fall through and re-prompt
  end


  local arg_string = vim.fn.input("CLI args: ")

  local args = {}
  if arg_string ~= "" then
    args = vim.fn.split(arg_string, [[\s\+]])
  end

  args_cache = args
  return args_cache
end

function M.setup_adapter(dap)
	require('nvim-treesitter.parsers')['dap-repl'] = {
		install_info = {

			url = "https://github.com/LiadOz/nvim-dap-repl-highlights.git",
			branch = 'master',
			queries = 'queries/dap_repl',
		},
	}
	dap.configurations.cs = {
		{
			type = "coreclr",
			name = "launch - netcoredbg",
			request = "launch",
			cwd = function()
				local cwd = require("features.dotnet.startup").debug_cwd()
				vim.notify("Debug CWD: "..cwd)
				return cwd
			end,
			program = function ()
				return M.debug_startup()
			end,
			env = {
				DOTNET_ENVIRONMENT = "Development",
				ASPNETCORE_ENVIRONMENT = "Development"
			},
			repl_lang = "dap_repl"
		},

		{
			type = "coreclr",
			name = "launch - netcoredbg (prompt args)",
			request = "launch",
			cwd = "${workspaceFolder}",
			program = function ()
				return M.debug_startup()
			end,
			-- args = { "backup", "-u", "dbadmin", "--password-source", "env" },
			args = function()
				return get_args()
			end,
			env = {
				DOTNET_ENVIRONMENT = "Development",
				ASPNETCORE_ENVIRONMENT = "Development",
			},
			repl_lang = "c_sharp",
		}}
end


function M.debug_startup()

	-- vim.cmd("DotnetBuild")
	return require("features.dotnet.startup").debug()
end

return M

