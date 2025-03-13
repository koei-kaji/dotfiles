local js_formatters = { "prettierd" }
local M = {}

function M.formatters_by_ft()
    return {
        html = js_formatters,
        javascript = js_formatters,
        javascriptreact = js_formatters,
        typescript = js_formatters,
        typescriptreact = js_formatters,
    }
end

function M.formatters()
    return {}
end

return M
