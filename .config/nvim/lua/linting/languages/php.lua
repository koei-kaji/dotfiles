local lint = require("lint")

local function find_upward(names)
  local start = vim.api.nvim_buf_get_name(0)
  if start == "" then
    start = vim.uv.cwd() or vim.loop.cwd()
  end
  return vim.fs.find(names, { upward = true, path = vim.fs.dirname(start) })[1]
end

local function resolve_bin(local_rel_path, fallback)
  local local_bin = find_upward({ local_rel_path })
  if local_bin then
    return local_bin
  end
  return fallback
end

-- phpcs: prefer vendor/bin/phpcs over global, args resolved per-buffer
local phpcs = lint.linters.phpcs
phpcs.cmd = function()
  return resolve_bin("vendor/bin/phpcs", "phpcs")
end
phpcs.args = function()
  local args = {}
  local config = find_upward({ "phpcs.xml", "phpcs.xml.dist", ".phpcs.xml", ".phpcs.xml.dist" })
  if config then
    table.insert(args, "--standard=" .. config)
  end
  vim.list_extend(args, {
    "-q",
    "--report=json",
    "-", -- need `-` at the end for stdin support
  })
  return args
end

-- phpstan: prefer vendor/bin/phpstan over global, args resolved per-buffer
local phpstan = lint.linters.phpstan
phpstan.cmd = function()
  return resolve_bin("vendor/bin/phpstan", "phpstan")
end
phpstan.args = function()
  local args = { "analyse" }
  local config = find_upward({ "phpstan.neon", "phpstan.neon.dist", "phpstan.dist.neon" })
  if config then
    table.insert(args, "--configuration=" .. config)
  end
  vim.list_extend(args, {
    "--error-format=json",
    "--no-progress",
  })
  return args
end

local M = {}

function M.linters_by_ft()
  local php_linters = {}

  -- enable phpcs only when binary is available and a phpcs config exists
  local phpcs_bin = resolve_bin("vendor/bin/phpcs", nil)
  if
    (phpcs_bin or vim.fn.executable("phpcs") == 1)
    and find_upward({ "phpcs.xml", "phpcs.xml.dist", ".phpcs.xml", ".phpcs.xml.dist" })
  then
    table.insert(php_linters, "phpcs")
  end

  -- enable phpstan only when binary is available and a phpstan config exists
  local phpstan_bin = resolve_bin("vendor/bin/phpstan", nil)
  if
    (phpstan_bin or vim.fn.executable("phpstan") == 1)
    and find_upward({ "phpstan.neon", "phpstan.neon.dist", "phpstan.dist.neon" })
  then
    table.insert(php_linters, "phpstan")
  end

  return {
    php = php_linters,
  }
end

return M
