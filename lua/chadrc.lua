-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin-latte",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },

    NvimTreeGitNew = { fg = "green" },
    NvimTreeGitDirty = { fg = "orange" },
    NvimTreeGitDeleted = { fg = "red" },
    NvimTreeGitIgnored = { fg = "grey_fg2" },
  },

  hl_add = {
    NvimTreeGitStaged = { fg = "cyan" },
    NvimTreeGitRenamed = { fg = "blue" },
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
    "texlab",
    -- Formatter
    "ruff",
    "prettierd",
    "clang-format",
    "latexindent",
    "bibtex-tidy",
    -- DAP
    "codelldb",
    "debugpy",
    "java-debug-adapter",
    "java-test",
  },
  skip = {},
}

return M
