local sql_ft = { "sql", "mysql", "plsql" }

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    vue = { "prettierd", "prettier" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    python = {
      -- To fix auto-fixable lint errors.
      "ruff_fix",
      -- To run the Ruff formatter.
      "ruff_format",
      -- To organize the imports.
      "ruff_organize_imports",
    },
    bibtex = { "bibtex-tidy" },
    tex = { "latexindent" },
    php = { "php-cs-fixer" },
    blade = { "blade-formatter" },
  },

  formatters = {
    sqlfluff = {
      args = { "format", "--dialect=ansi", "-" },
    },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

for _, ft in ipairs(sql_ft) do
  options.formatters_by_ft[ft] = options.formatters_by_ft[ft] or {}
  table.insert(options.formatters_by_ft[ft], "sqlfluff")
end

return options
