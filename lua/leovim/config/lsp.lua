-- --------------------------------------------------------------------------------------------------------------------
-- Helper functions

-- --------------------------------------------------------------------------------------------------------------------
local function make_user_default_capabilities(user_capabilities)
  local capabilities

  local addtional_capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  }
  -- {capabilities} verriding the default capabilities defined by vim.lsp.protocol.make_client_capabilities(),
  -- passed to the language server on initialization. Hint: use make_client_capabilities() and modify its result.

  if vim.g.completion == "blink" then
    local has_cmp, blink_lsp = pcall(require, "blink.cmp")

    capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and blink_lsp.get_lsp_capabilities(addtional_capabilities) or {}
    )
  elseif vim.g.completion == "nvim-cmp" then
    local has_cmp, cmp_nvim_lsp
    has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

    capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      addtional_capabilities
    )
  else
    capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), addtional_capabilities)
  end

  -- !!! DON'T enable cmp_nvim_lsp snippetSupport, already got cmp_luasnip or
  -- other snippet engines' support
  -- Some LSP servers support auto-snippets for functions, so they insert arguments inside brackets.
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  capabilities = vim.tbl_deep_extend("force", capabilities, user_capabilities or {})
  return capabilities
end

local user_default_capabilities = make_user_default_capabilities({})

local function setup_keybinds(client, bufnr)
  local opts = function(user_opts)
    return vim.tbl_extend("keep", user_opts or {}, { buffer = bufnr, noremap = true, silent = true })
  end

  -- builtin keymaps gw/gq for format
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
  -- Since Neovim v0.11, keymaps are created unconditionally when Nvim starts:
  -- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
  -- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
  -- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
  -- - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
  -- - "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
  -- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|

  -- - 'omnifunc' is set to |vim.lsp.omnifunc()|, use |i_CTRL-X_CTRL-O| to trigger
  --   completion.
  -- - 'tagfunc' is set to |vim.lsp.tagfunc()|. This enables features like
  --   go-to-definition, |:tjump|, and keymaps like |CTRL-]|, |CTRL-W_]|,
  --   |CTRL-W_}| to utilize the language server.
  -- - 'formatexpr' is set to |vim.lsp.formatexpr()|, so you can format lines via
  --   |gq| if the language server supports it.
  --   - To opt out of this use |gw| instead of gq, or clear 'formatexpr' on |LspAttach|.
  -- - |K| is mapped to |vim.lsp.buf.hover()| unless |'keywordprg'| is customized or
  --   a custom keymap for `K` exists.

  -- To remove or override BUFFER-LOCAL defaults
  -- -- unset 'formatexpr'
  -- vim.bo[args.buf].formatexpr = nil
  -- -- Unset 'omnifunc'
  -- vim.bo[args.buf].omnifunc = nil
  -- -- remove keymap
  -- vim.keymap.del('n', 'K', { buffer = args.buf })

  -- diagnostic
  -- why client:supports_method("textDocument/diagnostic") return false
  if client:supports_method("textDocument/diagnostic") or client:supports_method("textDocument/publishDiagnostics") then
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1 })
    end, opts({ desc = "Next diagnostic(LSP)" }))
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1 })
    end, opts({ desc = "Previous diagnostic(LSP)" }))
    vim.keymap.set("n", "]D", function()
      vim.diagnostic.jump({ count = math.huge, wrap = false })
    end, { desc = "Last diagnostic(LSP)" })
    vim.keymap.set("n", "[D", function()
      vim.diagnostic.jump({ count = -math.huge, wrap = false })
    end, { desc = "First diagnostic(LSP)" })

    vim.keymap.set("n", "<C-w>d", vim.diagnostic.open_float, opts({ desc = "Show diagnostic(LSP)" }))

    vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float, opts({ desc = "Show diagnostic(LSP)" }))
    vim.keymap.set("n", "grd", vim.diagnostic.open_float, opts({ desc = "Show diagnostic(LSP)" }))

    vim.keymap.set("n", "grq", vim.diagnostic.setqflist, opts({ desc = "Quickfix(LSP)" }))
    vim.keymap.set("n", "grl", vim.diagnostic.setloclist, opts({ desc = "Loclist(LSP)" }))
  end

  -- vim.lsp.hover()
  -- Displays hover information about the symbol under the cursor in a floating window. The window will be dismissed on cursor move.
  -- Calling the function twice will jump into the floating window (thus by default, "KK" will open the hover window and focus it)
  if client:supports_method("textDocument/hover") then
    vim.keymap.set("n", "K", function()
      local win_width = vim.api.nvim_win_get_width(0)
      local config = {
        -- focus = false,
        -- focusable = false,
        border = "rounded",
        max_width = math.floor(win_width * 0.8),
        -- max_height = 30,
      }
      vim.lsp.buf.hover(config)
    end, opts({ desc = "Hover(LSP)" }))
  end

  -- built-in definition: <C-]>
  if client:supports_method("textDocument/definition") then
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts({ desc = "Goto definition(LSP)" }))
  end
  if client:supports_method("textDocument/declaration") then
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts({ desc = "Goto declaration(LSP)" }))
  end

  -- todo: `'workspace/symbol'`
  if client:supports_method("textDocument/document_symbol") then
    vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, opts({ desc = "Goto document_symbol(LSP)" }))
  end

  if client:supports_method("textDocument/references") then
    vim.keymap.set("n", "grr", vim.lsp.buf.references, opts({ desc = "Goto references(LSP)" }))
  end

  if client:supports_method("textDocument/implementation") then
    vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opts({ desc = "Goto implementation(LSP)" }))
  end
  if client:supports_method("textDocument/signatureHelp") then
    -- Signature help, information about the parameters of your function/method in a floating window.
    -- blink or nvim-cmp popup signature_help automatically in Insert mode
    -- builtin <C-s> since nvim0.11
    -- vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts({ desc = "Show signature_help(LSP)" }))
    vim.keymap.set("n", "grh", vim.lsp.buf.signature_help, opts({ desc = "Show signature_help(LSP)" }))
  end

  if client:supports_method("callHierarchy/incomingCalls") then
    vim.keymap.set({ "n" }, "grI", vim.lsp.buf.incoming_calls, opts({ desc = "Goto incomingCalls(LSP)" }))
  end
  if client:supports_method("callHierarchy/outgoingCalls") then
    vim.keymap.set({ "n" }, "gro", vim.lsp.buf.outgoing_calls, opts({ desc = "Goto outgoingCalls(LSP)" }))
  end

  -- refractor and Code actions
  if client:supports_method("textDocument/rename") then
    vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts({ desc = "Rename(LSP)" }))
  end
  if client:supports_method("textDocument/codeAction") then
    -- Code actions are available suggestions to fix errors and warnings.
    vim.keymap.set({ "n", "v" }, "gra", vim.lsp.buf.code_action, opts({ desc = "Code_action(LSP)" }))
  end
  -- TODO: setup codelens
  vim.keymap.set("n", "grc", vim.lsp.codelens.run, opts({ desc = "Codelens(LSP)" }))
end

-- TODO: workspace operations
-- vim.lsp.buf.add_workspace_folder()*
-- vim.lsp.buf.list_workspace_folder()*
-- vim.lsp.buf.remove_workspace_folder()*

-- --------------------------------------------------------------------------------------------------------------------

if vim.fn.has("nvim-0.11") then
  -- https://neovim.io/doc/user/lsp.html#lsp-config
  -- You can configure LSP behavior statically via vim.lsp.config(), and dynamically via lsp-attach or Client:on_attach().
  -- Use vim.lsp.config() to define, and selectively enable, LSP configurations.
  -- This is basically a wrapper around vim.lsp.start() which allows you to share and merge configs (which may be provided by Nvim or third-party plugins).
  --
  -- When an LSP client starts, it resolves its configuration by merging from the following (in increasing priority):
  -- 1. Configuration defined for the '*' name.
  -- 2. Configuration from the result of merging all tables returned by lsp/<name>.lua files in 'runtimepath' for a server of name name.
  -- 3. Configurations defined anywhere else.
  -- Note: The merge semantics of configurations follow the behaviour of vim.tbl_deep_extend().

  -- global config as fallback
  vim.lsp.config("*", {
    capabilities = user_default_capabilities,
    root_markers = { ".git" },
  })

  -- Defined in <rtp>/lsp/clangd.lua
  -- return {
  --   cmd = { 'clangd' },
  --   root_markers = { '.clangd', 'compile_commands.json' },
  --   filetypes = { 'c', 'cpp' },
  -- }

  -- Defined in init.lua or somewhere else
  -- vim.lsp.config('clangd', {
  --   filetypes = { 'c' },
  -- })

  -- setup diagnostic
  local icons = require("leovim.builtin.icons")
  vim.g.virtual_flag = 1
  local diag_opts = {
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    signs = {
      -- Highlight entire line for errors
      -- Highlight the line number for warnings
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
        --
      },
      linehl = {
        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      },
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
      current_line = vim.g.virtual_flag == 1,
    },
    -- virtual_lines = {
    --   current_line = true,
    -- },
  }

  vim.keymap.set("n", "<leader>ov", function()
    vim.g.virtual_flag = (vim.g.virtual_flag + 1) % 6
    vim.print(vim.g.virtual_flag)

    if vim.g.virtual_flag == 0 then
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = false,
      })
    elseif vim.g.virtual_flag == 1 then
      vim.diagnostic.config({
        virtual_text = { current_line = true },
        virtual_lines = false,
      })
    elseif vim.g.virtual_flag == 2 then
      vim.diagnostic.config({
        virtual_text = true,
        virtual_lines = false,
      })
    elseif vim.g.virtual_flag == 3 then
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = { current_line = true },
      })
    elseif vim.g.virtual_flag == 4 then
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = true,
      })
    else
      vim.diagnostic.config({
        virtual_text = true,
        virtual_lines = true,
      })
    end
  end, { desc = "Diagnostic virtual_lines" })

  vim.diagnostic.config(diag_opts)

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("leovim.lsp", { clear = false }),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

      setup_keybinds(client, args.buf)

      -- INFO:  not ready to repalce nvim-cmp.nvim or blink.nvim
      --
      -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
      -- if client:supports_method("textDocument/completion") then
      --   -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      --   -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      --   -- client.server_capabilities.completionProvider.triggerCharacters = chars
      --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      -- end

      if client:supports_method("textDocument/willSaveWaitUntil") then
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
      end

      -- Auto-format ("lint") on save.
      -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
      -- To avoid multiple active lsp server(null-ls) format at same time,
      -- skip servers in the dict, prefer format buffer with null-ls
      local skip_formatting_servers = { "gopls", "lua_ls", "pyright", "jsonls", "ts_ls" }
      -- local skip_formatting_servers = {}
      if
        not client:supports_method("textDocument/willSaveWaitUntil")
        and client:supports_method("textDocument/formatting")
        and not vim.tbl_contains(skip_formatting_servers, client.name)
      then
        vim.bo.formatexpr = "v:lua.vim.lsp.formatexpr()"
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("leovim.lsp", { clear = false }),
          buffer = args.buf,
          callback = function()
            vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
            -- or save synchronously
            -- vim.lsp.buf.format({ async = false })
          end,
        })
      end
    end,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("leovim.lsp", { clear = false }),
    callback = function(args)
      -- Get the detaching client
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      -- Remove the autocommand to format the buffer on save, if it exists
      if client and client:supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({
          event = "BufWritePre",
          buffer = args.buf,
        })
      end
    end,
  })

  -- vim.api.nvim_create_autocmd("BufWritePre", {
  --   group = vim.api.nvim_create_augroup("leovim.lsp", { clear = false }),
  --   callback = function()
  --     vim.lsp.codelens.refresh()
  --   end,
  -- })
  --

  -- vim.lsp global config
  -- vim.lsp.inlay_hint.enable(false)
  -- border style for all floating windows
  vim.o.winborder = "rounded"
  -- warning: not working.
  -- global float windows config not working with lsp config
  -- vim.api.nvim_create_autocmd("VimResized", {
  --   callback = function()
  --     for _, config in pairs(vim.lsp.config) do
  --       config.float_opts = {
  --         max_width = math.floor(vim.o.columns * 0.8),
  --         max_height = math.floor(vim.o.lines * 0.6),
  --       }
  --     end
  --   end,
  -- })

  -- enable lsp's debug mode
  vim.lsp.set_log_level(vim.g.log_level)

  -- warning: not working.
  -- Configure float window size for lua_ls,
  -- vim.lsp.config["lua_ls"] = vim.tbl_deep_extend("force", vim.lsp.config["lua_ls"] or {}, {
  --   float = {
  --     max_width = math.floor(vim.o.columns * 0.8),
  --   },
  -- })
  --
  -- vim.lsp.config["gopls"] = vim.tbl_deep_extend("force", vim.lsp.config["gopls"] or {}, {
  --     max_width = math.floor(vim.o.columns * 0.8),
  -- })

  -- assume: $PATH include mason/bin (mason already loaded) and other path where to find language servers
  vim.lsp.enable({
    "bashls",
    "clangd",
    "cmake",
    "gopls",
    "jsonls",
    "lua_ls",
    -- "null-ls",  -- null-ls call setup() automatically
    "pyright",
    "rust_analyzer",
  })
else
  vim.notify("To enable builtin lsp support, neovim version >=0.11 required.", vim.log.levels.WARN)
end