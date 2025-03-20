return {
  {
    "ixru/nvim-markdown",
    ft = { "markdown" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      anti_conceal = { enabled = true },
    },
    enabled = not vim.g.vscode,
    ft = { "markdown", "codecompanion" },
  },
}
