return {
  {
    "zk-org/zk-nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("zk").setup({
        -- See Setup section below
      })
    end,
  },
}
