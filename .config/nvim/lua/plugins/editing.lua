return {
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"c_sharp",
					"cpp",
					"css",
					"dockerfile",
					"go",
					"html",
					"java",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"php",
					"python",
					"query",
					"rust",
					"scss",
					"sql",
					"toml",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"vue",
					"xml",
					"yaml",
				},
			})

			-- https://github.com/neovim/neovim/pull/26347#issuecomment-1837508178
			vim.treesitter.start = (function(wrapped)
				return function(bufnr, lang)
					lang = lang or vim.fn.getbufvar(bufnr or "", "&filetype")
					pcall(wrapped, bufnr, lang)
				end
			end)(vim.treesitter.start)
		end,
	},
	{
		"RRethy/nvim-treesitter-textsubjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("nvim-treesitter-textsubjects").configure({
				prev_selection = ",",
				keymaps = {
					["."] = "textsubjects-smart",
					[";"] = "textsubjects-container-outer",
					["i;"] = {
						"textsubjects-container-inner",
						desc = "Select inside containers (classes, functions, etc.)",
					},
				},
			})
		end,
	},
	{
		"Wansmer/treesj",
		keys = { "<space>m", "<space>j", "<space>s" },
		dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
		config = function()
			require("treesj").setup({--[[ your config ]]
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
		config = function()
			require("nvim-ts-autotag").setup({})
		end,
	},
	{
		"monaqa/dial.nvim",
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					-- nonnegative decimal number (0, 1, 2, 3, ...)
					augend.integer.alias.decimal,
					-- nonnegative hex number  (0x01, 0x1a1f, etc.)
					augend.integer.alias.hex,
					-- datetime
					augend.date.alias["%Y/%m/%d"],
					augend.date.alias["%Y-%m-%d"],
					augend.date.alias["%Y年%-m月%-d日"],
					augend.date.alias["%Y年%-m月%-d日(%ja)"],
					augend.date.alias["%H:%M:%S"],
					augend.date.alias["%H:%M"],
					augend.constant.alias.ja_weekday,
					augend.constant.alias.ja_weekday_full,
					-- bool
					augend.constant.new({ elements = { "true", "false" } }),
					augend.constant.new({ elements = { "True", "False" } }),
					-- operand
					augend.constant.new({ elements = { "&&", "||" } }),
					augend.constant.new({ elements = { "and", "or" } }),
				},
			})
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		config = function()
			--See: https://github.com/kevinhwang91/nvim-ufo?tab=readme-ov-file#customize-fold-text
			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (" 󰁂 %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			require("ufo").setup({
				fold_virt_text_handler = handler,
			})
		end,
	},
	{
		"anuvyklack/fold-preview.nvim",
		dependencies = { "anuvyklack/keymap-amend.nvim" },
		config = function()
			require("fold-preview").setup({
				default_keybindings = false,
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}
