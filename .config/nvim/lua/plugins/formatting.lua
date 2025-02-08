return {
	{
		"stevearc/conform.nvim",
		config = function()
			local js_formatters = { "prettierd" }
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					html = js_formatters,
					javascript = js_formatters,
					javascriptreact = js_formatters,
					typescript = js_formatters,
					typescriptreact = js_formatters,
					["*"] = { "codespell" },
					["_"] = { "trim_newlines", "trim_whitespace" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},
}
