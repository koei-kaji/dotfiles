return {
  {
    "ixru/nvim-markdown",
    ft = { "markdown", "codecompanion" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      anti_conceal = { enabled = true },
      code = {
        border = "thick",
      },
    },
    enabled = not vim.g.vscode,
    ft = { "markdown", "codecompanion" },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = ":call mkdp#util#install()",
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      -- https://github.com/HakonHarnes/img-clip.nvim/issues/102
      default = {
        process_cmd = "convert - -set gamma 0.4545 -",
      },
    },
  },
  { "dhruvasagar/vim-table-mode" },
}
