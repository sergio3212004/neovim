return {
  "Bekaboo/dropbar.nvim",

  -- NvChad sets `defaults = { lazy = true }` in lua/configs/lazy.lua, so a spec
  -- without an explicit `lazy = false` (or an event/cmd/ft/keys trigger) is
  -- NEVER loaded and its `config` never runs. That is exactly what happened:
  -- dropbar was never loaded. Its bundled plugin/dropbar.lua lazy-loads itself
  -- on a `FileType` autocmd, which is why upstream says lazy-loading is
  -- unneeded; but that only works if the plugin is loaded at startup. So we set
  -- `lazy = false` and call setup() in config, which attaches dropbar to every
  -- existing window and keeps it attached to every buffer you open.
  lazy = false,

  dependencies = {
    "nvim-tree/nvim-web-devicons",
    -- native fzf lib ("fzf_lib") used by dropbar's fuzzy find in menus
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },

  keys = {
    { "<Leader>;", function() require("dropbar.api").pick() end, desc = "Dropbar: pick symbols" },
    { "[;", function() require("dropbar.api").goto_context_start() end, desc = "Dropbar: go to start of context" },
    { "];", function() require("dropbar.api").select_next_context() end, desc = "Dropbar: select next context" },
  },

  config = function()
    -- zero-config defaults are good out of the box; tweak here if needed
    require("dropbar").setup()
  end,
}
