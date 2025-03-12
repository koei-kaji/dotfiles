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
