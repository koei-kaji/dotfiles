local util = require("lspconfig.util")

local vue_language_server_path = vim.fn.stdpath("data")
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local function read_package_json(root_dir)
  local package_json = root_dir .. "/package.json"
  local ok, lines = pcall(vim.fn.readfile, package_json)

  if not ok then
    return nil
  end

  local decode_ok, package = pcall(vim.json.decode, table.concat(lines, "\n"))

  if not decode_ok then
    return nil
  end

  return package
end

local function has_vue_dependency(root_dir)
  local package = read_package_json(root_dir)

  if type(package) ~= "table" then
    return false
  end

  for _, dependency_type in ipairs({ "dependencies", "devDependencies" }) do
    local dependencies = package[dependency_type]
    if type(dependencies) == "table" and dependencies.vue ~= nil then
      return true
    end
  end

  return false
end

return {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_language_server_path,
            languages = { "vue" },
            configNamespace = "typescript",
          },
        },
      },
    },
  },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git")(fname)

    if root_dir ~= nil and has_vue_dependency(root_dir) then
      on_dir(root_dir)
    end
  end,
}
