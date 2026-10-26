-- Highlight groups for the custom statusline theme (lua/nvchad/stl/custom.lua).
--
-- Base46 looks for `base46.integrations.statusline.<theme>` when it compiles the
-- statusline highlights. Reusing the default integration keeps this theme in
-- sync with NvChad's built-in statusline colors (and with any hl_override /
-- hl_add entries in chadrc.lua).

return require "base46.integrations.statusline.default"
