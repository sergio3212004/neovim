-- this line for types, by hovering and autocompletion (lsp required)
-- will help you understanding properties, fields, and what highlightings the color used for
---@type Base46Table
local M = {}

-- UI
M.base_30 = {
  white = "#73f990", -- brightest fg (cursor color, doubles as "white")
  black = "#0f160f", -- theme bg
  darker_black = "#0a0f0a", -- 6% darker than black
  black2 = "#141d14", -- 6% lighter than black
  one_bg = "#1a241a", -- 10% lighter than black
  one_bg2 = "#202d20", -- 6% lighter than one_bg
  one_bg3 = "#26342a", -- 6% lighter than one_bg2
  grey = "#3c4711", -- color8
  grey_fg = "#4a5714", -- 10% lighter than grey
  grey_fg2 = "#57641c", -- 5% lighter than grey_fg
  light_grey = "#637d75", -- foreground
  red = "#7f2b26", -- color1
  baby_pink = "#a8483f", -- lightened red
  pink = "#c97a72", -- further lightened red/pink
  line = "#16211a", -- 15% lighter than black
  green = "#2f7e25", -- color2
  vibrant_green = "#18e000", -- color10
  nord_blue = "#2f697f", -- color4
  blue = "#00a9df", -- color12
  seablue = "#2f697f", -- color4
  yellow = "#707f23", -- color3
  sun = "#bde000", -- color11
  purple = "#47577e", -- color5
  dark_purple = "#0058df", -- color13
  teal = "#317f76", -- color6
  orange = "#df8008", -- color9
  cyan = "#00dfc3", -- color14
  statusline_bg = "#141d14", -- black2
  lightbg = "#202d20", -- one_bg2
  pmenu_bg = "#18e000", -- vibrant_green
  folder_bg = "#00a9df", -- blue
}

-- check https://github.com/chriskempson/base16/blob/master/styling.md for more info
M.base_16 = {
  base00 = "#0f160f", -- background
  base01 = "#141d14", -- black2
  base02 = "#1a241a", -- one_bg / selection_bg-ish
  base03 = "#3c4711", -- grey (color8)
  base04 = "#57641c", -- grey_fg2
  base05 = "#637d75", -- foreground
  base06 = "#647d75", -- color7 (light_grey variant)
  base07 = "#73f990", -- brightest (cursor/color15)
  base08 = "#7f2b26", -- red (color1)
  base09 = "#df8008", -- orange (color9)
  base0A = "#707f23", -- yellow (color3)
  base0B = "#2f7e25", -- green (color2)
  base0C = "#00dfc3", -- cyan (color14)
  base0D = "#00a9df", -- blue (color12)
  base0E = "#47577e", -- purple (color5)
  base0F = "#a8483f", -- pink/baby_pink
}

-- OPTIONAL
-- overriding or adding highlights for this specific theme only
-- defaults/treesitter is the filename i.e integration there,

M.polish_hl = {
  defaults = {
    Comment = {
      fg = "#3c4711", -- grey, dim comments
      italic = true,
    },
  },

  treesitter = {
    ["@variable"] = { fg = "#637d75" },
  },
}

-- set the theme type whether is dark or light
M.type = "dark"

-- this will be later used for users to override your theme table from chadrc
M = require("base46").override_theme(M, "alien_blood")

return M
