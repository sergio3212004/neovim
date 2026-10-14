-- Attach markview to kulala response buffer when it opens
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
  pattern = "kulala://ui",
  callback = function(args)
    local ok, markview = pcall(require, "markview")
    if ok then
      vim.bo[args.buf].filetype = "markdown"
      pcall(markview.actions.toggle, args.buf)
    end
  end,
  group = vim.api.nvim_create_augroup("kulala_markview_attach", { clear = true }),
})

return {
  "OXY2DEV/markview.nvim",
  lazy = false,

  dependencies = { "saghen/blink.cmp" },

  opts = {
    preview = {
      -- Filetypes where markview should attach
      filetypes = { "markdown", "markdown.mdx", "Avante", "codecompanion" },
      -- Condition to attach to buffers (overrides filetypes)
      condition = function(buffer)
        local ft = vim.bo[buffer].filetype
        local bufname = vim.api.nvim_buf_get_name(buffer)

        -- Standard markdown files
        if ft == "markdown" or ft == "markdown.mdx" then
          return true
        end

        -- Kulala response buffer (named "kulala://ui")
        if bufname == "kulala://ui" then
          return true
        end

        return false
      end,
      -- Enable preview when attaching
      enable = true,
      -- Hybrid mode for editing
      enable_hybrid_mode = true,
    },
  },
}
