local M = {}

function M.formatters_by_ft()
	return vim.tbl_extend(
		"force",
		{},
		require("formatting.languages.js").formatters_by_ft(),
		-- add here
		{
			["*"] = { "codespell" },
			["_"] = { "trim_newlines", "trim_whitespace" },
		}
	)
end

function M.formatters()
	return vim.tbl_extend(
		"force",
		{},
		require("formatting.languages.js").formatters(),
		-- add here
		{}
	)
end

return M
