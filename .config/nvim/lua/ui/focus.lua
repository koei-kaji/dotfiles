require("focus").setup({
  autoresize = { enable = false },
})

vim.api.nvim_create_user_command("FocusResizeOnce", function()
  vim.cmd("FocusEnable")
  vim.schedule(function()
    vim.cmd("FocusDisable")
  end)
end, { desc = "Run focus auto-resize once" })

local ignore_filetypes = {
  "qf",
  "neo-tree",
  "aerial",
  "gitsigns-blame",
}
local ignore_buftypes = { "nofile", "prompt", "popup" }

local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

vim.api.nvim_create_autocmd("WinEnter", {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
      vim.w.focus_disable = true
    else
      vim.w.focus_disable = false
    end
  end,
  desc = "Disable focus autoresize for BufType",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
      vim.b.focus_disable = true
    else
      vim.b.focus_disable = false
    end
  end,
  desc = "Disable focus autoresize for FileType",
})
