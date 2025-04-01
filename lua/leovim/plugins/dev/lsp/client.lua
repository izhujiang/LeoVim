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

local function setup_keybinds(_client, bufnr)
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
  -- Since Neovim v0.11
  --    grn: renames all references of the symbol under the cursor.
  --    gra: shows a list of code actions available in the line under the cursor.
  --    grr: lists all the references of the symbol under the cursor.
  --    <Ctrl-s>: displays the function signature of the symbol under the cursor.

  local version_not_010 = vim.fn.has("nvim-0.10") == 0
  local version_not_011 = vim.fn.has("nvim-0.11") == 0
  -- diagnostic
  if version_not_010 then
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts({ desc = "Next diagnostic(LSP)" }))
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts({ desc = "Previous diagnostic(LPS)" }))
    vim.keymap.set("n", "<C-w>d", vim.diagnostic.open_float, opts({ desc = "Show diagnostic(LSP)" }))
  end
  vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float, opts({ desc = "Show diagnostic(LSP)" }))
  vim.keymap.set("n", "grd", vim.diagnostic.open_float, opts({ desc = "Show diagnostic(LSP)" }))

  vim.keymap.set("n", "grq", vim.diagnostic.setqflist, opts({ desc = "Quickfix(LSP)" }))
  vim.keymap.set("n", "grl", vim.diagnostic.setloclist, opts({ desc = "Loclist(LSP)" }))

  -- Declaration, Reference and Hover
  if version_not_010 then
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts({ desc = "Hover(LSP)" }))
  end
  -- built-in definition: <C-]>
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts({ desc = "Goto definition(LSP)" }))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts({ desc = "Goto declaration(LSP)" }))

  if version_not_011 then
    vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, opts({ desc = "Goto document_symbol(LSP)" }))
    vim.keymap.set("n", "grr", vim.lsp.buf.references, opts({ desc = "Goto references(LSP)" }))
    vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opts({ desc = "Goto implementation(LSP)" }))
    -- Signature help, information about the parameters of your function/method in a floating window.
    -- blink or nvim-cmp popup signature_help automatically in Insert mode
    vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts({ desc = "Show signature_help(LSP)" }))
    vim.keymap.set("n", "grh", vim.lsp.buf.signature_help, opts({ desc = "Show signature_help(LSP)" }))
  end

  -- refractor and Code actions
  if version_not_011 then
    vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts({ desc = "Rename(LSP)" }))
    -- Code actions are available suggestions to fix errors and warnings.
    vim.keymap.set({ "n", "v" }, "gra", vim.lsp.buf.code_action, opts({ desc = "Code_action(LSP)" }))
  end
  -- TODO: setup codelens
  vim.keymap.set("n", "grc", vim.lsp.codelens.run, opts({ desc = "Codelens action(LSP)" }))
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
  -- setup LspAttach event handler
  vim.api.nvim_create_autocmd("LspAttach", {
    group = user_lsp_group,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local bufnr = args.buf

      -- TODO: Check if keybinds are already set for this buffer
      setup_keybinds(client, bufnr)
      vim.bo.formatexpr = "v:lua.vim.lsp.formatexpr()"
      vim.lsp.inlay_hint.enable(opts.inlay_hint.enabled, { bufnr = bufnr })

      -- TODO: add more skip_formatting_servers to skip builtin lsp servers's formatting feature and use null-ls instead.
      -- TODO: gopls does not automatically organize imports as part of its default formatting behavior
      -- wait for gopls future version, it's ok to organize imports manually now for the sake of perform
      local skip_formatting_servers = { "gopls", "lua_ls" }
      if vim.tbl_contains(skip_formatting_servers, client.name) then
        -- disable formatting to prefer null-ls
        client.server_capabilities.documentFormattingProvider = false
        -- client.server_capabilities.documentRangeFormattingProvider = false
      end
    end,
  })

  -- TODO: override builtin keybind gw for format as well
  -- Format buffer when saving
  -- Only a few language servers (lua-language-server ...) provide formatting
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = user_lsp_group,
    callback = function(args)
      local clients = vim.lsp.get_clients({ bufnr = args.buf })
      local lsp_clients = vim.tbl_filter(function(c)
        return c.supports_method("textDocument/formatting")
      end, clients)

      if #lsp_clients == 0 then
        vim.notify_once("No LSP Server or null-ls sources setup for formatting.", vim.log.levels.WARN)
      else
        if #lsp_clients > 1 then
          vim.notify_once(
            "Multiple LSP Servers or null-ls sources setup for formatting. Only use " .. lsp_clients[1].name,
            vim.log.levels.WARN
          )
        end

        -- vim.print("formatting with: ", lsp_clients[1].name)
        vim.lsp.buf.format({
          async = false,
          bufnr = args.buf,
          filter = function(c)
            return c.id == lsp_clients[1].id
          end,
        })
      end
    end,
  })

  -- function M.format_filter(client)
  --   local filetype = vim.bo.filetype
  --   local n = require "null-ls"
  --   local s = require "null-ls.sources"
  --   local method = n.methods.FORMATTING
  --   local available_formatters = s.get_available(filetype, method)

  --   if #available_formatters > 0 then
  --     return client.name == "null-ls"
  --   elseif client.supports_method "textDocument/formatting" then
  --     return true
  --   else
  --     return false
  --   end
  -- end

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = user_lsp_group,
    callback = function()
      vim.lsp.codelens.refresh()
    end,
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