vim.g.mapleader = " "

local kopts = { noremap = true, silent = true }
local function _map(modes, lhs, rhs, desc)
	local opts = desc and vim.tbl_extend("force", kopts, { desc = desc }) or kopts
	vim.keymap.set(modes, lhs, rhs, opts)
end
local function nmap(lhs, rhs, desc)
	_map("n", lhs, rhs, desc)
end
local function vmap(lhs, rhs, desc)
	_map("v", lhs, rhs, desc)
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
local function cmap(lhs, rhs, desc)
	_map("c", lhs, rhs, desc)
end

-- core
imap("jj", "<ESC>")
imap("っj", "<ESC>")

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
nmap("p", "]p`]")
xmap("y", "mzy`z")
cmap("s ", "<C-c>:%s///g<Left><Left>")

nmap("x", '"_d')
nmap("X", '"_D')
xmap("x", '"_x')
omap("x", "d")

xmap("<", "<gv")
xmap(">", ">gv")

nmap("F<cr>", "{")
nmap("f<cr>", "}")

-- vim
nmap("<leader>qq", "<Cmd>q<CR>")
nmap("<leader>QQ", "<Cmd>qa<CR>")

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
nmap("<leader>t", "<Cmd>Neotree toggle<CR>")
nmap("<leader>e", "<Cmd>Neotree focus<CR>")

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
		vim.keymap.set("n", "gr", function()
			vim.cmd("Neotree close")
			vim.cmd("Lspsaga finder ref")
		end, opts)
		vim.keymap.set("n", "gR", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>dj", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
		vim.keymap.set("n", "<leader>dk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
		vim.keymap.set("n", "K", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover()
			end
		end, opts)
		vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
		vim.keymap.set("n", "<leader>l", "<cmd>Lspsaga code_action<CR>", opts)
		vim.keymap.set("n", "<leader>bf", function()
			vim.lsp.buf.format({ async = true })
			require("conform").format({ async = true })
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
---- lazygit
nmap("<leader>gg", "<cmd>LazyGit<CR>")
nmap("<leader>gc", "<cmd>LazyGitFilterCurrentFile<CR>")
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

		lmap("n", "<leader>hS", gitsigns.stage_buffer)
		lmap("n", "<leader>hR", gitsigns.reset_buffer)
		lmap("n", "<leader>hp", gitsigns.preview_hunk)
		lmap("n", "<leader>hi", gitsigns.preview_hunk_inline)
		lmap("n", "<leader>gb", gitsigns.blame)

		lmap("n", "<leader>gtb", gitsigns.toggle_current_line_blame)
	end,
})
nmap("<leader>hd", "<cmd>DiffviewOpen HEAD~1<CR>")
nmap("<leader>hh", "<cmd>DiffviewFileHistory %<CR>")
---- gitlinker
nvmap("<leader>gy", "<cmd>GitLink<CR>", "Yank git link")
nvmap("<leader>gY", "<cmd>GitLink!<CR>", "Open git link")

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

-- Copilot
nvmap("<leader>cc", "<Cmd>CopilotChatToggle<CR>")

-- telescope
local telescope = require("telescope")
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local conf = require("telescope.config").values

nmap("<leader>ff", builtin.find_files, "Find files")
nmap("<leader>fg", function()
	telescope.extensions.live_grep_args.live_grep_args()
end, "Live grep")
nmap("<leader>fb", builtin.buffers, "Find buffers")
nmap("<leader>fo", builtin.oldfiles, "Find old files")
nmap("<leader>fw", builtin.grep_string, "Find word under cursor")
nmap("<leader>fn", function()
	telescope.extensions.notify.notify(themes.get_ivy())
end)

-- harpoon
local harpoon = require("harpoon")
nmap("ha", function()
	harpoon:list():add()
	vim.notify("Added to harpoon")
end)
nmap("hL", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)
nmap("hj", function()
	harpoon:list():next()
end)
nmap("hk", function()
	harpoon:list():prev()
end)
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new(themes.get_ivy({}), {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end
nmap("hl", function()
	toggle_telescope(harpoon:list())
end, "Open harpoon window")

-- bookmarks
local bookmarks = require("bookmarks")
nmap("mm", bookmarks.bookmark_toggle)
nmap("mc", bookmarks.bookmark_clean)
nmap("mC", bookmarks.bookmark_clear_all)
nmap("mj", bookmarks.bookmark_next)
nmap("mk", bookmarks.bookmark_prev)
nmap("mL", bookmarks.bookmark_list)
nmap("ml", function()
	telescope.extensions.bookmarks.list(themes.get_ivy())
end)

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

-- ufo
local ufo = require("ufo")
nmap("zR", ufo.openAllFolds)
nmap("zM", ufo.closeAllFolds)

-- which-key
nmap("<leader>?", function()
	require("which-key").show({ global = false })
end, "Buffer Local Keymaps (which-key)")

-- gitlinker
nvmap("<leader>gy", "<cmd>GitLink<CR>", "Yank git link")
nvmap("<leader>gY", "<cmd>GitLink!<CR>", "Open git link")

-- treesj
nmap("<leader>m", function()
	require("treesj").toggle()
end)

-- neogen
-- nmap("<Leader>nf", ":lua require('neogen').generate()<CR>")
nmap("<Leader>nf", function()
	require("neogen").generate()
end)

-- codecompanion
nmap("<leader>ca", "<Cmd>CodeCompanionActions<CR>", "Code Companion - Actions")
nvmap("<leader>cc", "<Cmd>CodeCompanionChat Toggle<CR>", "Code Companion - Toggle")
nvmap("<leader>cl", "<Cmd>CodeCompanion /lsp<CR>", "Code Companion - Explain LSP diagnostic")
vmap("<leader>ce", "<Cmd>CodeCompanion /explain<CR>", "Code Companion - Explain code")
vmap("<leader>cf", "<Cmd>CodeCompanion /fix<CR><Esc>", "Code Companion - Fix code")
vmap("<leader>cR", "<Cmd>CodeCompanion /chat-review<CR>", "Code Companion - Review code")
vmap("<leader>cn", "<Cmd>CodeCompanion /chat-naming<CR>", "Code Companion - Better naming")
vmap("<leader>ct", "<Cmd>CodeCompanion /tests<CR>", "Code Companion - Generate unit test")
vmap("<leader>cr", "<Cmd>CodeCompanion /inline-refactor<CR><Esc>", "Code Companion - Refactor code")
vmap("<leader>cd", "<Cmd>CodeCompanion /inline-doc<CR><Esc>", "Code Companion - Add documentation")
