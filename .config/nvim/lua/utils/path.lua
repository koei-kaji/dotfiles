local M = {}

M.find_git_root = function()
    local d = vim.fn.expand("%:p:h", nil, nil)
    for _ = 1, 10 do
        if vim.fn.isdirectory(d .. "/.git/") ~= 0 or vim.fn.filereadable(d .. "/.git") ~= 0 then
            return d
        end
        d = d .. "/.."
    end
    return "."
end

return M
