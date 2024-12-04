return {
  {
    -- Quickstart configs for Nvim LSP
    -- nvim-lspconfig providing basic, default Nvim LSP client configurations for various LSP servers.
    "neovim/nvim-lspconfig",
    version = false, -- last release is way too old, version must > v0.1.6, which using lua_ls instead of sumneko_lua
    dependencies = {
      "williamboman/mason.nvim", -- ensure lsp servers has been installed. and mason/bin directory added to $PATH
    },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>zL", "<cmd>LspInfo<cr>", desc = "LSP Info" },
      { "<leader>le", vim.diagnostic.open_float, desc = "Diagnostic(LSP)" },
      { "<leader>lq", vim.diagnostic.setqflist, desc = "Diagnostic Quickfix(LSP)" },
      { "<leader>lQ", vim.diagnostic.setloclist, desc = "Diagnostic Loclist(LSP)" },
      { "<leader>ld", vim.lsp.buf.definition, desc = "Definition(LSP)" },
      { "<leader>lD", vim.lsp.buf.declaration, desc = "Declaration(LSP)" },
      { "<leader>lr", vim.lsp.buf.references, desc = "References(LSP)" },
      { "<leader>li", vim.lsp.buf.implementation, desc = "Implementation(LSP)" },
      { "<leader>ls", vim.lsp.buf.document_symbol, desc = "Document_symbol(LSP)" },
      { "<leader>lh", vim.lsp.buf.signature_help, desc = "Signature_help(LSP)" },
      { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action(LSP)" },
      { "<leader>lc", vim.lsp.codelens.run, desc = "CodeLens Action(LSP)" },
      { "<leader>ln", vim.lsp.buf.rename, desc = "Rename(LSP)" },
      { "<leader>lf", vim.lsp.buf.format, desc = "Format(LSP)" },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local lsp_server = require("leovim.plugins.core.lsp.server")

      -- TODO: config server dynamically.
      local servers = { "lua_ls", "gopls", "clangd", "pyright", "rust_analyzer", "bashls", "cmake" }
      for _, server_name in ipairs(servers) do
        -- hook_setup_before()
        local lsp_server_conf = lsp_server.make_config(server_name, {})
        lspconfig[server_name].setup(lsp_server_conf)
        -- hook_setup_after()
      end

      local lsp_client = require("leovim.plugins.core.lsp.client")
      lsp_client.setup(opts)
    end,
  },

  -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
  {
    "nvimtools/none-ls.nvim",
    -- enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>zn", "<cmd>NullLsInfo<cr>", desc = "null_ls Info" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      return require("leovim.plugins.core.lsp.server")["null-ls"]()
    end,
  },

  -- The Refactoring library based off the Refactoring book by Martin Fowler
  -- Refactoring Features, Support for various common refactoring operations: Extract/Inline Function/Variable
  -- Debug Features, useful features for debugging(Printf, Print var, Cleanup)
  -- usage:
  --   '<,'>:Refactor operation
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
  },
}