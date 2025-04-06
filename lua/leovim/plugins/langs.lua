return {
  -- Clangd's off-spec features for neovim's LSP client
  -- usage:
  -- -- :ClangdSwitchSourceHeader
  -- -- :ClangdAST
  -- -- :ClangdSymbolInfo
  -- -- :ClangdTypeHierarchy
  -- -- :ClangdMemoryUsage
  "p00f/clangd_extensions.nvim",
  ft = { "c", "cpp" },
  cmd = {
    "ClangdSwitchSource",
    "ClangdAST",
    "ClangdSymbolInfo",
    "ClangdTypeHierarch",
    "ClangdMemoryUsage",
  },
  opts = {
    inlay_hints = {
      inline = false,
    },
    ast = {
      --These require codicons (https://github.com/microsoft/vscode-codicons)
      role_icons = {
        type = "",
        declaration = "",
        expression = "",
        specifier = "",
        statement = "",
        ["template argument"] = "",
      },
      kind_icons = {
        Compound = "",
        Recovery = "",
        TranslationUnit = "",
        PackExpansion = "",
        TemplateTypeParm = "",
        TemplateTemplateParm = "",
        TemplateParamObject = "",
      },
      highlights = {
        detail = "Comment",
      },
    },
    memory_usage = {
      border = "rounded",
    },
    symbol_info = {
      border = "rounded",
    },
  },
  -- TODO: setup nvim-cmp for clangd_extensions
  -- config = function(_, opts)
  --   require("clangd_extensions").setup(opts)
  --   local cmp = require("cmp")
  --   cmp.setup({
  --     -- ... rest of your cmp setup ...
  --     sorting = {
  --       comparators = {
  --         cmp.config.compare.offset,
  --         cmp.config.compare.exact,
  --         cmp.config.compare.recently_used,
  --         require("clangd_extensions.cmp_scores"),
  --         cmp.config.compare.kind,
  --         cmp.config.compare.sort_text,
  --         cmp.config.compare.length,
  --         cmp.config.compare.order,
  --       },
  --     },
  --   })
  -- end,
}