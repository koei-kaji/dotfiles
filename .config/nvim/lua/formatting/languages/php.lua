local M = {}

local function find_upward(ctx, names)
  return vim.fs.find(names, { upward = true, path = vim.fs.dirname(ctx.filename) })[1]
end

function M.formatters_by_ft()
  return {
    php = { "pint", "php_cs_fixer", stop_after_first = true },
  }
end

function M.formatters()
  return {
    pint = {
      command = function(_, ctx)
        local local_bin = find_upward(ctx, { "vendor/bin/pint" })
        return local_bin or "pint"
      end,
      args = { "$FILENAME" },
      stdin = false,
      condition = function(_, ctx)
        return find_upward(ctx, { "pint.json" }) ~= nil
      end,
    },
    php_cs_fixer = {
      command = "php-cs-fixer",
      args = function(_, ctx)
        local args = { "fix" }
        local config = find_upward(ctx, { ".php-cs-fixer.php", ".php-cs-fixer.dist.php" })
        if config then
          table.insert(args, "--config=" .. config)
        end
        table.insert(args, "$FILENAME")
        return args
      end,
      stdin = false,
      condition = function(_, ctx)
        return find_upward(ctx, { ".php-cs-fixer.php", ".php-cs-fixer.dist.php" }) ~= nil
      end,
    },
  }
end

return M
