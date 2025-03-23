local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")
local npairs = require("nvim-autopairs")

-- https://github.com/windwp/nvim-autopairs/blob/6522027785b305269fa17088395dfc0f456cedd2/lua/nvim-autopairs/rules/basic.lua#L43-L46
npairs.add_rules({
  Rule("<!--", "-->", { "codecompanion" }):with_cr(cond.none()),
  Rule("```", "```", { "codecompanion" }):with_pair(cond.not_before_char("`", 3)),
  Rule("```.*$", "```", { "codecompanion" }):only_cr():use_regex(true),
})
