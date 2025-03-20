return {
  { "lewis6991/gitsigns.nvim" },
  {
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup()
    end,
  },
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
