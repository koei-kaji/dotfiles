local augend = require("dial.augend")

require("dial.config").augends:register_group({
  default = {
    -- nonnegative decimal number (0, 1, 2, 3, ...)
    augend.integer.alias.decimal,
    -- nonnegative hex number  (0x01, 0x1a1f, etc.)
    augend.integer.alias.hex,
    -- datetime
    augend.date.alias["%Y/%m/%d"],
    augend.date.alias["%Y-%m-%d"],
    augend.date.alias["%Y年%-m月%-d日"],
    augend.date.alias["%Y年%-m月%-d日(%ja)"],
    augend.date.alias["%H:%M:%S"],
    augend.date.alias["%H:%M"],
    augend.constant.alias.ja_weekday,
    augend.constant.alias.ja_weekday_full,
    -- bool
    augend.constant.new({ elements = { "true", "false" } }),
    augend.constant.new({ elements = { "True", "False" } }),
    -- operand
    augend.constant.new({ elements = { "&&", "||" } }),
    augend.constant.new({ elements = { "and", "or" } }),
  },
})
