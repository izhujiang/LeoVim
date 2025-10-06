local icons = require("leovim.config.icons")

-- config for diagnostics
-- @type vim.diagnostic.Opts
local diagnostic_opts = {
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    texthl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
    },
    -- Highlight entire line for errors
    linehl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
    },
    -- Highlight the line number for warnings
    numhl = {
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
  float = {
    focusable = false,
    border = "rounded",
    source = "always",
    -- header = "",
    -- prefix = "",
    -- suffix = "",
  },
  -- most time virtual_text is better option
  virtual_text = {
    current_line = true,
  },
  -- virtual_lines = {
  --   current_line = true,
  -- },
}

-- How to setup(config) lsp: (init_options vs. capabilities vs. server_capabilities)
--  init_options: is sent to the LSP server during the initialize request as part of the LSP protocol.
--  It contains server-specific configuration settings that the server uses to configure its own behavior.
--  For example for Ruff, this includes things like:
--   . lint.enable
--   . format.enable
--   . lineLength
--   . codeAction.*
--  client capabilities: Global, affects what ALL servers see about your Neovim
--    The capabilities table in LSP config is meant to communicate client capabilities to the server (what the client supports)
--  server capabilities (via on_attach): Per-client, you can selectively disable features for specific LSP servers
--    The CORRECT and ONLY solution to selectively disable server capabilities in Neovim: modifying client.server_capabilities in on_attach
--    disable the server capabilities in the on_attach function after the client has started.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, {
  -- form require('blink.cmp').get_lsp_capabilities(config.capabilities)
  textDocument = {
    completion = {
      completionItem = {
        commitCharactersSupport = false,
        deprecatedSupport = true,
        documentationFormat = { "markdown", "plaintext" },
        insertReplaceSupport = true,
        insertTextModeSupport = {
          valueSet = { 1 },
        },
        labelDetailsSupport = true,
        preselectSupport = false,
        resolveSupport = {
          properties = { "documentation", "detail", "additionalTextEdits", "command", "data" },
        },
        snippetSupport = true,
        tagSupport = {
          valueSet = { 1 },
        },
      },
      completionList = {
        itemDefaults = { "commitCharacters", "editRange", "insertTextFormat", "insertTextMode", "data" },
      },
      contextSupport = true,
      insertTextMode = 1,
    },
  },
})

local general_lsp_opts = {
  single_file_support = true,
  root_markers = { ".git" },
  capabilities = capabilities,

  -- WARNING: Found buffers attached to multiple clients with different position encodings.
  -- For typical code with ASCII characters (English letters, numbers, common symbols), UTF-8 and UTF-16 position calculations are identical.
  -- Issues arise with multi-byte characters (Emojis, Non-ASCII characters, Special symbols)
  -- Let servers (VSCode-based Servers) choose UTF-16 if they want

  -- client.offset_encoding is the actual encoding that was negotiated between
  -- the client(capabilities.general.positionEncodings) and server during initialization.
  -- It's the result of the handshake, not what you requested.
  -- on_attach = function(client, _bufnr)
  --   -- Override whatever the server chose (html_ls, tailwindcss_ls
  --   client.offset_encoding = "utf-8"
  -- end,
}

-- --------------------------------------------------------------------------------------------------------------------
-- Helper functions

-- TODO: comment the keybinds which are builtin-defined, when don't need which-key plugin anymore.
--
-- builtin keybinds gw/gq for format
-- Since Neovim v0.8
--    <C-]>: "go to definition" capabilities using diagnostics
--    <C-X><C-O>: omni mode completion in Insert mode
--    gq: LSP formatting
-- Since Neovim v0.9
--    Semantic highlight
-- Since Neovim v0.10
--    K: maps to vim.lsp.buf.hover()
--    [d and ]d: vim.diagnostic.goto_prev() and vim.diagnostic.goto_next()
--    <C-W>d: vim.diagnostic.open_float()
-- Since Neovim v0.11, keybinds are created unconditionally when Nvim starts:

-- global defaults
-- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
-- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
-- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
-- - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
-- - "grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
-- - "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
-- - CTRL-s is mapped in Insert mode to |vim.lsp.buf.signature_help()|

-- buffer-local defaults
-- - 'omnifunc' is set to |vim.lsp.omnifunc()|, use |i_CTRL-X_CTRL-O| to trigger
--   completion.
-- - 'tagfunc' is set to |vim.lsp.tagfunc()|. This enables features like
--   go-to-definition, |:tjump|, and keybinds like |CTRL-]|, |CTRL-W_]|,
--   |CTRL-W_}| to utilize the language server.
-- - 'formatexpr' is set to |vim.lsp.formatexpr()|, so you can format lines via
--   |gq| if the language server supports it.
--   - To opt out of this use |gw| instead of gq, or clear 'formatexpr' on |LspAttach|.
-- - |K| is mapped to |vim.lsp.buf.hover()| unless |'keywordprg'| is customized or
--   a custom keybind for `K` exists.
local function setup_buffer_settings(client, bufnr)
  -- wrapper opts with {buffer = bufnr} for buffer-local keybinds.
  local opts = function(user_opts)
    return vim.tbl_extend("keep", user_opts or {}, { buffer = bufnr, noremap = true, silent = true })
  end

  if client:supports_method("textDocument/foldingRange") then
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
    -- zc, zo, zO, zC, zM, zR ...
  end

  if client:supports_method("textDocument/diagnostic") or client:supports_method("textDocument/publishDiagnostics") then
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts({ desc = "Next diagnostic(LSP)" }))
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts({ desc = "Previous diagnostic(LSP)" }))
    vim.keymap.set("n", "]D", function()
      vim.diagnostic.jump({ count = math.huge, wrap = false, float = true })
    end, { desc = "Last diagnostic(LSP)" })
    vim.keymap.set("n", "[D", function()
      vim.diagnostic.jump({ count = -math.huge, wrap = false, float = true })
    end, { desc = "First diagnostic(LSP)" })

    vim.keymap.set("n", "<C-w>d", vim.diagnostic.open_float, opts({ desc = "Show diagnostic(LSP)" }))
    vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float, opts({ desc = "Show diagnostic(LSP)" }))
    vim.keymap.set("n", "grd", vim.diagnostic.open_float, opts({ desc = "Show diagnostic(LSP)" }))

    vim.keymap.set("n", "grq", vim.diagnostic.setqflist, opts({ desc = "Quickfix(LSP)" }))
    vim.keymap.set("n", "grQ", vim.diagnostic.setloclist, opts({ desc = "Loclist(LSP)" }))
  end

  -- vim.lsp.hover()
  --   - Displays hover information about the symbol under the cursor in a floating window.
  --   - Calling the function twice will jump into the floating window ("KK" open and focus on the hover window)
  if client:supports_method("textDocument/hover") then
    vim.keymap.set("n", "K", function()
      local win_width = vim.api.nvim_win_get_width(0)
      vim.lsp.buf.hover({
        -- focus = false,
        -- focusable = false,
        border = "rounded",
        max_width = math.floor(win_width * 0.8),
        -- max_height = 30,
      })
    end, opts({ desc = "Hover(LSP)" }))
  end

  -- built-in definition: <C-]>
  if client:supports_method("textDocument/definition") then
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts({ desc = "Definition(LSP)" }))
  end
  if client:supports_method("textDocument/declaration") then
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts({ desc = "Declaration(LSP)" }))
  end

  if client:supports_method("textDocument/document_symbol") then
    vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, opts({ desc = "Document_symbol(LSP)" }))
  end

  if client:supports_method("textDocument/references") then
    vim.keymap.set("n", "grr", vim.lsp.buf.references, opts({ desc = "References(LSP)" }))
  end

  if client:supports_method("textDocument/implementation") then
    vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opts({ desc = "Implementation(LSP)" }))
  end

  if client:supports_method("textDocument/typeDefinition") then
    vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, opts({ desc = "TypeDefinition(LSP)" }))
  end

  if client:supports_method("textDocument/signatureHelp") then
    -- Signature help, information about the parameters of your function/method in a floating window.
    -- blink or nvim-cmp popup signature_help automatically in Insert mode
    -- builtin <C-s> since nvim0.11
    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts({ desc = "Signature help(LSP)" }))
  end

  if client:supports_method("callHierarchy/incomingCalls") then
    vim.keymap.set({ "n" }, "grc", vim.lsp.buf.incoming_calls, opts({ desc = "IncomingCalls(LSP)" }))
  end

  if client:supports_method("callHierarchy/outgoingCalls") then
    vim.keymap.set({ "n" }, "grC", vim.lsp.buf.outgoing_calls, opts({ desc = "OutgoingCalls(LSP)" }))
  end

  -- refractor and Code actions
  if client:supports_method("textDocument/rename") then
    vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts({ desc = "Rename(LSP)" }))
  end
  if client:supports_method("textDocument/codeAction") then
    -- Code actions are available suggestions to fix errors and warnings.
    vim.keymap.set({ "n", "v" }, "gra", vim.lsp.buf.code_action, opts({ desc = "Code action(LSP)" }))
  end

  -- CodeLens (contextual, interactive annotations) is an LSP feature that adds virtual text (actions) above code elements.
  -- These actions can be executed, such as running tests, generating methods, or refactoring.
  if client:supports_method("textDocument/codeLens") then
    -- Requests the server to recompute and display CodeLens annotations.
    vim.keymap.set("n", "grR", vim.lsp.codelens.refresh, opts({ desc = "Codelens refresh(LSP)" }))
    -- Execute CodeLens under the cursor
    vim.keymap.set("n", "grl", vim.lsp.codelens.run, opts({ desc = "Codelens run(LSP)" }))
  end
end

function setup_global_settings()
  -- global keymap
  vim.keymap.set("n", "<leader>ov", function()
    vim.diagnostic.config({
      virtual_text = not vim.diagnostic.config().virtual_text,
    })
  end, { desc = "Diagnostic virtual_text" })
  vim.keymap.set("n", "<leader>oV", function()
    vim.diagnostic.config({
      virtual_lines = not vim.diagnostic.config().virtual_lines,
    })
  end, { desc = "Diagnostic virtual_lines" })

  -- autocmds
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("leovim.lsp", { clear = true }),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

      setup_buffer_settings(client, args.buf)

      -- Auto-format on save.
      -- no formatting needed if server supports (rarely implemented) "textDocument/willSaveWaitUntil",
      -- Client(:save) → 'textDocument/willSave' → Server(format, lint, fix...) → 'Array of TextEdits' → Client(applies into buffer and save)
      -- Language servers support willSaveWaitUntil usually: format code, add or organize imports automatically, fix code, apply lint fixes or style adjustments.

      -- For Biome, dynamic registration takes extra time
      -- Wait for dynamic registration to complete
      vim.defer_fn(function()
        local supports_formatting = client:supports_method("textDocument/formatting")
        local supports_range_formatting = client:supports_method("textDocument/rangeFormatting")
        local supports_will_save = client:supports_method("textDocument/willSaveWaitUntil")

        -- vim.print(
        --   string.format(
        --     "[%s] willSave=%s, formatting=%s, rangeFormatting=%s",
        --     client.name,
        --     supports_will_save,
        --     supports_formatting,
        --     supports_range_formatting
        --   )
        -- )

        if not supports_will_save and (supports_formatting or supports_range_formatting) then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
              -- vim.print(client.name, "saving")
              vim.lsp.buf.format({
                id = client.id,
                timeout_ms = 3000,
              })
            end,
          })
        end
      end, 500) -- Wait 500ms for dynamic registration
    end,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("leovim.lsp", { clear = false }),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      if
        not client:supports_method("textDocument/willSaveWaitUntil")
        and client:supports_method("textDocument/formatting")
      then
        vim.api.nvim_clear_autocmds({ event = "BufWritePre", buffer = args.buf })
      end
    end,
  })

  -- TODO: consist with theme changes
  -- vim.api.nvim_create_autocmd("ColorScheme", {
  --   callback = function()
  --     -- stylize (colorize) the annotation (virtual text) displayed by vim.lsp.codelens.refresh()
  --     vim.api.nvim_set_hl(0, "LspCodeLens", { fg = "#008888", italic = true })
  --     vim.api.nvim_set_hl(0, "LspCodeLensSeparator", { fg = "#444444" })
  --   end,
  -- })
end

-- --------------------------------------------------------------------------------------------------------------------
if vim.version().major == 0 and vim.version().minor >= 11 then
  -- https://neovim.io/doc/user/lsp.html#lsp-config
  -- Configure LSP behavior statically via vim.lsp.config(), and dynamically via lsp-attach or Client:on_attach().
  -- Use vim.lsp.config() to define, and selectively enable, LSP configurations.
  -- When an LSP client starts, it resolves its configuration by merging from the following:
  -- 1. Configuration defined for the '*' name.
  -- 2. Configuration from the result of merging all tables returned by lsp/<name>.lua files in 'runtimepath'.
  -- 3. Configurations defined anywhere else.
  -- Note: The merge semantics of configurations follow the behaviour of vim.tbl_deep_extend().

  vim.lsp.set_log_level(vim.g.log_level)

  -- set default configuration for all clients.
  vim.lsp.config("*", general_lsp_opts)
  vim.diagnostic.config(diagnostic_opts)

  setup_global_settings()

  -- "null-ls",  -- null-ls call setup() automatically
  vim.lsp.enable(vim.g.enabled_lsp_servers)
else
  vim.notify("To enable builtin lsp support, neovim version >=0.11 required.", vim.log.levels.WARN)
end
