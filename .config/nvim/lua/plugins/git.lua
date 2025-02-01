return {
	{
		"lewis6991/gitsigns.nvim",
	},
	{
		"sindrets/diffview.nvim",
		config = function()
			require("diffview").setup()
		end,
	},
}
