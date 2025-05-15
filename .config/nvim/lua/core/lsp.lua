require("mason-lspconfig").setup({
  ensure_installed = {
    "bashls",
    "gopls",
    "lua_ls",
    "ts_ls",
    "pyright",
    "ruff",
    "yamlls",
  },
})

require("lspsaga").setup({
  ui = {
    code_action = "",
  },
  finder = {
    layout = "normal",
  },
  options = {
    theme = "catppuccin-mocha",
  },
})

vim.lsp.enable("gopls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("ts_ls")
vim.lsp.enable("yamlls")

vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
