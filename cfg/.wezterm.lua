-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

config.enable_tab_bar = false
config.font = wezterm.font 'Terminess Nerd Font'
config.font_size = 12
config.cell_width = 1.01
config.line_height = 1.6
-- config.font_antialias = "None"


config.keys = {
    { key = 'LeftArrow', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
    { key = 'RightArrow', mods = 'SHIFT|CTRL', action = act.DisableDefaultAssignment },
}

config.colors = {
  -- The default text color
  foreground = 'silver',
  -- The default background color
  background = 'black',

  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = '#52ad70',
  -- Overrides the text color when the current cell is occupied by the cursor
  cursor_fg = 'black',
  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  cursor_border = '#52ad70',

  -- the foreground color of selected text
  selection_fg = 'black',
  -- the background color of selected text
  selection_bg = '#fffacd',

  -- The color of the scrollbar "thumb"; the portion that represents the current viewport
  scrollbar_thumb = '#222222',

  -- The color of the split lines between panes
  split = '#444444',

  ansi = {
    -- 0
    'black',

    -- 1
    'maroon',

    -- 2
    -- 'green',
    '00A040',

    -- 3
    -- 'olive',
    '#929240',

    -- 4
    -- 'navy',
    -- '#0000B0',
    '#0040B0',

    -- 5
    -- 'purple',
    '#770055',

    -- 6
    -- 'teal',
    '#00a0b0',

    -- 7
    -- 'silver',
    'white',
  },
  brights = {
    -- 0
    'grey',

    -- 1
    -- 'red',
    '#E02010',

    -- 2
    -- 'lime',
    -- '#A0FF40',
    '#99F030',

    -- 3
    'yellow',

    -- 4
    -- 'blue',
    "#3050FF",

    -- 5
    -- 'fuchsia',
    '#B500FF',

    -- 6
    'aqua',

    -- 7
    'white',
  },

  -- Arbitrary colors of the palette in the range from 16 to 255
  indexed = { [136] = '#af8700' },

  -- Since: 20220319-142410-0fcdea07
  -- When the IME, a dead key or a leader key are being processed and are effectively
  -- holding input pending the result of input composition, change the cursor
  -- to this color to give a visual cue about the compose state.
  compose_cursor = 'orange',

  -- Colors for copy_mode and quick_select
  -- available since: 20220807-113146-c2fee766
  -- In copy_mode, the color of the active text is:
  -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
  -- 2. selection_* otherwise
  copy_mode_active_highlight_bg = { Color = '#000000' },
  -- use `AnsiColor` to specify one of the ansi color palette values
  -- (index 0-15) using one of the names "Black", "Maroon", "Green",
  --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
  -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
  copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
  copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
  copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

  quick_select_label_bg = { Color = 'peru' },
  quick_select_label_fg = { Color = '#ffffff' },
  quick_select_match_bg = { AnsiColor = 'Navy' },
  quick_select_match_fg = { Color = '#ffffff' },

  -- input_selector_label_bg = { AnsiColor = 'Black' }, -- (*Since: Nightly Builds Only*)
  -- input_selector_label_fg = { Color = '#ffffff' }, -- (*Since: Nightly Builds Only*)

  -- launcher_label_bg = { AnsiColor = 'Black' }, -- (*Since: Nightly Builds Only*)
  -- launcher_label_fg = { Color = '#ffffff' }, -- (*Since: Nightly Builds Only*)
}
return config
