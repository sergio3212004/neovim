return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  { import = "plugins.floaterm" },
  -- test new blink
  { import = "nvchad.blink.lazyspec" },

  { import = "plugins.noice" },
  { import = "plugins.snacks" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "python",
        "sql",
        "vue",
        "c",
        "cpp",
        "java",
        "latex",
        "bibtex",
        "latex",
        "php",
        "phpdoc",
        "blade",
        -- required for noice.nvim (cmdline highlighting + lsp hover docs)
        "regex",
        "bash",
        "markdown",
        "comment",
        "yaml",
        "typst",
        "markdown_inline",
        "xml",
        -- config / data formats
        "json",
        "yaml",
        "toml",
        "gitignore",
        "dockerfile",
        "diff",
        "query",
      },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "configs.nvimtree"
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = require "configs.whichkey",
    },
  },
}
