return {
  filetypes = { "html" },
  cmd = { "vscode-html-language-server", "--stdio" },
  root_markers = {
    "package.json",
    ".git",
  },
  init_options = {
    provideFormatter = true,
    embeddedLanguages = {
      css = true,
      javascript = true,
    },
    configurationSection = { "html", "css", "javascript" },
  },
  settings = {
    html = {
      format = {
        enable = true,
      },
      completion = {
        attributeDefaultValue = "doublequotes",
      },
    },
  },
  -- TODO: guess blink.cmp have fixed it.
  -- Neovim does not currently include built-in snippets. vscode-html-language-server only provides completions when snippet support is enabled.
  -- capabilities = vim.tbl_deep_extend(
  --   "force",
  --   vim.lsp.protocol.make_client_capabilities(),
  --   { textDocument = { completion = { completionItem = { snippetSupport = true } } } }
  -- ),
  --
  -- on_attach = function(client, _bufnr)
  -- Disable capabilities we want Pyright to handle
  -- client.server_capabilities.definitionProvider = false
  -- client.server_capabilities.documentFormattingProvider = false
  -- client.server_capabilities.documentRangeFormattingProvider = false
  -- end,
}