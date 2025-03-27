return {
  {
    "zk-org/zk-nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("zk").setup({
        picker = "telescope",
        picker_options = {
          telescope = require("telescope.themes").get_ivy(),
        },
      })
    end,
  },
}
