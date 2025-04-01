return {
  -- Clangd's off-spec features for neovim's LSP client
  "p00f/clangd_extensions.nvim",
  enabled = false, -- don't forget to uncomment "hrsh7th/nvim-cmp" in clangd when enabled = true.
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
}