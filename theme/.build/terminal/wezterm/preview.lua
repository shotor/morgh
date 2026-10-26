local wezterm = require 'wezterm'

wezterm.on('toggle-shotormorgh', function(window)
  local overrides = window:get_config_overrides() or {}
  overrides.color_scheme = window:effective_config().color_scheme == 'shotormorgh-dark'
    and 'shotormorgh-light' or 'shotormorgh-dark'
  window:set_config_overrides(overrides)
end)

return {
  color_scheme_dirs = { wezterm.config_dir },
  color_scheme = 'shotormorgh-dark',
  font = wezterm.font 'DejaVu Sans Mono',
  font_size = 12,
  front_end = 'Software',
  enable_wayland = false,
  enable_tab_bar = false,
  term = 'xterm-256color',
  window_padding = { left = 16, right = 16, top = 16, bottom = 16 },
  keys = {
    { key = 'L', mods = 'CTRL|SHIFT', action = wezterm.action.EmitEvent 'toggle-shotormorgh' },
  },
}
