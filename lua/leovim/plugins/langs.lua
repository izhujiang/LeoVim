return {
  -- Clangd's off-spec features for neovim's LSP client
  "p00f/clangd_extensions.nvim",
  enabled = false,
  ft = { "c", "cpp" },
  opts = {
    extensions = {
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
      },
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