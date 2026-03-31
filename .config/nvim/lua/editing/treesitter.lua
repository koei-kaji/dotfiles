local ensure_installed = {
  "bash",
  "c",
  "c_sharp",
  "cpp",
  "css",
  "dockerfile",
  "go",
  "html",
  "java",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "php",
  "python",
  "query",
  "rust",
  "scss",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "xml",
  "yaml",
}

require("nvim-treesitter").install(ensure_installed)

require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
    include_surrounding_whitespace = false,
  },
})

vim.keymap.set({ "x", "o" }, "af", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end, { desc = "Select outer function" })
vim.keymap.set({ "x", "o" }, "if", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end, { desc = "Select inner function" })
vim.keymap.set({ "x", "o" }, "ac", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end, { desc = "Select outer class" })
vim.keymap.set({ "x", "o" }, "ic", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end, { desc = "Select inner class" })
vim.keymap.set({ "x", "o" }, "aa", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
end, { desc = "Select outer parameter" })
vim.keymap.set({ "x", "o" }, "ia", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
end, { desc = "Select inner parameter" })
