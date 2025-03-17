local cmp = require("cmp")
local lspkind = require("lspkind")
local neogen = require("neogen")
local luasnip = require("luasnip")

lspkind.init({
	symbol_map = {
		Copilot = "",
	},
})

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

cmp.setup({
	-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
	-- https://github.com/danymat/neogen?tab=readme-ov-file#default-cycling-support
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				if luasnip.expandable() then
					luasnip.expand()
				else
					cmp.confirm({
						select = true,
					})
				end
			else
				fallback()
			end
		end),
		["<C-J>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.locally_jumpable(1) then
				luasnip.jump(1)
			elseif neogen.jumpable() then
				neogen.jump_next()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-K>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			elseif neogen.jumpable(true) then
				neogen.jump_prev()
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		-- Copilot Source
		{ name = "copilot", group_index = 2 },
		-- Other Sources
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "codecompanion" },
	}, {
		{ name = "buffer" },
	}),
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol", -- show only symbol annotations
			maxwidth = {
				-- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
				-- can also be a function to dynamically calculate max width such as
				-- menu = function() return math.floor(0.45 * vim.o.columns) end,
				menu = 50, -- leading text (labelDetails)
				abbr = 50, -- actual suggestion item
			},
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
			show_labelDetails = true, -- show labelDetails in menu. Disabled by default

			-- The function below will be called before any actual modifications from lspkind
			-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
			---@diagnostic disable-next-line: unused-local
			before = function(entry, vim_item)
				-- ...
				return vim_item
			end,
		}),
	},
})

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})
