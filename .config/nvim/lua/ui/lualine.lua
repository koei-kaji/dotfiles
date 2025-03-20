require("lualine").setup({
  options = {
    theme = "tokyonight-night",
  },
  sections = {
    lualine_c = { { "filename", path = 1 } },
  },
})
