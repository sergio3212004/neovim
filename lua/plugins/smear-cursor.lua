-- Animated "smear" cursor, inspired by Neovide's cursor animation.
-- https://github.com/sphamba/smear-cursor.nvim
return {
  "sphamba/smear-cursor.nvim",

  -- configs/lazy.lua sets `defaults = { lazy = true }`, and this plugin has no
  -- cmd/event/keys of its own, so without this it would never be loaded.
  lazy = false,

  opts = {
    -- Animate when switching windows/buffers and when moving across lines.
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,

    -- Animate the thin bar cursor in insert mode as well.
    smear_insert_mode = true,

    -- Keep the smear aligned with the buffer while scrolling.
    scroll_buffer_space = true,

    -- Only enable this if your font ships legacy computing / block symbols
    -- (e.g. Cascadia Code). Otherwise the smear renders with blocky cells.
    legacy_computing_symbols_support = false,

    -- The smear color defaults to the `Cursor` highlight (ayu_dark: #C9C7BE).
    -- Uncomment and set this if your terminal overrides the cursor color.
    -- cursor_color = "#c9c7be",

    -- Optional tuning: uncomment for a snappier cursor (defaults in comments).
    -- stiffness = 0.8,                      -- 0.6
    -- trailing_stiffness = 0.6,             -- 0.45
    -- stiffness_insert_mode = 0.7,          -- 0.5
    -- trailing_stiffness_insert_mode = 0.7, -- 0.5
    -- damping = 0.95,                       -- 0.85
    -- damping_insert_mode = 0.95,           -- 0.9
    -- time_interval = 7,                    -- 17 (ms per frame, lower = smoother but heavier)
  },
}
