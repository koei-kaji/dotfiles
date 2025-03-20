require("ai.codecompanion.fidget-spinner"):init()

require("codecompanion").setup({
  adapters = {
    copilot = function()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            -- default = "claude-3.5-sonnet",
            default = "gpt-4o-2024-11-20",
          },
        },
      })
    end,
  },
  display = {
    diff = {
      provider = "mini_diff",
    },
  },
  strategies = {
    chat = {
      adapter = "copilot",
      roles = { llm = "  Copilot Chat", user = "Koei" },
    },
    inline = {
      adapter = "copilot",
    },
    agent = {
      adapter = "copilot",
    },
  },
  opts = {
    language = "Japanese",
  },
  prompt_library = require("ai.codecompanion.prompt_library"),
})
