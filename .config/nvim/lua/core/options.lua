vim.g.mapleader = " "

vim.opt.shell = "/bin/zsh"
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.scrolloff = 999
vim.opt.winblend = 0
vim.opt.pumblend = 0
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.textwidth = 0
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.clipboard = "unnamed"
vim.opt.foldcolumn = "auto:9"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep:│,foldclose:]]
vim.opt.splitright = true
vim.opt.relativenumber = true
vim.opt.list = true
vim.opt.listchars = [[tab:·┈,trail:￮,multispace:￮,lead:·,extends:▶,precedes:◀,nbsp:‿]]
vim.opt.cursorline = true

-- https://github.com/neovim/neovim/issues/20457#issuecomment-1266782345
vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
  config = config or {}
  config.focus_id = ctx.method
  if not (result and result.contents) then
    return
  end
  local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
  markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
  if vim.tbl_isempty(markdown_lines) then
    return
  end
  return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
end
