vim.g.mapleader = " "

local kopts = { noremap = true, silent = true }
local function _map(modes, lhs, rhs, desc)
  local opts = desc and vim.tbl_extend("force", kopts, { desc = desc }) or kopts
  vim.keymap.set(modes, lhs, rhs, opts)
end
-- stylua: ignore start
local function nmap(lhs, rhs, desc) _map("n", lhs, rhs, desc) end
local function vmap(lhs, rhs, desc) _map("v", lhs, rhs, desc) end
local function nvmap(lhs, rhs, desc) _map({ "n", "v" }, lhs, rhs, desc) end
local function xmap(lhs, rhs, desc) _map("x", lhs, rhs, desc) end
local function imap(lhs, rhs, desc) _map("i", lhs, rhs, desc) end
local function omap(lhs, rhs, desc) _map("o", lhs, rhs, desc) end
-- stylua: ignore end

-- core
imap("jj", "<ESC>")
imap("っj", "<ESC>")
nvmap("j", "gj")
nvmap("k", "gk")
nvmap("<Down>", "gj")
nvmap("<Up>", "gk")
imap("<Down>", "<C-o>gj")
imap("<Up>", "<C-o>gk")
nvmap("$", "g_")
nvmap("H", "^")
nvmap("L", "g_")
nmap("Y", "yg_")
nmap("U", "<c-r>")
nmap("M", "%")
xmap("p", "P")
nmap("p", "]p`]")
nmap("P", "]P`]")
xmap("y", "mzy`z")
vim.cmd([[
cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 's'
]])

nmap("x", '"_d')
nmap("X", '"_D')
xmap("x", '"_x')
omap("x", "d")

xmap("<", "<gv")
xmap(">", ">gv")

nmap("F<cr>", "{")
nmap("f<cr>", "}")

-- vim
nmap("<leader>QQ", "<Cmd>qa<CR>", "Neovim - close")

-- window
nmap("<leader>w/", ":vsplit<CR><C-w>l", "Window - split vertically")
nmap("<leader>w-", ":split<CR><C-w>j", "Window - split horizontally")
nmap("<leader>wh", "<C-w>h", "Window - focus left")
nmap("<leader>wj", "<C-w>j", "Window - focus below")
nmap("<leader>wk", "<C-w>k", "Window - focus above")
nmap("<leader>wl", "<C-w>l", "Window - focus right")
nmap("<leader>wd", ":close<CR>", "Window - close")
nmap("<leader>wD", ":only<CR>", "Window - close others")
nmap("<leader>w.", "<Cmd>WindowsMaximize<CR>", "Window - maximize")
nmap("<leader>w_", "<Cmd>WindowsMaximizeVertically<CR>", "Window - maxmize vertically")
nmap("<leader>w?", "<Cmd>WindowsMaximizeHorizontally<CR>", "Window - maximize horizontally")
nmap("<leader>w=", "<Cmd>WindowsEqualize<CR>", "Window - reset")

-- buffer
-- See: https://github.com/romgrk/barbar.nvim
nmap("<C-j>", "<Cmd>BufferPrevious<CR>")
nmap("<C-k>", "<Cmd>BufferNext<CR>")
nmap("<leader>bb", "<Cmd>BufferOrderByName<CR>", "Buffer - order")
nmap("<leader>bj", "<Cmd>BufferMovePrevious<CR>", "Buffer - move previous")
nmap("<leader>bk", "<Cmd>BufferMoveNext<CR>", "Buffer - move next")
nmap("<leader>bd", "<Cmd>BufferClose<CR>", "Buffer - close")
nmap("<leader>bD", "<Cmd>BufferCloseAllButCurrent<CR>", "Buffer - close others")
nmap("<leader>bu", "<Cmd>BufferRestore<CR>", "Buffer - restore")
nmap("<leader>bp", "<Cmd>BufferPin<CR>", "Buffer - pin")
nmap("<leader>br", "<Cmd>Neotree reveal<CR>", "Explorer - reveal")

-- copy path
local function copy_to_clipboard(path, description)
  if path and path ~= "" then
    vim.fn.setreg("+", path)
    vim.notify(description .. ": " .. path, vim.log.levels.INFO)
  else
    vim.notify("No file path to copy", vim.log.levels.WARN)
  end
end

nmap("<leader>y", function()
  local current_file = vim.fn.expand("%:p")
  local cwd = vim.fn.getcwd()

  if current_file == "" then
    vim.notify("No file path to copy", vim.log.levels.WARN)
    return
  end

  -- 現在の作業ディレクトリからの相対パスを計算
  local relative_path = vim.fn.fnamemodify(current_file, ":s?" .. cwd .. "/??")

  -- もし相対パスが絶対パスと同じなら、ファイルがcwd外にある
  if relative_path == current_file then
    vim.notify("File is outside current working directory", vim.log.levels.ERROR)
    return
  end

  copy_to_clipboard(relative_path, "Relative path copied")
end, "Copy relative path to clipboard")

-- side bar
-- See: https://github.com/nvim-neo-tree/neo-tree.nvim
nmap("<leader>wt", "<Cmd>Neotree toggle<CR>", "Explorer - toggle")

nmap("<leader>we", "<Cmd>Neotree focus<CR>", "Explorer - focus")

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
nmap("<leader>do", vim.diagnostic.open_float, "Diagnostic - show in float")
nmap("<leader>dq", vim.diagnostic.setloclist, "Diagnostic - select in loclist")

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings helper
    local function lmap(modes, lhs, rhs, desc)
      local opts = desc and vim.tbl_extend("force", kopts, { desc = desc, buffer = ev.buf }) or { buffer = ev.buf }
      vim.keymap.set(modes, lhs, rhs, opts)
    end

    lmap("n", "gD", "<cmd>Lspsaga goto_definition<CR>", "LSP - goto definition")
    lmap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", "LSP - peek definition")
    lmap("n", "gt", "<cmd>Lspsaga goto_type_definition<CR>", "LSP - goto type definition")
    lmap("n", "gi", "<cmd>Lspsaga finder imp<CR>", "LSP - find implementations")
    lmap("n", "gr", function()
      vim.cmd("Neotree close")
      vim.cmd("Lspsaga finder ref")
    end, "LSP - find references")
    lmap("n", "gR", vim.lsp.buf.references, "LSP - show references")
    lmap("n", "<leader>dj", "<cmd>Lspsaga diagnostic_jump_next<CR>", "LSP - next diagnostic")
    lmap("n", "<leader>dk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "LSP - previous diagnostic")
    lmap("n", "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, "LSP - show hover")
    lmap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "LSP - rename symbol")
    lmap("n", "<leader>l", "<cmd>Lspsaga code_action<CR>", "LSP - code action")
    lmap("n", "<leader>bf", function()
      vim.lsp.buf.format({ async = true })
      require("conform").format({ async = true })
    end, "LSP - format buffer")
  end,
})

---- aerial
require("aerial").setup({
  on_attach = function(bufnr)
    -- Buffer local mappings helper
    local function amap(modes, lhs, rhs, desc)
      local opts = desc and vim.tbl_extend("force", kopts, { desc = desc, buffer = bufnr }) or { buffer = bufnr }
      vim.keymap.set(modes, lhs, rhs, opts)
    end

    amap("n", "{", "<cmd>AerialPrev<CR>")
    amap("n", "}", "<cmd>AerialNext<CR>")
  end,
})
nmap("<leader>a", "<cmd>AerialToggle!<CR>", "Explorer - toggle symbol")

-- Git
---- lazygit
nmap("<leader>gg", "<cmd>LazyGit<CR>", "Git - open LazyGit")
nmap("<leader>gc", "<cmd>LazyGitFilterCurrentFile<CR>", "Git - open current file history")
require("gitsigns").setup({
  signs = {
    add = { text = "▌" },
    change = { text = "▌" },
  },
  signs_staged = {
    add = { text = "▌" },
    change = { text = "▌" },
  },
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    -- Buffer local mappings helper
    local function gmap(modes, lhs, rhs, desc)
      local opts = desc and vim.tbl_extend("force", kopts, { desc = desc, buffer = bufnr }) or { buffer = bufnr }
      vim.keymap.set(modes, lhs, rhs, opts)
    end

    gmap("n", "<leader>hk", function()
      if vim.wo.diff then
        vim.cmd.normal({ "<leader>hj", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, "Git - previous hunk")

    gmap("n", "<leader>hj", function()
      if vim.wo.diff then
        vim.cmd.normal({ "<leader>hk", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, "Git - next hunk")

    -- Actions
    gmap("n", "<leader>hs", gitsigns.stage_hunk, "Git - stage hunk")
    gmap("n", "<leader>hr", gitsigns.reset_hunk, "Git - reset hunk")

    -- stylua: ignore start
    gmap("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git - stage hunk")
    gmap("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git - reset hunk")
    -- stylua: ignore end

    gmap("n", "<leader>hS", gitsigns.stage_buffer, "Git - stage buffer")
    gmap("n", "<leader>hR", gitsigns.reset_buffer, "Git - reset buffer")
    gmap("n", "<leader>hp", gitsigns.preview_hunk, "Git - preview hunk")
    gmap("n", "<leader>hi", gitsigns.preview_hunk_inline, "Git - preview hunk inline")
    gmap("n", "<leader>gb", gitsigns.blame, "Git - blame line")

    gmap("n", "<leader>gtb", gitsigns.toggle_current_line_blame, "Git - toggle blame line")
  end,
})
vim.cmd([[cabbrev dc DiffviewClose]])
nmap("<leader>hd", "<cmd>DiffviewOpen HEAD~1<CR>", "Git - open diffview")
---- gitlinker
nvmap("<leader>gy", "<cmd>GitLink<CR>", "Git - yank link")
nvmap("<leader>gY", "<cmd>GitLink!<CR>", "Git - open link")

-- telescope
local builtin = require("telescope.builtin")
local telescope = require("telescope")
local themes = require("telescope.themes")
local conf = require("telescope.config").values
local previewers = require("telescope.previewers")
local delta = previewers.new_termopen_previewer({
  get_command = function(entry)
    if entry.status == "??" or "A " then
      return { "git", "diff", entry.value }
    end

    return { "git", "diff", entry.value .. "^!" }
  end,
})

nmap("<leader>ff", builtin.find_files, "Search - files")
nmap("<leader>fb", builtin.buffers, "Search - buffers")
nmap("<leader>fo", builtin.oldfiles, "Search - old files")
nmap("<leader>fw", builtin.grep_string, "Search - word under cursor")
nmap("<leader>ft", "<Cmd>TodoTelescope<CR>", "Search - TODO comments")
-- stylua: ignore start
nmap("<leader>fG", function() builtin.git_status({previewer = delta}) end, "Search - uncommitted files")
nmap("<leader>fg", function() telescope.extensions.live_grep_args.live_grep_args() end, "Search - grep")
nmap("<leader>fn", function() telescope.extensions.notify.notify(themes.get_ivy()) end, "Search - notifications")
-- stylua: ignore end

-- harpoon
local harpoon = require("harpoon")
nmap("<leader>ma", function()
  harpoon:list():add()
  vim.notify("Added to harpoon")
end, "Harpoon - add")
nmap("<leader>md", function()
  harpoon:list():remove()
  vim.notify("Removed from harpoon")
end, "Harpoon - remove")
nmap("<leader>mD", function()
  harpoon:list():clear()
  vim.notify("Clear all")
end, "Harpoon - clear all")
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
-- stylua: ignore start
nmap("<leader>mj", function() harpoon:list():next() end, "Harpoon - move next")
nmap("<leader>mk", function() harpoon:list():prev() end, "Harpoon - previous")
nmap("<leader>ml", function() toggle_telescope(harpoon:list()) end, "Harpoon - open telescope")
nmap("<leader>mL", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "Harpoon - toggle menu")
-- stylua: ignore end

-- bookmarks
local bookmarks = require("bookmarks")
nmap("mm", bookmarks.bookmark_toggle)
nmap("md", bookmarks.bookmark_clean)
nmap("mD", bookmarks.bookmark_clear_all)
nmap("mj", bookmarks.bookmark_next)
nmap("mk", bookmarks.bookmark_prev)
-- stylua: ignore start
nmap("ml", function() telescope.extensions.bookmarks.list(themes.get_ivy()) end)
-- stylua: ignore end
nmap("mL", bookmarks.bookmark_list)

-- dial
-- stylua: ignore start
nmap("<C-a>", function() require("dial.map").manipulate("increment", "normal") end)
nmap("<C-x>", function() require("dial.map").manipulate("decrement", "normal") end)
nmap("g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end)
nmap("g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end)
vmap("<C-a>", function() require("dial.map").manipulate("increment", "visual") end)
vmap("<C-x>", function() require("dial.map").manipulate("decrement", "visual") end)
vmap("g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end)
vmap("g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end)
-- stylua: ignore end

-- ufo
local ufo = require("ufo")
nmap("zR", ufo.openAllFolds, "Code - open all folds")
nmap("zM", ufo.closeAllFolds, "Code - close all folds")

-- gitlinker
nvmap("<leader>gy", "<cmd>GitLink<CR>", "Git - Yank git link")
nvmap("<leader>gY", "<cmd>GitLink!<CR>", "Git - Open git link")

-- treesj
-- stylua: ignore start
nmap("<leader>M", function() require("treesj").toggle() end, "Code - toggle node under cursor")
-- stylua: ignore end

-- neogen
-- stylua: ignore start
nmap("<Leader>nf", function() require("neogen").generate() end, "Code - generate annotations")
-- stylua: ignore end

-- codecompanion
vim.cmd([[cabbrev cc CodeCompanion]])
vim.cmd([[cabbrev ccc CodeCompanionChat]])
nvmap("<leader>ca", "<Cmd>CodeCompanionActions<CR>", "Agent - actions")
nmap("<leader>cc", "<Cmd>CodeCompanionChat Toggle<CR>", "Agent - toggle chat")
vmap("<leader>cc", "<Cmd>CodeCompanionChat<CR>", "Agent - add code to chat")
nvmap("<leader>cl", "<Cmd>CodeCompanion /lsp<CR>", "Agent - explain LSP diagnostic")
vmap("<leader>ce", "<Cmd>CodeCompanion /explain<CR>", "Agent - explain code")
vmap("<leader>cf", "<Cmd>CodeCompanion /fix<CR><Esc>", "Agent - Fix code")
vmap("<leader>cR", "<Cmd>CodeCompanion /chat-review<CR>", "Agent - review code")
vmap("<leader>cn", "<Cmd>CodeCompanion /chat-naming<CR>", "Agent - better naming")
vmap("<leader>ct", "<Cmd>CodeCompanion /chat-translate<CR><Esc>", "Agent - translate into JP")
vmap("<leader>cr", "<Cmd>CodeCompanion /inline-refactor<CR><Esc>", "Agent - refactor code")
vmap("<leader>cd", "<Cmd>CodeCompanion /inline-doc<CR><Esc>", "Agent - add documentation")
nmap("<leader>cS", function()
  local name = vim.fn.input("Save as: ")
  if name and name ~= "" then
    vim.cmd("CodeCompanionSave " .. name)
  end
end, "Agent - save chat")
nmap("<leader>co", "<Cmd>CodeCompanionOpen<CR>", "Agent - open past chat")

-- markdown
nmap("<C-p>", "<Plug>MarkdownPreviewToggle", "Markdown - toggle preview")
nmap("<leader>p", "<Cmd>PasteImage<CR>", "Image - paste from clipboard")

-- zk
nmap("<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", "Search - zk note")
vmap("<leader>zf", ":'<,'>ZkMatch<CR>", "Search - zk note with selection")
nmap("<leader>zt", "<Cmd>ZkTags<CR>", "Search - zk tags")

vim.cmd([[cabbrev mcp MCPHub]])
