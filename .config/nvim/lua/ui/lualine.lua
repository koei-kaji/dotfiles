require("lualine").setup({
  options = {
    theme = "catppuccin-mocha",
  },
  sections = {
    lualine_c = { { "filename", path = 1 } },
  },
})
