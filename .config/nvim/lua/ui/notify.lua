local notify = require("notify")
notify.setup({
  timeout = 500,
})
vim.notify = notify
