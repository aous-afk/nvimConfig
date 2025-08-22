--#region
--
--#endregion
local M, uv = {}, vim.uv
local cfg = { build_cfg = "Debug", icon = "", cache_dir = vim.fn.stdpath("cache").."/dotnet", run_time="linux-x64" }
local state = { root = nil, project = nil }

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local themes = require("telescope.themes")

local function proj_root()
  local r = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  return (r and r ~= "") and r or vim.loop.cwd()
end

local function cache_file(r)
  -- local in_git = vim.fn.isdirectory(r.."/.git") == 1
  -- if in_git then return r.."/.git/.nvim_startup_project" end
  vim.fn.mkdir(cfg.cache_dir, "p"); return cfg.cache_dir.."/"..vim.fn.sha256(r)..".startup"
end

local function read(p) local f=io.open(p,"r"); if not f then return end local s=f:read("*a"); f:close(); return s end

function M.detect_projects(r)
  r = r or state.root or proj_root()
  return vim.fs.find(function(n) return n:match("%.csproj$") end, { type="file", path=r, limit=200 })
end

-- function M.save_selection(p)
--   local f = cache_file(state.root or proj_root()); local h = io.open(f,"w"); if h then h:write(p) h:close() end
--   state.project = p; vim.notify("Startup: "..vim.fs.basename(p))
-- end

function M.load_selection()
  local p = read(cache_file(state.root or proj_root()))
  if p and uv.fs_stat(p) then state.project = p end
  return state.project
end

local function parse_csproj(csproj)
  local s = read(csproj) or ""
  local asm = s:match("<AssemblyName>(.-)</AssemblyName>") or csproj:match("([^/\\]+)%.csproj$")
  local tfm = s:match("<TargetFramework>(.-)</TargetFramework>") or (s:match("<TargetFrameworks>(.-)</TargetFrameworks>") or ""):match("^[^;]+")
  return asm, (tfm or "net8.0")
end

function M.resolve_dll(csproj, build_cfg, tfm)
  local asm, tfm0 = parse_csproj(csproj); tfm = tfm or tfm0
  return table.concat({ vim.fs.dirname(csproj), "bin", build_cfg or cfg.build_cfg, tfm, (cfg.run_time or "linux-x64"), asm..".dll" }, "/")
end

local function sh(cmd, args, cb)
print({cmd, unpack(args or {})})
print(unpack({cmd, unpack(args or {})}))
  vim.system({cmd, unpack(args or {})}, { text=true }
  , function(res)
    if res.code ~= 0 then
		print(res.stdout)
		-- return vim.notify(res.stderr or (cmd.." failed"), vim.log.levels.ERROR)
	end
    if cb then
		cb(res.stdout)
	end
  end
  )
end

function M.select_with_telescope()
  local projects = M.detect_projects()

  if #projects == 0 then
	  return vim.notify("No .csproj found", vim.log.levels.WARN)
  end

  pickers.new(themes.get_dropdown({ prompt_title = "Startup project" }), {
    finder=finders.new_table(projects), sorter=conf.generic_sorter({}), previewer=conf.file_previewer({}),
    attach_mappings=function(bufnr, map)
      local function set(cb)
		  local e = action_state.get_selected_entry();
		  if not e then
			  vim.notify("no selected entry", vim.log.levels.WARN)
			  return
		  end
        M.save_selection(e[1]);
		actions.close(bufnr);
		if cb then
			cb(e[1])
		end
	end
      actions.select_default:replace(function() set() end)
      map("i","<C-b>",function() set(function(pj) sh("dotnet",{"build",pj, "-r", cfg.run_time or "linux-x64"}) end) end)
      map("i","<C-r>",function() set(function(pj) sh("dotnet",{"run",pj, cfg.run_time or "linux-x64", "--project"}) end) end)
      map("n","<C-b>",function() set(function(pj) sh("dotnet",{"build", "-r", cfg.run_time or "linux-x64", pj}) end) end)
      map("n","<C-r>",function() set(function(pj) sh("dotnet",{"run", "-r", cfg.run_time or "linux-x64", "--project",pj}) end) end)
      return true
    end
  }):find()
end

function M.save_selection(p)
  -- persist
  local f = cache_file(state.root or proj_root())
  local h = io.open(f, "w"); if h then h:write(p) h:close() end
  state.project = p
  local fname = vim.fs.basename(p)
  vim.notify("Startup: " .. fname)

  -- try devicons override (works across recent versions)
  local ok_icons, devicons = pcall(require, "nvim-web-devicons")
  if ok_icons then
    local before_icon = devicons.get_icon(fname, nil, { default = true })
    local ok_set = pcall(devicons.set_icon, {
      [fname] = {
        icon = (cfg.icon or ""),
        color = nil,          -- keep theme color
        cterm_color = nil,
        name = "DotnetStartup_" .. fname, -- unique name avoids collisions
      },
    })
    if not ok_set then
      vim.notify("[dotnet] devicons.set_icon failed (API mismatch?)", vim.log.levels.WARN)
    else
      if devicons.refresh then pcall(devicons.refresh) end
      local after_icon = devicons.get_icon(fname, nil, { default = true })
      vim.notify(("[dotnet] icon %s -> %s"):format(before_icon or "nil", after_icon or "nil"))
    end
  else
    vim.notify("[dotnet] nvim-web-devicons not available", vim.log.levels.WARN)
  end

  -- gently reload nvim-tree if visible
  local ok_api, api = pcall(require, "nvim-tree.api")
  if ok_api and api.tree.is_visible() then
    vim.schedule(function()
      -- reopen current root to force redraw
      api.tree.reload()
    end)
  end
end
-- function M.save_selection(p)
--   local f = cache_file(state.root or proj_root())
--   local h = io.open(f,"w"); if h then h:write(p) h:close() end
--   state.project = p
--   vim.notify("Startup: " .. vim.fs.basename(p))
--
--   -- mark in nvim-tree via devicons (safe if plugin isn’t loaded)
--   local ok_icons, devicons = pcall(require, "nvim-web-devicons")
--   if ok_icons then
-- 	  vim.notify("icon")
-- 	  local fname = vim.fs.basename(p)
-- 	  vim.notify(fname)
-- 	  devicons.set_icon{
-- 		  [fname] = { icon = cfg.icon or "",color = "#428850", name = "DotnetStartup" },
-- 	  }
--   end
--
--   -- gently reload nvim-tree if visible (also safe if not loaded)
--   local ok_api, api = pcall(require, "nvim-tree.api")
--   if ok_api and api.tree.is_visible() then
--     vim.schedule(function() api.tree.reload() end)
--   end
-- end

function M.build()
	local p=state.project or M.load_selection();
	if not p then
		return M.select_with_telescope()
	end
	print(p)
	sh("dotnet",{"build", p, "-r", cfg.run_time or "linux-x64", }, function ()
		-- print("build")
		-- vim.notify("build: "..p)
	end)
end

function M.run()
	local p=state.project or M.load_selection();
	if not p then
		return M.select_with_telescope()
	end
	sh("dotnet",{"run","-r", cfg.run_time or "linux-x64", "--project",p})
end

function M.debug()
  local p=state.project or M.load_selection(); if not p then return M.select_with_telescope() end
  return M.resolve_dll(p)
end

-- optional: call from nvim-tree render hook
function M.decorate_tree(node)
  if not state.project then M.load_selection() end
  if state.project and node.absolute_path == state.project then node.name = cfg.icon.." "..node.name end
end

function M.setup(o)
  cfg = vim.tbl_deep_extend("force", cfg, o or {}); state.root = proj_root()
  vim.api.nvim_create_user_command("DotnetSelectProject", M.select_with_telescope, {})
  vim.api.nvim_create_user_command("DotnetBuild", M.build, {})
  vim.api.nvim_create_user_command("DotnetRun", M.run, {})
  vim.api.nvim_create_user_command("DotnetDebug", M.debug, {})
end

return M
