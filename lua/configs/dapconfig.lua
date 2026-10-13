local dap = require "dap"

-- ── Signs ──────────────────────────────────────────────────────────────────
local signs = {
  DapBreakpoint = { text = "", texthl = "", linehl = "", numhl = "" },
  DapBreakpointCondition = { text = "", texthl = "", linehl = "", numhl = "" },
  DapLogPoint = { text = "", texthl = "", linehl = "", numhl = "" },
  DapStopped = { text = "", texthl = "", linehl = "", numhl = "" },
  DapBreakpointRejected = { text = "", texthl = "", linehl = "", numhl = "" },
}

for name, sign in pairs(signs) do
  vim.fn.sign_define(name, sign)
end

-- ── Helpers ─────────────────────────────────────────────────────────────────
local function find_python()
  local cwd = vim.fn.getcwd()
  for _, pattern in ipairs { "/venv/bin/python", "/.venv/bin/python" } do
    if vim.fn.executable(cwd .. pattern) == 1 then
      return cwd .. pattern
    end
  end
  return vim.fn.exepath "python3" or vim.fn.exepath "python" or "/usr/bin/python3"
end

-- ── C/C++/Rust (codelldb via Mason) ─────────────────────────────────────────
local codelldb_path = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/adapter/codelldb"

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = codelldb_path,
    args = { "--port", "${port}" },
  },
}

local codelldb_config = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
  {
    name = "Attach to process",
    type = "codelldb",
    request = "attach",
    pid = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
}

dap.configurations.cpp = codelldb_config
dap.configurations.c = codelldb_config
dap.configurations.rust = codelldb_config

-- ── Python (debugpy via Mason) ──────────────────────────────────────────────
dap.adapters.python = {
  type = "executable",
  command = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python",
  args = { "-m", "debugpy.adapter" },
  options = { source_filetype = "python" },
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = find_python,
    console = "integratedTerminal",
  },
  {
    type = "python",
    request = "launch",
    name = "Launch file (external terminal)",
    program = "${file}",
    pythonPath = find_python,
    console = "externalTerminal",
  },
  {
    type = "python",
    request = "launch",
    name = "Launch module",
    module = "",
    pythonPath = find_python,
    console = "integratedTerminal",
  },
  {
    type = "python",
    request = "attach",
    name = "Attach to process",
    connect = { host = "127.0.0.1", port = 5678 },
    pythonPath = find_python,
  },
}

-- ── Java (java-debug-adapter via jdtls) ──────────────────────────────────────
-- IMPORTANT: do NOT define `dap.adapters.java` here.
-- The correct adapter is registered by `require("jdtls").setup_dap()` in
-- lua/plugins/jdtls.lua. nvim-jdtls bails out if a java adapter already exists
-- (jdtls/dap.lua: `if dap.adapters.java then return end`), so defining it here
-- prevents the good one from being registered.
-- Also, `com.microsoft.java.debug.plugin-*.jar` is an OSGi bundle, not an
-- executable jar: `java -jar` fails with "no main manifest attribute" (exit 1).
dap.configurations.java = {
  {
    type = "java",
    request = "attach",
    name = "Debug (Attach) - Remote",
    hostName = "127.0.0.1",
    port = 5005,
  },
  {
    type = "java",
    request = "attach",
    name = "Debug (Attach) - Remote (Custom Port)",
    hostName = "127.0.0.1",
    port = function()
      return tonumber(vim.fn.input("Port [5005]: ")) or 5005
    end,
  },
}

-- The "launch" configurations (Debug - Current File / main classes) are added
-- automatically by nvim-jdtls via `setup_dap_main_class_configs`, which is
-- already called from lua/plugins/jdtls.lua.
