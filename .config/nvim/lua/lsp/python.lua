local lspconfig = require("lspconfig")
local utils = require("utils")

lspconfig.ruff.setup({})
lspconfig.pyright.setup({
    settings = {
        pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
        },
        python = {
            analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { "*" },
            },
            pythonPath = utils.path.find_git_root() .. "/.venv/bin/python",
        },
    },
})
