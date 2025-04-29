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
    action_palette = {
      provider = "default",
    },
    diff = {
      provider = "mini_diff",
    },
    chat = {
      auto_scroll = false,
      show_header_separator = true,
    },
  },
  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        make_vars = true,
        make_slash_commands = true,
        show_result_in_chat = true,
      },
    },
  },
  strategies = {
    chat = {
      adapter = "copilot",
      roles = {
        -- https://github.com/olimorris/codecompanion.nvim/discussions/1094
        llm = function(adapter)
          local model = ""
          -- Try to get the model name from the adapter
          if adapter.schema and adapter.schema.model and adapter.schema.model.default then
            model = adapter.schema.model.default
            if type(model) == "function" then
              model = model(adapter)
            end
          end

          return "  " .. adapter.formatted_name .. " (" .. model .. ")"
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

require("ai.codecompanion.extra_commands")
