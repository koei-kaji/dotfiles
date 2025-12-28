local wezterm = require("wezterm")
local config = wezterm.config_builder()

local function tab_title(tab_info)
  local title = tab_info.active_pane.title
  local extracted = title:match('"(.-)"')
  return extracted or title
end

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
  return tab_title(tab)
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  return {
    { Text = tab_title(tab) },
  }
end)

config.automatically_reload_config = true
config.default_prog = {
  "/bin/zsh",
  "-c",
  "session_name=\"wezterm-$$\"; tmux new-session -A -s \"$session_name\" \\; set-option -t \"$session_name\" destroy-unattached on",
}

config.initial_cols = 150
config.initial_rows = 50
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Mocha"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.background = {
  {
    source = {
      File = wezterm.config_dir .. "/background.jpg",
    },
    opacity = 0.9,
    hsb = {
      brightness = 0.08,
    },
  },
}

config.window_frame = {
  font = wezterm.font("Moralerspace Argon NF"),
  font_size = 15.0,
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}
config.window_background_gradient = {
  colors = { "#1e1e2e" }, -- Catppuccin mocha base color
}
config.show_new_tab_button_in_tab_bar = false
config.font = wezterm.font("Moralerspace Argon NF")
config.font_size = 18.0

config.window_background_opacity = 0.9
config.macos_window_background_blur = 30

-- https://wezterm.org/config/lua/config/skip_close_confirmation_for_processes_named.html
config.skip_close_confirmation_for_processes_named = {}

-- Claude Code specific key bindings
config.keys = {
  {
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action.SendString("\n"),
  },
}

return config
