require("ai.codecompanion.fidget-spinner"):init()

require("codecompanion").setup({
	copilot = function()
		return require("codecompanion.adapters").extend("copilot", {
			schema = {
				model = {
					default = "claude-3.5-sonnet",
				},
			},
		})
	end,
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
	prompt_libraty = require("ai.codecompanion.prompt_library"),
})
