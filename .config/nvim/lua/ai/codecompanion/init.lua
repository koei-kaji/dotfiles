require("ai.codecompanion.fidget-spinner"):init()

require("codecompanion").setup({
  interactions = {
    chat = {
      adapter = {
        name = "copilot",
        model = "gpt-4o",
      },
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
      adapter = {
        name = "copilot",
        model = "gpt-4o",
      },
      keymaps = {
        accept_change = {
          modes = { n = "ga" },
          description = "Accept the suggested change",
        },
        reject_change = {
          modes = { n = "gr" },
          opts = { nowait = true },
          description = "Reject the suggested change",
        },
      },
    },
  },
  display = {
    -- See: builtin actions:
    --      https://github.com/olimorris/codecompanion.nvim/tree/main/lua/codecompanion/actions/builtins
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
  opts = {
    language = "Japanese",
  },
  prompt_library = {
    markdown = {
      dirs = {
        "~/.config/nvim/lua/ai/codecompanion/prompts",
      },
    },
  },
})

require("ai.codecompanion.extra_commands")
