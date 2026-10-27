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
      -- Condition to attach to buffers (overrides filetypes and ignore_buftypes)
      condition = function(buffer)
        local ft = vim.bo[buffer].filetype
        local bufname = vim.api.nvim_buf_get_name(buffer)
        local buftype = vim.bo[buffer].buftype

        -- Kulala response buffer (named "kulala://ui")
        if bufname == "kulala://ui" then
          return true
        end

        -- Only real markdown file buffers. Without this, markview also attaches
        -- to LSP hover windows and other markdown scratch/float buffers
        -- (buftype "nofile", empty name). It then renders their text with its
        -- Comment-based palette, making the docs unreadable on dark themes.
        -- NOTE: markview changes a real buffer's buftype to "markview" after
        -- attaching, so that value must still be accepted here.
        local scratch = buftype == "nofile" or buftype == "prompt" or buftype == "quickfix" or buftype == "terminal"
        if not scratch and bufname ~= "" and (ft == "markdown" or ft == "markdown.mdx") then
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
