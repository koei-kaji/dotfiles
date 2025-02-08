local ok, secrets = pcall(require, "core.secrets")
if ok then
	print("Loaded secrets")
else
	print("No secrets file found")
end
require("core.lazy")
require("core.lsp")
require("core.keymaps")

vim.cmd([[colorscheme tokyonight-night]])
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.pumblend = 0

vim.g.mapleader = " "

vim.opt.shell = "/bin/zsh"
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.textwidth = 0
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.clipboard = "unnamed"
vim.opt.number = true
vim.opt.scrolloff = 999

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldenable = true
vim.o.foldlevel = 99

vim.cmd("syntax on")
