vim.g.mapleader = " "

local kopts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap

-- core
map("i", "jj", "<ESC>", kopts)

map("n", "j", "gj", { noremap = true })
map("n", "k", "gk", { noremap = true })
map("n", "H", "^", { noremap = true })
map("n", "L", "$", { noremap = true })

map("n", "Y", "y$", { noremap = true })
map("n", "U", "<c-r>", { noremap = true })
map("n", "M", "%", { noremap = true })
map("x", "p", "P", { noremap = true })
map("n", "p", "]p`]", { noremap = true })
map("n", "P", "]P`]", { noremap = true })

map("n", "x", '"_d', { noremap = true })
map("n", "X", '"_D', { noremap = true })
map("x", "x", '"_x', { noremap = true })
map("o", "x", "d", { noremap = true })

map("x", "<", "<gv", { noremap = true })
map("x", ">", ">gv", { noremap = true })

map("n", "F<cr>", "{", { noremap = true })
map("n", "f<cr>", "}", { noremap = true })

map("n", "<leader>l", "<Cmd>noh<CR>", kopts)

-- window
map("n", "<leader>w/", ":vsplit<CR><C-w>l", kopts)
map("n", "<leader>w-", ":split<CR><C-w>j", kopts)
map("n", "<leader>wh", "<C-w>h", kopts)
map("n", "<leader>wj", "<C-w>j", kopts)
map("n", "<leader>wk", "<C-w>k", kopts)
map("n", "<leader>wl", "<C-w>l", kopts)
map("n", "<leader>wd", ":close<CR>", kopts)
map("n", "<leader>wD", ":only<CR>", kopts)

-- buffer
-- See: https://github.com/romgrk/barbar.nvim
map("n", "<C-j>", "<Cmd>BufferPrevious<CR>", kopts)
map("n", "<C-k>", "<Cmd>BufferNext<CR>", kopts)
map("n", "<leader>bd", "<Cmd>BufferClose<CR>", kopts)
map("n", "<leader>bD", "<Cmd>BufferCloseAllButCurrent<CR>", kopts)
map("n", "<leader>bu", "<Cmd>BufferRestore<CR>", kopts)

-- side bar
-- See: https://github.com/nvim-neo-tree/neo-tree.nvim
map("n", "<leader>t", ":Neotree toggle<CR>", kopts)
map("n", "<leader>e", ":Neotree focus<CR>", kopts)

-- Search config
-- See: https://github.com/kevinhwang91/nvim-hlslens
map("n", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
map("n", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
map("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
map("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
map("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
map("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

-- LSP
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
-- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }

		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
		vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "gi", "<cmd>Lspsaga finder imp", opts)
		vim.keymap.set("n", "gr", "<cmd>Lspsaga finder ref", opts)
		vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev", opts)
		vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next", opts)
		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
		vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
		vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

---- aerial
require("aerial").setup({
	on_attach = function(bufnr)
		vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
		vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
	end,
})
map("n", "<leader>a", "<cmd>AerialToggle!<CR>", kopts)

-- Git
---- lazygit & toggleterm
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	direction = "float",
	hidden = true,
})
---@diagnostic disable-next-line: lowercase-global
function _lazygit_toggle()
	lazygit:toggle()
end
map("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", kopts)
---- gitsigns
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function lmap(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		lmap("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		lmap("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		-- Actions
		lmap("n", "<leader>hs", gitsigns.stage_hunk)
		lmap("n", "<leader>hr", gitsigns.reset_hunk)

		lmap("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		lmap("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		-- lmap("n", "<leader>hS", gitsigns.stage_buffer)
		-- lmap("n", "<leader>hR", gitsigns.reset_buffer)
		lmap("n", "<leader>hp", gitsigns.preview_hunk)
		lmap("n", "<leader>hi", gitsigns.preview_hunk_inline)

		lmap("n", "<leader>gb", function()
			gitsigns.blame_line({ full = true })
		end)

		-- lmap("n", "<leader>gd", gitsigns.diffthis)
		--
		-- lmap("n", "<leader>gD", function()
		-- 	gitsigns.diffthis("~")
		-- end)

		-- map("n", "<leader>gQ", function()
		-- 	gitsigns.setqflist("all")
		-- end)
		-- map("n", "<leader>gq", gitsigns.setqflist)

		-- Toggles
		lmap("n", "<leader>gtb", gitsigns.toggle_current_line_blame)
		-- lmap("n", "<leader>gtd", gitsigns.toggle_deleted)
		-- lmap("n", "<leader>gtw", gitsigns.toggle_word_diff)

		-- Text object
		-- lmap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end,
})
---- diffview
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", kopts)

-- toggleterm
require("toggleterm").setup({
	size = 100,
	open_mapping = [[<c-t>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
})

-- Overseer
map("n", "<leader>!!", "<Cmd>OverseerRun<CR>", kopts)
map("n", "<leader>!t", "<Cmd>OverseerToggle<CR>", kopts)

-- Copilot
map("n", "<leader>cc", "<Cmd>CopilotChatToggle<CR>", kopts)
map("v", "<leader>cc", "<Cmd>CopilotChatToggle<CR>", kopts)

-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- dial
vim.keymap.set("n", "<C-a>", function()
	require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "<C-x>", function()
	require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("n", "g<C-a>", function()
	require("dial.map").manipulate("increment", "gnormal")
end)
vim.keymap.set("n", "g<C-x>", function()
	require("dial.map").manipulate("decrement", "gnormal")
end)
vim.keymap.set("v", "<C-a>", function()
	require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("v", "<C-x>", function()
	require("dial.map").manipulate("decrement", "visual")
end)
vim.keymap.set("v", "g<C-a>", function()
	require("dial.map").manipulate("increment", "gvisual")
end)
vim.keymap.set("v", "g<C-x>", function()
	require("dial.map").manipulate("decrement", "gvisual")
end)
