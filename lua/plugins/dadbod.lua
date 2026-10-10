-- Filetypes handled by the SQL tooling (Dadbod + sqls).
local sql_ft = { "sql", "mysql" }

return {
  -- Dadbod: database client. Run queries straight from Neovim, e.g.
  --   :DB postgresql:///mydb          (opens an interactive console)
  --   :DB mysql://root@localhost/db select * from users
  --   :%DB sqlite:myfile.sqlite3      (run the whole buffer as a query)
  {
    "tpope/vim-dadbod",
    cmd = { "DB" },
  },

  -- Dadbod UI: browse and manage connections/databases/tables, open a query
  -- buffer and run it, all from a sidebar-like UI.
  -- NOTE: intentionally NO `vim-dadbod-completion` here. That plugin only
  -- offers text/snippet completion without schema context; we rely on
  -- `sqls` (below) as a real LSP for context-aware completion instead.
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      -- NvChad ships a Nerd Font, so use the fancy UI icons.
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- sqls.nvim: LSP client for SQL buffers (completion, execute query,
  -- explain, switch connection/database, ...).
  --
  -- The server is enabled from `lua/configs/lspconfig.lua` (see the `sqls`
  -- entry in `servers`). The plugin ships its own `lsp/sqls.lua`, which
  -- registers the `:Sqls*` commands and keymaps on attach, so no
  -- `on_attach` is needed here. We only need it loaded before the server
  -- attaches and to provide the list of connections.
  {
    "nanotee/sqls.nvim",
    ft = sql_ft,
    init = function()
      vim.lsp.config("sqls", {
        filetypes = sql_ft,
        settings = {
          sqls = {
            -- The first connection is used as the default.
            -- Replace these with your own databases.
            connections = {
              {
                driver = "mysql",
                dataSourceName = "root:root@tcp(127.0.0.1:13306)/world",
              },
              {
                driver = "postgresql",
                dataSourceName = "host=127.0.0.1 port=15432 user=postgres password=mysecretpassword1234 dbname=dvdrental sslmode=disable",
              },
            },
          },
        },
      })
    end,
  },
}
