local M = {}

function M.linters_by_ft()
  return vim.tbl_extend(
    "force",
    {},
    -- add here
    require("linting.languages.php").linters_by_ft(),
    {}
  )
end

return M
