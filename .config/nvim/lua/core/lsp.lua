require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"lua_ls",
		"ts_ls",
		"pyright",
		"ruff",
		"yamlls",
	},
})

require("lsp.js")
require("lsp.lua")
require("lsp.python")
require("lsp.yaml")
