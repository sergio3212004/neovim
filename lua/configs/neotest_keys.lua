-- Shared <leader>t* keymaps for neotest.
--
-- The Java and Python test workflows should feel identical, but they are wired
-- up from two different places:
--   * Java   -> registered from the jdtls LSP attach (lua/plugins/jdtls.lua)
--   * Python -> registered from the neotest FileType autocmd (lua/plugins/neotest.lua)
-- Keeping the mapping list here stops the two from drifting apart.
local M = {}

--- Register the neotest keymaps buffer-locally.
---@param bufnr integer? Buffer to map in (defaults to the current buffer).
function M.set(bufnr)
  bufnr = bufnr or 0

  local nt = require "neotest"

  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("<leader>tn", nt.run.run, "Run Nearest")
  map("<leader>tf", function()
    nt.run.run(vim.fn.expand "%")
  end, "Run File")
  map("<leader>ta", function()
    nt.run.run(vim.loop.cwd())
  end, "Run All")
  -- Run under nvim-dap; dap-ui displays the output. lua/plugins/dap.lua keeps
  -- the UI open after a neotest session ends so the results stay visible.
  map("<leader>td", function()
    nt.run.run { strategy = "dap" }
  end, "Debug Nearest")
  map("<leader>ts", nt.summary.toggle, "Summary")
  map("<leader>to", function()
    nt.output.open { enter = true }
  end, "Output")
  map("<leader>tO", nt.output_panel.toggle, "Output Panel")
  map("<leader>tw", nt.watch.toggle, "Watch")
  -- `stop` lives on the run consumer, not on the top-level neotest module.
  map("<leader>tS", nt.run.stop, "Stop")

  -- Label the <leader>t prefix in which-key. Mappings show up on their own via
  -- their `desc`; only the group name needs declaring.
  local ok, wk = pcall(require, "which-key")
  if ok then
    wk.add {
      {
        mode = "n",
        buffer = bufnr,
        { "<leader>t", group = "test" },
      },
    }
  end
end

return M
