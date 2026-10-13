return {
  {
    "rcasia/neotest-java",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
  },
  {
    "nvim-neotest/neotest",
    -- neotest powers both the Java and the Python workflows, so load it (and
    -- therefore its adapters and the buffer status icons) as soon as a file of
    -- either type is opened.
    ft = { "java", "python" },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      -- Python adapter (pytest / unittest). It runs the tests through debugpy,
      -- which is what makes the `strategy = "dap"` below work with dap-ui,
      -- exactly like neotest-java does.
      "nvim-neotest/neotest-python",
    },
    config = function()
      local root_finder = require "neotest-java.core.root_finder"

      -- neotest-java decides whether a file is a test by resolving the project
      -- root from the cwd captured at startup. Here the Maven module lives at
      -- apps/api, under a parent folder with no build file, so launching nvim
      -- from that parent makes every file look like a non-test file. When the
      -- requested dir has no build file, fall back to the focused buffer's dir.
      local function find_root(dir, matcher)
        local root = root_finder.find_root(dir, matcher)
        if root then
          return root
        end
        local buf = vim.api.nvim_buf_get_name(0)
        if buf ~= "" then
          return root_finder.find_root(vim.fs.dirname(buf), matcher)
        end
      end

      require("neotest").setup {
        adapters = {
          require "neotest-java"({
            test_classname_patterns = {
              "^.*Tests?$",
              "^.*Test$",
              "^.*IT$",
              "^.*Spec$",
            },
          }, {
            root_finder = { find_root = find_root },
          }),
          -- Python. The interpreter, runner and args are all inferred
          -- (activated venv, .venv, Pipenv, Poetry, uv, ...). Add overrides
          -- here only when a project needs them, e.g.:
          --   python = ".venv/bin/python", runner = "pytest",
          --   args = { "--log-level", "DEBUG" },
          require "neotest-python" {
            -- Keep stepping into application code while debugging tests instead
            -- of stopping at the first frame inside the test runner.
            dap = { justMyCode = false },
          },
        },
        consumers = {
          -- neotest starts lazily, so its status icons are not drawn until the
          -- client has been initialised. Expose a tiny helper to start it.
          starter = function(client)
            return {
              start = function()
                require("nio").run(function()
                  client:get_adapters()
                end)
              end,
            }
          end,
        },
      }

      -- Start neotest (and therefore discover tests / draw the status icons) as
      -- soon as a Java or Python file is opened.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "java", "python" },
        callback = function()
          require("neotest").starter.start()
        end,
      })

      -- Python buffers have no jdtls-style attach hook to hang the test keymaps
      -- off, so register them for every Python buffer here. Java gets the same
      -- set from lua/plugins/jdtls.lua, both through configs.neotest_keys.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function(args)
          require("configs.neotest_keys").set(args.buf)
        end,
      })

      -- Also cover the case where the buffer was opened before neotest was
      -- loaded (e.g. `nvim test_foo.py`), so FileType already fired.
      if vim.tbl_contains({ "java", "python" }, vim.bo.filetype) then
        vim.schedule(function()
          require("neotest").starter.start()
          if vim.bo.filetype == "python" then
            require("configs.neotest_keys").set(0)
          end
        end)
      end
    end,
  },
}
