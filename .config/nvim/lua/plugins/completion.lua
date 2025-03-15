return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		-- lsp
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",

		-- sources
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",

		-- kind
		"onsails/lspkind-nvim",

		-- snippet
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
			dependencies = { "rafamadriz/friendly-snippets" },
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		"saadparwaiz1/cmp_luasnip",

		-- copilot
		{
			"zbirenbaum/copilot-cmp",
			dependencies = { "zbirenbaum/copilot.lua" },
		},

		-- neogen
		"danymat/neogen",
	},
}
