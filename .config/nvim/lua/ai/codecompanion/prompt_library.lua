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
			role = "user",
			content = function(context)
				local instructions =
					"Please provide documentation in comment code for the following code and suggest to have better naming to improve readability:"

				return prompt(context, instructions)
			end,
			opts = {
				contains_code = true,
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
			role = "user",
			content = function(context)
				local instructions = "Please refactor the following code to improve its claritty and readability:"
				return prompt(context, instructions)
			end,
			opts = {
				contains_code = true,
			},
		},
	},
	["Inline Review"] = {
		strategy = "inline",
		description = "Review the provided code.",
		opts = {
			modes = { "v" },
			short_name = "inline-review",
			auto_submit = true,
			stop_context_insertion = true,
			user_prompt = false,
		},
		prompts = {
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
}
