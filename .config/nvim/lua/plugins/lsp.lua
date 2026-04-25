return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
    config = function()
      require("lspsaga").setup({
        ui = {
          code_action = "",
        },
        finder = {
          layout = "normal",
        },
        options = {
          theme = "catppuccin-mocha",
        },
      })

      -- Workaround: lspsaga finder の BufEnter autocmd 内で nvim_win_close が
      -- 呼ばれて E1312 になる問題を、layout:close() の nvim_win_close を
      -- vim.schedule + pcall でラップして回避
      local layout = require("lspsaga.layout")
      function layout:close()
        local left = self.left_winid
        local right = self.right_winid
        local ly = self.layout
        self.left_winid = nil
        self.right_winid = nil
        vim.schedule(function()
          if left and vim.api.nvim_win_is_valid(left) then
            pcall(vim.api.nvim_win_close, left, true)
          end
          if ly ~= "dropdown" and right and vim.api.nvim_win_is_valid(right) then
            pcall(vim.api.nvim_win_close, right, true)
          end
        end)
      end
    end,
  },
  {
    "stevearc/aerial.nvim",
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    -- event = "InsertEnter",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded",
      },
    },
  },
}
