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

require("lsp.go")
require("lsp.js")
require("lsp.lua")
require("lsp.python")
require("lsp.yaml")

require("lsp.lspsaga")

-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
  require("lspconfig")[ls].setup({
    capabilities = capabilities,
    -- you can add other fields for setting up lsp server in this table
  })
end
