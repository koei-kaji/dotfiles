return {
	{
		"ixru/nvim-markdown",
		ft = { "markdown" },
		config = function()
			require("nvim-markdown").setup({})
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
	},
}
