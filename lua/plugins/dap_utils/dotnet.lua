local M = {}

function M.setup_adapter(dap)
	dap.configurations.cs = {
		{
			type = "coreclr",
			name = "launch - netcoredbg",
			request = "launch",
			cwd = "${workspaceFolder}",
			program = function ()
				return M.debug_startup()
			end,
			env = {
				DOTNET_ENVIRONMENT = "Development",
			},
		},
	}
end

function M.debug_startup()
	return require("features.dotnet.startup").debug()
end

return M

