require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,
    },
    -- NOTE: Short path names for folders
    --       https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1344#issuecomment-1930909012
    components = {
      name = function(config, node, state)
        local components = require("neo-tree.sources.common.components")
        local name = components.name(config, node, state)
        if node:get_depth() == 1 then
          name.text = vim.fn.pathshorten(name.text, 2)
        end
        return name
      end,
    },
  },
  commands = {
    copy_selector = function(state)
      local node = state.tree:get_node()
      local filepath = node:get_id()
      local filename = node.name
      local modify = vim.fn.fnamemodify

      local vals = {
        ["BASENAME"] = modify(filename, ":r"),
        ["EXTENSION"] = modify(filename, ":e"),
        ["FILENAME"] = filename,
        ["PATH (CWD)"] = modify(filepath, ":."),
        ["PATH (HOME)"] = modify(filepath, ":~"),
        ["PATH"] = filepath,
        ["URI"] = vim.uri_from_fname(filepath),
      }

      local options = vim.tbl_filter(function(val)
        return vals[val] ~= ""
      end, vim.tbl_keys(vals))
      if vim.tbl_isempty(options) then
        vim.notify("No values to copy", vim.log.levels.WARN)
        return
      end
      table.sort(options)
      vim.ui.select(options, {
        prompt = "Choose to copy to clipboard:",
        format_item = function(item)
          return ("%s: %s"):format(item, vals[item])
        end,
      }, function(choice)
        local result = vals[choice]
        if result then
          vim.notify(("Copied: `%s`"):format(result))
          vim.fn.setreg("+", result)
        end
      end)
    end,
  },
  window = {
    mappings = {
      Y = "copy_selector",
    },
  },
})
