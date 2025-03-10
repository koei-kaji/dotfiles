return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("tokyonight").setup({
				style = "night",
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			})
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
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
		},
		config = function()
			-- See: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
			local telescope = require("telescope")
			local telescopeConfig = require("telescope.config")
			local actions = require("telescope.actions")

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
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
						n = {
							["<esc>"] = actions.close,
							["q"] = actions.close,
						},
					},
					layout_strategy = "vertical",

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

			telescope.load_extension("live_grep_args")
			telescope.load_extension("notify")
		end,
	},
	{
		"prochri/telescope-all-recent.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"kkharji/sqlite.lua",
			-- optional, if using telescope for vim.ui.select
			"stevearc/dressing.nvim",
		},
		opts = {
			-- your config goes here
		},
		config = function()
			require("telescope-all-recent").setup({
				database = {
					folder = vim.fn.stdpath("data"),
					file = "telescope-all-recent.sqlite3",
					max_timestamps = 10,
				},
				debug = false,
				scoring = {
					recency_modifier = { -- also see telescope-frecency for these settings
						[1] = { age = 240, value = 100 }, -- past 4 hours
						[2] = { age = 1440, value = 80 }, -- past day
						[3] = { age = 4320, value = 60 }, -- past 3 days
						[4] = { age = 10080, value = 40 }, -- past week
						[5] = { age = 43200, value = 20 }, -- past month
						[6] = { age = 129600, value = 10 }, -- past 90 days
					},
					-- how much the score of a recent item will be improved.
					boost_factor = 0.0001,
				},
				default = {
					disable = true, -- disable any unknown pickers (recommended)
					use_cwd = true, -- differentiate scoring for each picker based on cwd
					sorting = "recent", -- sorting: options: 'recent' and 'frecency'
				},
				pickers = { -- allows you to overwrite the default settings for each picker
					man_pages = { -- enable man_pages picker. Disable cwd and use frecency sorting.
						disable = false,
						use_cwd = false,
						sorting = "frecency",
					},

					-- change settings for a telescope extension.
					-- To find out about extensions, you can use `print(vim.inspect(require'telescope'.extensions))`
					["extension_name#extension_method"] = {
						-- [...]
					},
				},
			})
		end,
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
			require("hlslens").setup({
				calm_down = true,
			})
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
			notify.setup({
				timeout = 500,
			})
			vim.notify = notify
		end,
	},
}
