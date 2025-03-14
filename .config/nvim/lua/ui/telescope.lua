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
			theme = "ivy",
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
		buffers = {
			theme = "ivy",
		},
		grep_strings = {
			theme = "ivy",
		},
		old_files = {
			theme = "ivy",
		},
	},
	extensions = {
		live_grep_args = {
			theme = "ivy",
		},
	},
})

telescope.load_extension("live_grep_args")
telescope.load_extension("notify")
telescope.load_extension("fzf")
telescope.load_extension("bookmarks")
