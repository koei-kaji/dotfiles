require("core.lazy")
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

vim.cmd("syntax on")
