local wezterm = require 'wezterm'
local act = wezterm.action

return {
  font = wezterm.font_with_fallback {
    'DejaVu Sans Mono', 'FontAwesome', 'PowerlineSymbols', 'Symbola',
  },
  font_size = 12.0,
  colors = { background = '#181818', foreground = '#dddddd' },
  scrollback_lines = 10000,
  enable_scroll_bar = false,
  enable_tab_bar = false,
  -- Qubes guests generally have no accelerated GPU.
  front_end = 'Software',
  enable_wayland = false,
  term = 'xterm-256color',
  keys = {
    { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
    { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    { key = '0', mods = 'CTRL', action = act.ResetFontSize },
    { key = 'Insert', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'Clipboard' },
  },
  mouse_bindings = {
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.CompleteSelection 'ClipboardAndPrimarySelection',
    },
  },
}
