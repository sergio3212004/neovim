return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap, dapui = require "dap", require "dapui"

      dapui.setup()

      -- neotest's DAP strategy registers its listeners under a "neotest_*" id
      -- (see neotest/client/strategies/dap/init.lua). For those runs we keep
      -- dap-ui open after the session ends so the test output stays visible.
      local function is_neotest_session()
        for id in pairs(dap.listeners.after.event_exited or {}) do
          if type(id) == "string" and id:match "^neotest_" then
            return true
          end
        end
        return false
      end

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        if not is_neotest_session() then
          dapui.close()
        end
      end
      dap.listeners.before.event_exited.dapui_config = function()
        if not is_neotest_session() then
          dapui.close()
        end
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require "configs.dapconfig"
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    ft = "python",
    config = function()
      local mason_path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(mason_path)
    end,
  },
}
