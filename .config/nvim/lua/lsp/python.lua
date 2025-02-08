local lspconfig = require("lspconfig")

lspconfig.ruff.setup({})
lspconfig.pyright.setup({
	settings = {
		pyright = {
			-- Using Ruff's import organizer
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				-- Ignore all files for analysis to exclusively use Ruff for linting
				ignore = { "*" },
			},
			pythonPath = ".venv/bin/python",
		},
	},
})
