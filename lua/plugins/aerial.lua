return {
  "stevearc/aerial.nvim",

  -- NvChad sets `defaults = { lazy = true }` in lua/configs/lazy.lua.
  -- That means a plugin WITHOUT an `event`/`cmd`/`ft`/`keys` trigger is
  -- never loaded, so its `config`/`opts` never run. We give aerial explicit
  -- lazy-load triggers: it loads on first command or when <leader>a is pressed.
  cmd = {
    "AerialToggle",
    "AerialOpen",
    "AerialOpenAll",
    "AerialClose",
    "AerialCloseAll",
    "AerialNext",
    "AerialPrev",
    "AerialGo",
    "AerialInfo",
    "AerialNavToggle",
    "AerialNavOpen",
    "AerialNavClose",
  },
  keys = {
    { "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Aerial: toggle outline" },
  },

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },

  opts = {
    -- set keymaps only inside the aerial window
    on_attach = function(bufnr)
      vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Aerial: previous" })
      vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Aerial: next" })
    end,
    default_direction = "float",
    placement = "edge",
  },
}
