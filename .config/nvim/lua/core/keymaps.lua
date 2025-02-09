vim.g.mapleader = " "

local kopts = { noremap = true, silent = true }
local function _map(modes, lhs, rhs, desc)
	local opts = desc and vim.tbl_extend("force", kopts, { desc = desc }) or kopts
	vim.keymap.set(modes, lhs, rhs, opts)
end
local function nmap(lhs, rhs, desc)
	_map("n", lhs, rhs, desc)
end
local function nvmap(lhs, rhs, desc)
	_map({ "n", "v" }, lhs, rhs, desc)
end
local function xmap(lhs, rhs, desc)
	_map("x", lhs, rhs, desc)
end
local function imap(lhs, rhs, desc)
	_map("i", lhs, rhs, desc)
end
local function omap(lhs, rhs, desc)
	_map("o", lhs, rhs, desc)
end

-- core
imap("jj", "<ESC>")

nmap("j", "gj")
nmap("k", "gk")
nmap("<Down>", "gj")
nmap("<Up>", "gk")
nvmap("H", "^")
nvmap("L", "$")
nmap("Y", "y$")
nmap("U", "<c-r>")
nmap("M", "%")
xmap("p", "P")
nmap("p", "]p`]")
nmap("P", "]P`]")

nmap("x", '"_d')
nmap("X", '"_D')
xmap("x", '"_x')
omap("x", "d")

xmap("<", "<gv")
xmap(">", ">gv")

nmap("F<cr>", "{")
nmap("f<cr>", "}")

nmap("<leader>l", "<Cmd>noh<CR>")

-- vim
nmap("<leader>q", "<Cmd>q<CR>")
nmap("<leader>Q", "<Cmd>qa<CR>")

-- window
nmap("<leader>w/", ":vsplit<CR><C-w>l")
nmap("<leader>w-", ":split<CR><C-w>j")
nmap("<leader>wh", "<C-w>h")
nmap("<leader>wj", "<C-w>j")
nmap("<leader>wk", "<C-w>k")
nmap("<leader>wl", "<C-w>l")
nmap("<leader>wd", ":close<CR>")
nmap("<leader>wD", ":only<CR>")

-- buffer
-- See: https://github.com/romgrk/barbar.nvim
nmap("<C-j>", "<Cmd>BufferPrevious<CR>")
nmap("<C-k>", "<Cmd>BufferNext<CR>")
nmap("<leader>bd", "<Cmd>BufferClose<CR>")
nmap("<leader>bD", "<Cmd>BufferCloseAllButCurrent<CR>")
nmap("<leader>bu", "<Cmd>BufferRestore<CR>")
nmap("<leader>br", "<Cmd>Neotree reveal<CR>")

-- side bar
-- See: https://github.com/nvim-neo-tree/neo-tree.nvim
nmap("<leader>t", ":Neotree toggle<CR>")
nmap("<leader>e", ":Neotree focus<CR>")

-- Search config
-- See: https://github.com/kevinhwang91/nvim-hlslens
nmap("n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]])
nmap("N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]])
nmap("*", [[*<Cmd>lua require('hlslens').start()<CR>]])
nmap("#", [[#<Cmd>lua require('hlslens').start()<CR>]])
nmap("g*", [[g*<Cmd>lua require('hlslens').start()<CR>]])
nmap("g#", [[g#<Cmd>lua require('hlslens').start()<CR>]])

-- LSP
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
nmap("<leader>do", vim.diagnostic.open_float, "Open diagnostic float window")
nmap("<leader>dq", vim.diagnostic.setloclist, "Select diagnostic in loclist")

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

		-- vim.keymap.set("n", "gD", "<cmd>Lspsaga goto_definition<CR>", opts)
		vim.keymap.set("n", "gD", "<cmd>Lspsaga goto_definition<CR>", opts)
		vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
		vim.keymap.set("n", "gt", "<cmd>Lspsaga goto_type_definition<CR>", opts)
		vim.keymap.set("n", "gi", "<cmd>Lspsaga finder imp<CR>", opts)
		vim.keymap.set("n", "gr", "<cmd>Lspsaga finder ref<CR>", opts)
		vim.keymap.set("n", "<leader>dj", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
		vim.keymap.set("n", "<leader>dk", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
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
nmap("<leader>a", "<cmd>AerialToggle!<CR>")

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
nmap("<leader>gg", "<cmd>lua _lazygit_toggle()<CR>")
---- gitsigns
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function lmap(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		lmap("n", "<leader>hk", function()
			if vim.wo.diff then
				vim.cmd.normal({ "<leader>hj", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		lmap("n", "<leader>hj", function()
			if vim.wo.diff then
				vim.cmd.normal({ "<leader>hk", bang = true })
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

		lmap("n", "<leader>gtb", gitsigns.toggle_current_line_blame)
	end,
})
nmap("<leader>hd", "<cmd>DiffviewOpen HEAD~1<CR>")
nmap("<leader>hh", "<cmd>DiffviewFileHistory %<CR>")

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

-- FIXME: ちょっと使いにくいのでコメントアウトする。Overseer 自体不要かも
-- -- Overseer
-- map("n", "<leader>!", "<Cmd>OverseerToggle<CR>", kopts)

-- Copilot
nvmap("<leader>cc", "<Cmd>CopilotChatToggle<CR>")

-- telescope
local builtin = require("telescope.builtin")
nmap("<leader>ff", builtin.find_files, "Telescope find files")
nmap("<leader>fg", builtin.live_grep, "Telescope live grep")
nmap("<leader>fb", builtin.buffers, "Telescope buffers")
nmap("<leader>fh", builtin.help_tags, "Telescope help tags")

local telescope = require("telescope")
telescope.load_extension("notify")
nmap("<leader>fn", function()
	telescope.extensions.notify.notify()
end)

-- dial
nmap("<C-a>", function()
	require("dial.map").manipulate("increment", "normal")
end)
nmap("<C-x>", function()
	require("dial.map").manipulate("decrement", "normal")
end)
nmap("g<C-a>", function()
	require("dial.map").manipulate("increment", "gnormal")
end)
nmap("g<C-x>", function()
	require("dial.map").manipulate("decrement", "gnormal")
end)
nmap("<C-a>", function()
	require("dial.map").manipulate("increment", "visual")
end)
nmap("<C-x>", function()
	require("dial.map").manipulate("decrement", "visual")
end)
nmap("g<C-a>", function()
	require("dial.map").manipulate("increment", "gvisual")
end)
nmap("g<C-x>", function()
	require("dial.map").manipulate("decrement", "gvisual")
end)
