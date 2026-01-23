return {
  {
    "folke/sidekick.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      cli = {
        prompts = {
          changes = "変更をレビューしてください",
          diagnostics = "{file}の diagnostics を修正してください\n{diagnostics}",
          diagnostics_all = "全ての diagnostics を修正してください\n{diagnostics_all}",
          document = "{function|line} にドキュメントを追加してください",
          explain = "{this} を説明してください",
          fix = "{this} を修正してください",
          optimize = "{this} を最適化するには？",
          review = "{file} の問題点や改善点をレビューしてください",
          tests = "{this} のテストを書いてください",
          translate = "{this} を日本語に翻訳してください",
          better_naming = "{this} のより良い命名を提案してください",
          refactor = "{this} をリファクタリングしてください",
          -- simple context prompts
          buffers = "{buffers}",
          file = "{file}",
          line = "{line}",
          position = "{position}",
          quickfix = "{quickfix}",
          selection = "{selection}",
          ["function"] = "{function}",
          class = "{class}",
        },
        picker = "telescope",
        tools = {
          claude = { cmd = { "claude" } },
          copilot = { cmd = { "copilot" } },
          gemini = { cmd = { "gemini" } },
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end,
        expr = true,
        desc = "Agent - goto/apply next edit",
      },
      {
        "<c-.>",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Agent - toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>ca",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Agent - toggle CLI",
      },
      {
        "<leader>cs",
        function()
          require("sidekick.cli").select()
        end,
        desc = "Agent - select CLI",
      },
      {
        "<leader>cd",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Agent - detach session",
      },
      {
        "<leader>ct",
        function()
          require("sidekick.cli").send({ msg = "{this}" })
        end,
        mode = { "n", "x" },
        desc = "Agent - send this",
      },
      {
        "<leader>cf",
        function()
          require("sidekick.cli").send({ msg = "{file}" })
        end,
        desc = "Agent - send file",
      },
      {
        "<leader>cv",
        function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end,
        mode = { "x" },
        desc = "Agent - send selection",
      },
      {
        "<leader>cp",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Agent - select prompt",
      },
      {
        "<leader>cc",
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        desc = "Agent - toggle Claude",
      },
    },
  },
}
