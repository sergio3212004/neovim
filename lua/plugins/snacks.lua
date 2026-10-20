-- snacks.nvim picker: replaces vim.ui.select with a fuzzy-filter popup.
-- This fixes Mason's language filter (<C-f>) which otherwise gets trapped
-- inside noice.nvim's non-interactive "confirm" popup.
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    picker = {
      -- Replace the native vim.ui.select with a Snacks fuzzy picker.
      -- Every plugin that calls vim.ui.select (Mason, LSP code-actions, etc.)
      -- will now open a filterable popup instead of a numbered list.
      ui_select = true,

      sources = {
        select = {
          -- Use the "select" layout preset which is a compact dropdown.
          -- Other options: "telescope", "ivy", "dropdown", "cursor"
          layout = { preset = "select" },
        },
      },
    },
    image = {},
    scrol = {},
  },
}
