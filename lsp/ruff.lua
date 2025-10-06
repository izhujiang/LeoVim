-- Ruff - Linter & Formatter
-- Combines linting (error detection) and code formatting
-- Focus: Style enforcement, common errors, import sorting, code modernization and codeAction
return {
  filetypes = { "python" },
  cmd = { "ruff", "server" },
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
  -- Ruff's way (correct), Ruff LSP server has a quirk:
  -- it expects its configuration in the settings field within init_options, not as a top-level settings parameter.
  -- Ruff (and some other newer LSP servers) choose:
  -- to receive their configuration during the initialize phase rather than via workspace/didChangeConfiguration.

  -- init_options is sent to the LSP server during the initialize request as part of the LSP protocol.
  -- It contains server-specific configuration settings that the server uses to configure its own behavior.
  -- For Ruff, this includes things like:
  --  . lint.enable
  --  . format.enable
  --  . lineLength
  --  . codeAction.*
  init_options = {
    settings = {
      -- Ruff language server settings go here
      logLevel = "debug",
      -- logFile = "~/path/to/ruff.log",
      exclude = { "**/tests/**" },

      -- enable lint, format, code action by default
      lineLength = 88,
      fixAll = true,
      organizeImports = true,
      showSyntaxErrors = true,
      codeAction = {
        disableRuleComment = {
          enable = false,
        },
        fixViolation = {
          enable = true,
        },
      },
      lint = {
        enable = true,
        preview = true,
        -- select = {"E", "F"}
        -- extendSelect = {"W"}
        -- ignore = { "E4", "E7" },
      },
      format = {
        enable = true,
        preview = true,
        -- backend = "uv",
      },
    },
  },
  --  The capabilities table in LSP config is meant to communicate client capabilities to the server (what the client supports)
  --  Map overriding the default capabilities defined by |vim.lsp.protocol.make_client_capabilities()|, passed to the language server on initialization.
  --  Hint: use make_client_capabilities() and modify its result.

  -- The CORRECT and ONLY solution to selectively disable server capabilities in Neovim: modifying client.server_capabilities in on_attach
  -- disable the server capabilities in the on_attach function after the client has started.
  on_attach = function(client, _bufnr)
    -- Disable capabilities we want Pyright to handle
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.completionProvider = false
    client.server_capabilities.renameProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.workspaceSymbolProvider = false
    client.server_capabilities.signatureHelpProvider = false
    -- client.server_capabilities.workspace = false
  end,
}
