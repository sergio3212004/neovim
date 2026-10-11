require("nvchad.configs.lspconfig").defaults()

local servers =
  { "html", "cssls", "ty", "vtsls", "vue_ls", "clangd", "texlab", "phpantom_lsp", "laravel_lsp", "sqls", "tailwindcss" }

-- `vue_ls` works in "hybrid mode": it delegates all TypeScript handling to
-- `vtsls`, which needs the `@vue/typescript-plugin` to understand `.vue` files.
-- Path to the plugin bundled with the Vue language server installed by Mason.
local vue_language_server_path = vim.fn.stdpath "data"
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}

vim.lsp.config("vtsls", {
  -- `vue` must be added on top of the default JS/TS filetypes so `vtsls`
  -- attaches to `.vue` buffers and `vue_ls` can find it.
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = { vue_plugin },
      },
    },
  },
})

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
