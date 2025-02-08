return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("tokyonight").setup({
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			-- See: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
			local telescope = require("telescope")
			local telescopeConfig = require("telescope.config")

			-- Clone the default Telescope configuration
			---@diagnostic disable-next-line: deprecated
			local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

			-- I want to search in hidden/dot files.
			table.insert(vimgrep_arguments, "--hidden")
			-- I don't want to search in the `.git` directory.
			table.insert(vimgrep_arguments, "--glob")
			table.insert(vimgrep_arguments, "!**/.git/*")

			telescope.setup({
				defaults = {
					-- `hidden = true` is not supported in text grep commands.
					vimgrep_arguments = vimgrep_arguments,
				},
				pickers = {
					find_files = {
						-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
				},
			})
		end,
	},
	{
		"prochri/telescope-all-recent.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"kkharji/sqlite.lua",
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight-night",
				},
			})
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			require("neo-tree").setup({
				filesystem = {
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_hidden = false,
					},
					-- NOTE: Short path names for folders
					--       https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1344#issuecomment-1930909012
					components = {
						name = function(config, node, state)
							local components = require("neo-tree.sources.common.components")
							local name = components.name(config, node, state)
							if node:get_depth() == 1 then
								name.text = vim.fn.pathshorten(name.text, 2)
							end
							return name
						end,
					},
				},
				commands = {
					copy_selector = function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						local filename = node.name
						local modify = vim.fn.fnamemodify

						local vals = {
							["BASENAME"] = modify(filename, ":r"),
							["EXTENSION"] = modify(filename, ":e"),
							["FILENAME"] = filename,
							["PATH (CWD)"] = modify(filepath, ":."),
							["PATH (HOME)"] = modify(filepath, ":~"),
							["PATH"] = filepath,
							["URI"] = vim.uri_from_fname(filepath),
						}

						local options = vim.tbl_filter(function(val)
							return vals[val] ~= ""
						end, vim.tbl_keys(vals))
						if vim.tbl_isempty(options) then
							vim.notify("No values to copy", vim.log.levels.WARN)
							return
						end
						table.sort(options)
						vim.ui.select(options, {
							prompt = "Choose to copy to clipboard:",
							format_item = function(item)
								return ("%s: %s"):format(item, vals[item])
							end,
						}, function(choice)
							local result = vals[choice]
							if result then
								vim.notify(("Copied: `%s`"):format(result))
								vim.fn.setreg("+", result)
							end
						end)
					end,
				},
				window = {
					mappings = {
						Y = "copy_selector",
					},
				},
			})
		end,
	},
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("hlchunk").setup({
				chunk = {
					enable = true,
				},
				indent = {
					enable = true,
				},
			})
		end,
	},
	{
		"kevinhwang91/nvim-hlslens",
		config = function()
			require("hlslens").setup()
		end,
	},
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			-- animation = true,
			-- insert_at_start = true,
			-- …etc.
		},
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
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		{ "akinsho/toggleterm.nvim", version = "*", config = true },
	},
	{
		"stevearc/overseer.nvim",
		opts = {},
		config = function()
			require("overseer").setup({
				strategy = "toggleterm",
			})
		end,
	},
	{
		"sphamba/smear-cursor.nvim",
		opts = {},
	},
	{
		"karb94/neoscroll.nvim",
		opts = {},
	},
	{
		"rcarriga/nvim-notify",
		config = function()
			local notify = require("notify")
			notify.setup()
			vim.notify = notify
		end,
	},
}
