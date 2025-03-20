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

require("nvim-treesitter.configs").setup({
  ensure_installed = ensure_installed,
})

-- https://github.com/neovim/neovim/pull/26347#issuecomment-1837508178
vim.treesitter.start = (function(wrapped)
  return function(bufnr, lang)
    lang = lang or vim.fn.getbufvar(bufnr or "", "&filetype")
    pcall(wrapped, bufnr, lang)
  end
end)(vim.treesitter.start)

require("nvim-treesitter-textsubjects").configure({
  prev_selection = ",",
  keymaps = {
    ["."] = "textsubjects-smart",
    [";"] = "textsubjects-container-outer",
    ["i;"] = {
      "textsubjects-container-inner",
      desc = "Select inside containers (classes, functions, etc.)",
    },
  },
  disable = function(lang, bufnr)
    local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
    return not parser_ok or not parser
  end,
})
