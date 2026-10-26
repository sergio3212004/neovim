-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "ayu_dark",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },

    NvimTreeGitNew = { fg = "green" },
    NvimTreeGitDirty = { fg = "yellow" },
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
  telescope = { style = "bordered" },
  tabufline = {
    lazyload = false,
  },
  statusline = {
    enabled = true,
    theme = "minimal", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "round",
    order = nil,

    modules = {
      -- Show every LSP client attached to the current buffer instead of only
      -- the first one (NvChad's default `nvchad.stl.utils.lsp`).
      -- Same format as the default: "  LSP ~ name " when wide enough,
      -- otherwise just the " L SP " label.
      lsp = function()
        if not rawget(vim, "lsp") then
          return ""
        end

        local bufnr = require("nvchad.stl.utils").stbufnr()
        local names = {}

        for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
          names[#names + 1] = client.name
        end

        if #names == 0 then
          return ""
        end

        local icon = vim.fn.nr2char(0xf085)
        local label = (vim.o.columns > 100 and (" " .. icon .. "  LSP ~ " .. table.concat(names, ", ") .. " "))
          or (" " .. icon .. "  LSP ")

        return "%#St_Lsp#" .. label
      end,

      -- Same data source as NvChad's default `nvchad.stl.utils.git`, but the
      -- branch icon is replaced. The added/changed/removed icons are copied
      -- from that module so they look exactly as they did before.
      git = function()
        local bufnr = require("nvchad.stl.utils").stbufnr()
        local head = vim.b[bufnr].gitsigns_head

        if not head or vim.b[bufnr].gitsigns_git_status then
          return ""
        end

        local git_status = vim.b[bufnr].gitsigns_status_dict
        local branch_icon = vim.fn.nr2char(0xf113)
        local added_icon = vim.fn.nr2char(0xf055)
        local changed_icon = vim.fn.nr2char(0xf459)
        local removed_icon = vim.fn.nr2char(0xf146)

        local added = (git_status.added and git_status.added ~= 0) and (" " .. added_icon .. " " .. git_status.added)
          or ""
        local changed = (git_status.changed and git_status.changed ~= 0)
            and (" " .. changed_icon .. " " .. git_status.changed)
          or ""
        local removed = (git_status.removed and git_status.removed ~= 0)
            and (" " .. removed_icon .. " " .. git_status.removed)
          or ""
        local branch_name = branch_icon .. " " .. git_status.head

        return "%#St_gitIcons#" .. " " .. branch_name .. added .. changed .. removed
      end,
    },
  },
}

M.mason = {
  pkgs = {
    -- LSP
    "ty",
    "vtsls",
    "vue-language-server",
    "tailwindcss-language-server",
    "jdtls",
    "clangd",
    "texlab",
    "phpantom_lsp",
    "laravel_lsp",
    "sqls",
    "lemminx",
    -- Formatter
    "ruff",
    "prettierd",
    "clang-format",
    "latexindent",
    "bibtex-tidy",
    "php-cs-fixer",
    "blade-formatter",
    "sqlfluff",
    "xmlformatter",
    -- DAP
    "codelldb",
    "debugpy",
    "java-debug-adapter",
    "java-test",
  },
  skip = {},
}

return M
