local M = {}

local cache = {}

function M.gem_dirs(force)
  local lockfile = vim.fn.getcwd() .. "/Gemfile.lock"
  local stat = vim.uv.fs_stat(lockfile)
  if not stat then return nil, "No Gemfile.lock found" end

  local cache_key = lockfile .. ":" .. stat.size .. ":" .. stat.mtime.sec

  if force then cache[cache_key] = nil end
  if cache[cache_key] then return cache[cache_key] end

  local handle = io.popen("bundle show --paths 2>/dev/null")
  if not handle then return nil, "Not in a bundled project" end
  local output = handle:read("*a")
  handle:close()
  local dirs = vim.split(vim.trim(output), "\n", { trimempty = true })
  if #dirs == 0 then return nil, "No gems found" end
  cache[cache_key] = dirs
  return dirs
end

return M
