require("ai.codecompanion.fidget-spinner"):init()

require("codecompanion").setup({
  adapters = {
    copilot = function()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            default = "claude-3.7-sonnet",
          },
        },
      })
    end,
  },
  display = {
    diff = {
      provider = "mini_diff",
    },
    chat = {
      auto_scroll = false,
      show_header_separator = true,
    },
  },
  strategies = {
    chat = {
      adapter = "copilot",
      roles = {
        llm = function(adapter)
          return "  " .. adapter.formatted_name .. ""
        end,
        user = " Koei",
      },
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
