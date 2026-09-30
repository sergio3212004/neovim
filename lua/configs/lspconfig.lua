require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "ty", "vtsls", "vue_ls", "clangd", "texlab" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
