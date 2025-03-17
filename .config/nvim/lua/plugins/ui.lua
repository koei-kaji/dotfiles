return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("harpoon").setup({})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
			"rcarriga/nvim-notify",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
	},
	{
		"prochri/telescope-all-recent.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"kkharji/sqlite.lua",
			-- optional, if using telescope for vim.ui.select
			"stevearc/dressing.nvim",
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
	},
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
	},
	{ "kevinhwang91/nvim-hlslens" },
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		config = function()
			require("bqf").setup({})
		end,
		ft = "qf",
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
	},
	{
		{ "akinsho/toggleterm.nvim", version = "*", config = true },
	},
	{
		"sphamba/smear-cursor.nvim",
		opts = {},
	},
	{
		"karb94/neoscroll.nvim",
		opts = {},
	},
	{ "rcarriga/nvim-notify" },
	{
		"tomasky/bookmarks.nvim",
		config = function()
			require("bookmarks").setup({})
		end,
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			-- options
		},
		config = function()
			require("fidget").setup({})
		end,
	},
}
