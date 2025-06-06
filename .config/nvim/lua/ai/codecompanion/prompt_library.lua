local function code_block(context)
  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

  return "```" .. context.filetype .. "\n" .. code .. "\n```"
end

local function prompt(context, instructions)
  return instructions .. "\n\n" .. code_block(context) .. "\n\n"
end

return {
  ["Inline Document"] = {
    strategy = "inline",
    description = "Add documentation for code.",
    opts = {
      modes = { "v" },
      short_name = "inline-doc",
      auto_submit = true,
      stop_context_insertion = true,
      user_prompt = false,
    },
    prompts = {
      {
        role = "user",
        content = function(context)
          local instructions =
            "Please provide documentation in Japanese in comment code for the following code and suggest to have better naming to improve readability:"

          return prompt(context, instructions)
        end,
        opts = {
          contains_code = true,
        },
      },
    },
  },
  ["Inline Refactor"] = {
    strategy = "inline",
    description = "Refactor the provided code.",
    opts = {
      modes = { "v" },
      short_name = "inline-refactor",
      auto_submit = true,
      stop_context_insertion = true,
      user_prompt = false,
    },
    prompts = {
      {
        role = "user",
        content = function(context)
          local instructions =
            "Please refactor the following code to improve its claritty and readability. When you provide documentation, you must write in Japanese:"
          return prompt(context, instructions)
        end,
        opts = {
          contains_code = true,
        },
      },
    },
  },
  ["Chat Review"] = {
    strategy = "chat",
    description = "Review the provided code.",
    opts = {
      modes = { "v" },
      short_name = "chat-review",
      auto_submit = true,
      stop_context_insertion = true,
      user_prompt = false,
    },
    prompts = {
      {
        role = "user",
        content = function(context)
          local instructions =
            "Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability:"
          return prompt(context, instructions)
        end,
        opts = {
          contains_code = true,
        },
      },
    },
  },
  ["Chat Better Naming"] = {
    strategy = "chat",
    description = "Give better naming for the provided code.",
    opts = {
      modes = { "v" },
      short_name = "chat-naming",
      auto_submit = true,
      stop_context_insertion = true,
      user_prompt = false,
    },
    prompts = {
      {
        role = "user",
        content = function(context)
          local instructions = "Please provide better names for the following variables and functions:"
          return prompt(context, instructions)
        end,
        opts = {
          contains_code = true,
        },
      },
    },
  },
  ["Chat Translate into Japanese"] = {
    strategy = "chat",
    description = "Translate English into Japanese",
    opts = {
      modes = { "v" },
      short_name = "chat-translate",
      auto_submit = true,
      stop_context_insertion = true,
      user_prompt = false,
    },
    prompts = {
      {
        role = "user",
        content = function(context)
          local instructions = "Please translate the following sentences into Japanese:"
          return prompt(context, instructions)
        end,
        opts = {
          contains_code = true,
        },
      },
    },
  },
}
