local M = {}

function M.formatters_by_ft()
  return {
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
  }
end

function M.formatters()
  return {}
end

return M
