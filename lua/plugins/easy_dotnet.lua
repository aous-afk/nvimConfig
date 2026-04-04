return
{
	"GustavEikaas/easy-dotnet.nvim",
	dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
		config = function()
			local dotnet = require("easy-dotnet")
			dotnet.setup({
				managed_terminal = {
					auto_hide = true,
					auto_hide_delay = 1000,
				},
				external_terminal = nil,
				lsp = {
					enabled = true,
					preload_roslyn = true,
					roslynator_enabled = true,
					easy_dotnet_analyzer_enabled = true,
					auto_refresh_codelens = true,
				},
				debugger = {
				    bin_path = '/usr/bin/netcoredbg',
				    console = "internalConsole",
				    apply_value_converters = true,
				    auto_register_dap = true,
				    mappings = {
				        open_variable_viewer = { lhs = "M", desc = "open variable viewer" },
				    },
				},
				---@type TestRunnerOptions
				test_runner = {
					auto_start_testrunner = true,
					hide_legend = false,
					---@type "split" | "vsplit" | "float" | "buf"
					viewmode = "float",
					---@type number|nil
					vsplit_width = nil,
					---@type string|nil "topleft" | "topright" 
					vsplit_pos = nil,
					icons = {
						passed = "",
						skipped = "",
						failed = "",
						success = "",
						reload = "",
						test = "",
						sln = "󰘐",
						project = "󰘐",
						dir = "",
						package = "",
						class = "",
						build_failed = "󰒡",
					},
					mappings = {
						run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
						get_build_errors = { lhs = "<leader>e", desc = "get build errors" },
						peek_stack_trace_from_buffer = { lhs = "<leader>p", desc = "peek stack trace from buffer" },
						debug_test_from_buffer = { lhs = "<leader>d", desc = "run test from buffer" },
						debug_test = { lhs = "<leader>d", desc = "debug test" },
						go_to_file = { lhs = "g", desc = "go to file" },
						run_all = { lhs = "<leader>R", desc = "run all tests" },
						run = { lhs = "<leader>r", desc = "run test" },
						peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
						expand = { lhs = "o", desc = "expand" },
						expand_node = { lhs = "E", desc = "expand node" },
						collapse_all = { lhs = "W", desc = "collapse all" },
						close = { lhs = "q", desc = "close testrunner" },
						refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
						cancel = { lhs = "<C-c>", desc = "cancel in-flight operation" },
					}
				},
				new = {
					project = {
						prefix = "sln" -- "sln" | "none"
					}
				},
				csproj_mappings = true,
				fsproj_mappings = true,
				auto_bootstrap_namespace = {
					type = "block_scoped",
					enabled = true,
					use_clipboard_json = {
						behavior = "prompt", --'auto' | 'prompt' | 'never',
						register = "+", -- which register to check
					},
				},
				server = {
					---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
					log_level = nil,
				},
				picker = "telescope",
				background_scanning = true,
				notifications = {
						handler = false
					},
				diagnostics = {
					default_severity = "error",
					setqflist = false,
				},
			})
		end
	}
