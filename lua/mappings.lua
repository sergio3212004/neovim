require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map({ "n", "t", "v", "i" }, "<C-t>", "<cmd> FloatermToggle <cr>")

-- VimTeX mappings (<localleader>l prefix)
-- Compilation
map("n", "<localleader>ll", "<plug>(vimtex-compile)", { desc = "VimTeX: Compile" })
map("n", "<localleader>lL", "<plug>(vimtex-compile-selected)", { desc = "VimTeX: Compile selected" })
map("n", "<localleader>lS", "<plug>(vimtex-compile-ss)", { desc = "VimTeX: Compile single shot" })
map("n", "<localleader>lk", "<plug>(vimtex-stop)", { desc = "VimTeX: Stop compilation" })
map("n", "<localleader>lK", "<plug>(vimtex-stop-all)", { desc = "VimTeX: Stop all compilations" })
map("n", "<localleader>lo", "<plug>(vimtex-compile-output)", { desc = "VimTeX: Show compile output" })

-- View & Search
map("n", "<localleader>lv", "<plug>(vimtex-view)", { desc = "VimTeX: View PDF" })
map("n", "<localleader>lr", "<plug>(vimtex-reverse-search)", { desc = "VimTeX: Reverse search" })

-- Info & Status
map("n", "<localleader>li", "<plug>(vimtex-info)", { desc = "VimTeX: Info" })
map("n", "<localleader>lI", "<plug>(vimtex-info-full)", { desc = "VimTeX: Full info" })
map("n", "<localleader>lg", "<plug>(vimtex-status)", { desc = "VimTeX: Status" })
map("n", "<localleader>lG", "<plug>(vimtex-status-all)", { desc = "VimTeX: Status all" })

-- Table of Contents
map("n", "<localleader>lt", "<plug>(vimtex-toc-open)", { desc = "VimTeX: Open TOC" })
map("n", "<localleader>lT", "<plug>(vimtex-toc-toggle)", { desc = "VimTeX: Toggle TOC" })

-- Errors & Log
map("n", "<localleader>le", "<plug>(vimtex-errors)", { desc = "VimTeX: Show errors" })
map("n", "<localleader>lq", "<plug>(vimtex-log)", { desc = "VimTeX: Show log" })

-- Clean
map("n", "<localleader>lc", "<plug>(vimtex-clean)", { desc = "VimTeX: Clean" })
map("n", "<localleader>lC", "<plug>(vimtex-clean-full)", { desc = "VimTeX: Clean full" })

-- Reload & Toggle
map("n", "<localleader>lx", "<plug>(vimtex-reload)", { desc = "VimTeX: Reload" })
map("n", "<localleader>lX", "<plug>(vimtex-reload-state)", { desc = "VimTeX: Reload state" })
map("n", "<localleader>ls", "<plug>(vimtex-toggle-main)", { desc = "VimTeX: Toggle main file" })

-- Context menu
map("n", "<localleader>la", "<plug>(vimtex-context-menu)", { desc = "VimTeX: Context menu" })

-- IMaps list
map("n", "<localleader>lm", "<plug>(vimtex-imaps-list)", { desc = "VimTeX: List imaps" })

-- ── DAP: primary actions (<F...> keys, IDE-style) ────────────────────────────
-- Follows the VS Code / Visual Studio convention so the muscle memory carries over.
--   F5     start / continue          F9     toggle breakpoint
--   S-F5   terminate / stop          S-F9   conditional breakpoint
--   C-F5   restart                   F10    step over
--   F6     pause                     F11    step into
--                                    S-F11  step out
map("n", "<F5>", "<cmd>lua require('dap').continue()<CR>", { desc = "DAP: Start / Continue" })
map("n", "<S-F5>", "<cmd>lua require('dap').terminate()<CR>", { desc = "DAP: Terminate" })
map("n", "<C-F5>", "<cmd>lua require('dap').restart()<CR>", { desc = "DAP: Restart" })
map("n", "<F6>", "<cmd>lua require('dap').pause()<CR>", { desc = "DAP: Pause" })
map("n", "<F9>", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "DAP: Toggle breakpoint" })
map(
  "n",
  "<S-F9>",
  "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { desc = "DAP: Conditional breakpoint" }
)
map("n", "<F10>", "<cmd>lua require('dap').step_over()<CR>", { desc = "DAP: Step over" })
map("n", "<F11>", "<cmd>lua require('dap').step_into()<CR>", { desc = "DAP: Step into" })
map("n", "<S-F11>", "<cmd>lua require('dap').step_out()<CR>", { desc = "DAP: Step out" })

-- ── DAP: secondary options (<localleader>d prefix) ───────────────────────────
-- Session
map("n", "<localleader>dr", "<cmd>lua require('dap').repl.open()<CR>", { desc = "DAP: Open REPL" })
map("n", "<localleader>dl", "<cmd>lua require('dap').run_last()<CR>", { desc = "DAP: Run last" })

-- Breakpoints
map("n", "<localleader>dbl", "<cmd>lua require('dap').list_breakpoints()<CR>", { desc = "DAP: List breakpoints" })
map("n", "<localleader>dbc", "<cmd>lua require('dap').clear_breakpoints()<CR>", { desc = "DAP: Clear all breakpoints" })
map(
  "n",
  "<localleader>dbh",
  "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
  { desc = "DAP: Log point" }
)

-- UI & Inspection
map("n", "<localleader>dh", "<cmd>lua require('dap.ui.widgets').hover()<CR>", { desc = "DAP: Hover" })
map("n", "<localleader>dp", "<cmd>lua require('dap.ui.widgets').preview()<CR>", { desc = "DAP: Preview" })
map(
  "n",
  "<localleader>df",
  "<cmd>lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').frames)<CR>",
  { desc = "DAP: Frames" }
)
map(
  "n",
  "<localleader>ds",
  "<cmd>lua require('dap.ui.widgets').centered_float(require('dap.ui.widgets').scopes)<CR>",
  { desc = "DAP: Scopes" }
)
map("n", "<localleader>dt", "<cmd>lua require('dapui').toggle()<CR>", { desc = "DAP: Toggle UI" })

-- Python testing (dap-python)
map("n", "<localleader>dnm", "<cmd>lua require('dap-python').test_method()<CR>", { desc = "DAP: Debug test method" })
map("n", "<localleader>dnf", "<cmd>lua require('dap-python').test_class()<CR>", { desc = "DAP: Debug test class" })
map(
  "v",
  "<localleader>dns",
  "<ESC><cmd>lua require('dap-python').debug_selection()<CR>",
  { desc = "DAP: Debug selection" }
)

-- Toggle the smear cursor animation on/off
map("n", "<leader>uS", function()
  require("smear_cursor").toggle()
end, { desc = "toggle smear cursor" })
