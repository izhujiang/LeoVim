local M = {}
-- LSP features
-- .. Code actions
-- .. Diagnostics (file- and project-level)
-- .. Formatting (including range formatting)
-- .. Hover
-- .. Completion

local default_opts = {
  diagnostics = {
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = true,
    signs = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      suffix = "",
    },
  },
  -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
  -- Be aware that you also will need to properly configure your LSP server to provide the inlay hints.
  inlay_hint = {
    enabled = false,
  },
}

-- TODO: define keybinds depending on client.server_capabilities
local function setup_keybinds(client, bufnr)
  local opts = function(user_opts)
    return vim.tbl_extend("keep", user_opts or {}, { buffer = bufnr, noremap = true, silent = true })
  end

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
  -- Since Neovim v0.11
  --    grn: renames all references of the symbol under the cursor.
  --    gra: shows a list of code actions available in the line under the cursor.
  --    grr: lists all the references of the symbol under the cursor.
  --    <Ctrl-s>: displays the function signature of the symbol under the cursor.

  local version_not_010 = vim.fn.has("nvim-0.10") == 0
  local version_not_011 = vim.fn.has("nvim-0.11") == 0
  -- diagnostic
  if version_not_010 then
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts({ desc = "Next Diagnostic(LSP)" }))
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts({ desc = "Previous Diagnostic(LPS)" }))
    vim.keymap.set("n", "<C-W>d", vim.diagnostic.open_float, opts({ desc = "Diagnostic(LSP)" }))
  end

  vim.keymap.set("n", "grd", vim.diagnostic.open_float, opts({ desc = "Diagnostic(LSP)" }))
  vim.keymap.set("n", "grq", vim.diagnostic.setqflist, opts({ desc = "Diagnostics Quickfix(LSP)" }))
  vim.keymap.set("n", "grl", vim.diagnostic.setloclist, opts({ desc = "Diagnostics Loclist(LSP)" }))

  -- Definition<C-]>, Declaration, Reference and Hover
  if version_not_010 then
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts({ desc = "Hover(LSP)" }))
  end
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts({ desc = "Definition(LSP)" }))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts({ desc = "Declaration(LSP)" }))

  if version_not_011 then
    vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, opts({ desc = "Document_symbol(LSP)" }))
    vim.keymap.set("n", "grr", vim.lsp.buf.references, opts({ desc = "References(LSP)" }))
    vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opts({ desc = "Implementation(LSP)" }))
    -- Signature help, information about the parameters of your function/method in a floating window.
    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts({ desc = "Signature_help(LSP)" }))
  end

  -- Format
  vim.keymap.set("n", "gQ",
    function()
      local client_count = #vim.lsp.get_clients({ buffer = bufnr })
      if client_count == 1 then
        -- if lsp server (including null-ls) support format, apply it.
        vim.lsp.buf.format({ async = true, bufnr = bufnr })
      elseif client_count >= 2 then
        -- apply null-ls to format
        vim.lsp.buf.format({
          async = true,
          bufnr = bufnr,
          filter = function(c) -- apply null-ls client to apply format
            -- vim.print("gopls: autoformatting", c.id, c.name)
            return c.name == "null-ls"
          end,
        })
      end
    end,
    opts({ desc = "Format(null-ls)" }))

  -- refractor and Code actions
  if version_not_011 then
    vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts({ desc = "Rename(LSP)" }))
    -- Code actions are available suggestions to fix errors and warnings.
    vim.keymap.set({ "n", "v" }, "gra", vim.lsp.buf.code_action, opts({ desc = "Code Action(LSP)" }))
  end
  -- TODO: setup codelens
  vim.keymap.set("n", "grc", vim.lsp.codelens.run, opts({ desc = "CodeLens Action(LSP)" }))
end

-- setup diagnostics
local function setup_diagnostics(opts)
  local signs = require("leovim.config.defaults").icons.diagnostics
  for _, sign in pairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.symbol, numhl = "" })
  end
  vim.diagnostic.config(vim.deepcopy(opts or {}))
end

-- setup highlight
local function setup_highlight()
  -- To appropriately highlight codefences returned from denols
  vim.g.markdown_fenced_languages = { "ts=typescript" }
end

-- setup handlers
local function setup_handlers()
  -- lsp-handlers are functions with special signatures that are designed to handle
  -- responses and notifications from LSP servers.
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

local function setup_autocmds(opts)
  local user_lsp_group = vim.api.nvim_create_augroup("UserLspConfig", {})

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = user_lsp_group,
    callback = function(ev)
      local bufnr = ev.buffer
      local client_count = #vim.lsp.get_clients({ buffer = bufnr })
      -- vim.print("gopls: BufWritePre callback is called, and have " .. client_count .. " clients")
      if client_count == 1 then
        -- if lsp server (including null-ls) support format, then apply it.
        vim.lsp.buf.format({ async = false, bufnr = bufnr })
      elseif client_count >= 2 then
        -- if lsp server (not including null-ls) support format, then apply it.
        vim.lsp.buf.format({
          async = false,
          bufnr = bufnr,
          filter = function(c) -- apply non null-ls client to apply format
            -- vim.print("gopls: autoformatting", c.id, c.name)
            return c.name ~= "null-ls"
          end,
        })
        -- TODO: format async or not depending on the performance of machine,
        -- sounds that write twice
        -- vim.lsp.buf.format({ async = true })
      end
    end
  })

  -- setup LspAttach event handler
  vim.api.nvim_create_autocmd("LspAttach", {
    group = user_lsp_group,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local bufnr = args.buf
      setup_keybinds(client, bufnr)
      vim.bo.formatexpr = "v:lua.vim.lsp.formatexpr()"
      vim.lsp.inlay_hint.enable(opts.inlay_hint.enabled, { bufnr = bufnr })

      -- Format buffer when saving
      -- Only a few language servers (lua-language-server) provide formatting but others (bash-language-server) don’t.
      -- use null-ls which kind of merges formatters with language servers. https://smarttech101.com/nvim-lsp-set-up-null-ls-for-beginners/
    end
  })
end

-- setup globally for lsp clients.
function M.setup(opts)
  opts = vim.tbl_deep_extend("keep", opts or {}, default_opts)

  -- setup_global_keybinds()
  setup_diagnostics(opts.diagnostics)
  setup_highlight()
  setup_handlers()
  setup_autocmds(opts)
end

return M