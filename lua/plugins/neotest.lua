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
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
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

      -- Start neotest (and therefore discover tests / draw the status icons)
      -- as soon as a Java file is opened.
      local function start()
        require("neotest").starter.start()
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = start,
      })

      -- Also cover the case where the Java buffer was opened before neotest
      -- was loaded (e.g. `nvim SomeTest.java`), so FileType already fired.
      if vim.bo.filetype == "java" then
        vim.schedule(start)
      end
    end,
  },
}
