return {
  "rcarriga/nvim-notify",
  lazy = false,
  opts = function()
    return require "configs.notify"
  end,
  config = function(_, opts)
    local notify = require "notify"
    notify.setup(opts)
    vim.notify = notify
  end,
}
