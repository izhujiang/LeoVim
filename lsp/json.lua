return {
  filetypes = { "json", "jsonc" },
  cmd = { "vscode-json-language-server", "--stdio" },
  init_options = {
    -- use biome
    provideFormatter = false,
    provideDiagnostics = false,
  },

  settings = {
    json = {
      format = {
        enable = false,
      },
      validate = {
        enable = false,
      },
    },
  },
}