local mappings = {
  {
    "<localleader>l",
    group = "VimTeX",
    icon = "",
    mode = { "n" },
    buffer = nil,
    desc = "VimTeX: LaTeX plugin",
    expr = false,
    remap = false,
  },
  {
    "<localleader>d",
    group = "DAP",
    icon = "",
    mode = { "n" },
    buffer = nil,
    desc = "DAP: Debug options (primary on <F5>-<F11>)",
    expr = false,
    remap = false,
  },
}

return mappings
