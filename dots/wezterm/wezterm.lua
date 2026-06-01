local wezterm = require("wezterm")

local config = {
	colors = {
		cursor_bg = "white",
		background = "black",
		cursor_border = "white",
	},

	font_size = 14,
	font = wezterm.font("Iosevka", { weight = "DemiBold" }),

	-- color_scheme = "Ayu Dark (Gogh)",

	enable_tab_bar = false,
	window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
	window_background_opacity = 0.85,
	kde_window_background_blur = true,
	text_background_opacity = 1,

	cursor_thickness = "1px",
	audible_bell = "Disabled",

	warn_about_missing_glyphs = false,
}

return config
