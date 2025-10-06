return {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  cmd = { "typescript-language-server", "--stdio" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },

  -- capabilities = require("blink.cmp").get_lsp_capabilities(),
  on_attach = function(client, _bufnr)
    -- Disable capabilities: formatting
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,

  handlers = {
    -- ignore diagnostic messages, use biome
    ["textDocument/publishDiagnostics"] = function() end,
  },
}

