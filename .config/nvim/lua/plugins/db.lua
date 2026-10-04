return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1

    -- 接続情報は gitignore 済みの core.secrets に定義する（M.dbs）。
    -- secrets.lua 未配置の環境でも壊れないよう pcall で読み込む。
    local ok, secrets = pcall(require, "core.secrets")
    if ok and secrets.dbs then
      vim.g.dbs = secrets.dbs
    end
  end,
}
