local ok, secrets = pcall(require, "core.secrets")
if ok then
  print("Loaded secrets")
else
  print("No secrets file found")
end

require("core.options")

require("core.lazy")

require("core.ui")
require("core.lsp")
require("core.editing")
require("core.completion")
require("core.formatting")
require("core.linting")
require("core.ai")

require("core.keymaps")

vim.cmd([[colorscheme tokyonight-night]])
