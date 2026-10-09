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

  {
    "nvzone/floaterm",
    dependencies = "nvzone/volt",
    opts = {
      mappings = {
        sidebar = function(buf)
          vim.keymap.set("n", "<C-t>", "<cmd>FloatermToggle<cr>", { buffer = buf, desc = "Floaterm: toggle" })
        end,
        term = function(buf)
          vim.keymap.set({ "n", "t" }, "<C-p>", function()
            require("floaterm.api").cycle_term_bufs "prev"
          end, { buffer = buf })
          vim.keymap.set("n", "<C-t>", "<cmd>FloatermToggle<cr>", { buffer = buf, desc = "Floaterm: toggle" })
        end,
      },
    },
    cmd = "FloatermToggle",
  },
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
        "markdown_inline",
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
