require("mason-lspconfig").setup({
  ensure_installed = {
    "bashls",
    "gopls",
    "intelephense",
    "lua_ls",
    "ts_ls",
    "vtsls",
    "vue_ls",
    "ty",
    "pyright",
    "ruff",
    "yamlls",
    "sqlls",
  },
})

vim.lsp.enable("gopls")
vim.lsp.enable("intelephense")
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("ts_ls")
vim.lsp.enable("vtsls")
vim.lsp.enable("vue_ls")
vim.lsp.enable("ty")
vim.lsp.enable("yamlls")
vim.lsp.enable("sqlls")

vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})
