local wezterm = require 'wezterm'

local config = {
	colors = {
		cursor_bg = "white",
		cursor_border = "white",
	},

	font_size = 12.5,
	font = wezterm.font ('Google Sans Code', { weight = 'DemiBold' }),

	-- color_scheme = 'Belge (terminal.sexy)',

	enable_tab_bar = false,
	window_padding = { left = 0, right = 0,	top = 0, bottom = 0, },
	window_background_opacity = 0.899,

	cursor_thickness = "1px",
	audible_bell = "Disabled",
}

return config
