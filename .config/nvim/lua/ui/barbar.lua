require("barbar").setup({
  exclude_ft = { "qf" },
  sidebar_filetypes = {
    ["neo-tree"] = { event = "BufWipeout" },
  },
  icons = {
    separator = { left = "", right = "" },
  },
})
