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
      checkbox = {
        enabled = true,
        unchecked = {
          icon = "   󰄱 ",
        },
        checked = {
          icon = "   󰱒 ",
        },
      },
    },
    enabled = not vim.g.vscode,
    ft = { "markdown", "codecompanion" },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown", "codecompanion" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown", "codecompanion" }
    end,
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
