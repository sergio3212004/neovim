-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "alien_blood",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },

    -- ??  Untracked          -> verde
    NvimTreeGitNew = { fg = "green" },
    -- " M" Modified/unstaged -> naranja
    NvimTreeGitDirty = { fg = "orange" },
    -- " D" Deleted           -> rojo
    NvimTreeGitDeleted = { fg = "red" },
    -- !!  Ignored           -> atenuado a proposito
    NvimTreeGitIgnored = { fg = "grey_fg2" },
  },

  hl_add = {
    -- "A " Staged  -> cian (alternativa de la guia)
    NvimTreeGitStaged = { fg = "cyan" },
    -- "R " Renamed -> azul
    NvimTreeGitRenamed = { fg = "blue" },
    -- UU  Merge    -> la guia no lo cubre; morado para no chocar
    NvimTreeGitMerge = { fg = "purple" },
  },
}

M.nvdash = { load_on_startup = true }
M.ui = {
  cmp = {
    icons_left = false, -- only for non-atom styles!
    style = "atom", -- default/flat_light/flat_dark/atom/atom_colored
    abbr_maxwidth = 60,
    -- for tailwind, css lsp etc
    format_colors = { lsp = true, icon = "󱓻" },
  },
  tabufline = {
    lazyload = false,
  },
  statusline = {
    enabled = true,
    theme = "default", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "round",
    order = nil,
    modules = nil,
  },
}

M.mason = {
  pkgs = {
    -- LSP
    "ty",
    "vtsls",
    "vue-language-server",
    "jdtls",
    "clangd",
    -- Formatter
    "ruff",
    "prettierd",
    "clang-format",
    -- DAP
  },
  skip = {},
}

return M
