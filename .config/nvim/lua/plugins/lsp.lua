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

      -- Workaround: definitionProvider がない buffer で peek_definition を呼ぶと
      -- lspsaga 側の pending_request が戻らず、以後ずっと "already been sent"
      -- になるため、未対応 buffer ではリクエスト自体を送らない。
      local definition = require("lspsaga.definition")
      local raw_definition_request = definition.definition_request
      function definition:definition_request(method, handler_T, args)
        local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf(), method = method })
        if vim.tbl_isempty(clients) then
          self.pending_request = false
          vim.notify("[lspsaga] no LSP client supports " .. method, vim.log.levels.WARN)
          return
        end

        local request_token = {}
        self._dotfiles_request_token = request_token
        local ok, err = pcall(raw_definition_request, self, method, handler_T, args)
        if not ok then
          self.pending_request = false
          error(err)
        end

        vim.defer_fn(function()
          if self._dotfiles_request_token == request_token and self.pending_request then
            self.pending_request = false
          end
        end, 10000)
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
