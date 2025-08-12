require("barbar").setup({
  exclude_ft = { "qf" },
  sidebar_filetypes = {
    ["neo-tree"] = { event = "BufWipeout" },
  },
  auto_hide = true,
  icons = {
    separator = { left = "", right = "" },
  },
})
