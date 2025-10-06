-- Pyright - Type Checker & language services
--    Static type checking and type analysis (disable, use ruff)
--    lsp: code completion and navigation, diagnostics
-- Focus: Type correctness, catching type-related bugs
return {
  filetypes = { "python" },
  cmd = { "pyright-langserver", "--stdio" },
  root_markers = {
    {
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      "Pipfile",
      "pyrightconfig.json",
    },
    ".git",
  },

  -- https://microsoft.github.io/pyright/#/settings
  settings = {
    pyright = {
      -- Using Ruff's features
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- aka diagnostics mode
        typeCheckingMode = "standard", -- ["off", "basic", "standard", "strict"]

        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly", -- "workspace"
        exclude = { "**/tests/**" },
        logLevel = "Warning",
      },
    },
  },

  on_attach = function(client, _bufnr)
    -- Disable capabilities (format, lint) we want ruff to handle
    client.server_capabilities.codeActionProvider = false
    client.server_capabilities.executeCommandProvider = false
  end,
  -- let ruff to handle diagnostics
  handlers = {
    -- typeCheckingMode = "off" doesn't completely disable diagnostics in Pyright.
    -- it only disables type checking diagnostics, but other diagnostics (like undefined variables, import errors, etc.) still remain active.

    -- ignore diagnostics the handler to an empty function effectively discards all diagnostics sent by the Pyright language server.
    ["textDocument/publishDiagnostics"] = function() end,
  },
}