local wezterm = require("wezterm")
local config = wezterm.config_builder()

wezterm.on("format-window-title", function(tab)
	return "Terminal"
end)

config.automatically_reload_config = true
config.default_prog = {
	"/bin/zsh",
	"-c",
	"-l",
	"/opt/homebrew/bin/tmux",
}

config.initial_cols = 150
config.initial_rows = 50
config.window_decorations = "RESIZE"
config.color_scheme = "Tokyo Night"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.window_frame = {
	font = wezterm.font("Moralerspace Argon NF"),
	font_size = 15.0,
}
config.font = wezterm.font("Moralerspace Argon NF")
config.font_size = 18.0

config.window_background_opacity = 0.9
config.macos_window_background_blur = 30

return config
