local lang = require("formatting.languages")

require("conform").setup({
    formatters_by_ft = lang.formatters_by_ft(),
    formatters = lang.formatters(),

    -- NOTE: Command to toggle format-on-save
    -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
    format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return { timeout_ms = 2000, lsp_format = "fallback" }
    end,
})

-- TODO: 別ファイルに移動
vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})
vim.api.nvim_create_user_command("SaveWithoutFormatting", function()
    vim.cmd("FormatDisable!")
    vim.cmd("write")
    vim.cmd("FormatEnable")
end, {
    desc = "Save file without formatting",
})
