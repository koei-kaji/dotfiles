local prettier_formatters = { "prettierd", "prettier", stop_after_first = true }
local M = {}

function M.formatters_by_ft()
  return {
    css = prettier_formatters,
    graphql = prettier_formatters,
    html = prettier_formatters,
    javascript = prettier_formatters,
    javascriptreact = prettier_formatters,
    json = prettier_formatters,
    jsonc = prettier_formatters,
    less = prettier_formatters,
    markdown = prettier_formatters,
    scss = prettier_formatters,
    typescript = prettier_formatters,
    typescriptreact = prettier_formatters,
    vue = prettier_formatters,
    yaml = prettier_formatters,
  }
end

function M.formatters()
  return {}
end

return M
