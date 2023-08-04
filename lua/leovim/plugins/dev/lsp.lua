return {
  -- Quickstart configs for Nvim LSP
  {
    "neovim/nvim-lspconfig",
    -- lazy = false, -- lazy load to override keymaps
    event = { "BufReadPost", "BufNewFile" }, -- Important: right time to load and config lsp. config function is executed when the plugin loads.
    dependencies = {
      {
        "hrsh7th/cmp-nvim-lsp",
      },
      { "jose-elias-alvarez/typescript.nvim" },
    },
    keys = {
      -- Definition and Declaration
      {
        "gd",
        vim.lsp.buf.definition,
        desc = "Lsp definition"
      },
      {
        "gD",
        vim.lsp.buf.declaration,
        desc = "Lsp declaration"
      },
      { -- Hover information
        "K",
        vim.lsp.buf.hover,
        desc = "Lsp hover"
      },
      { -- Implementation
        "gi",
        vim.lsp.buf.implementation,
        desc = "Lsp implementation"
      },
      { -- References
        "gr",
        vim.lsp.buf.references,
        desc = "Lsp references"
      },
      {
        -- Signature help, information about the parameters of your function/method in a floating window.
        -- using the plug-in hrsh7th/cmp-nvim-lsp-signature-help which is more useful without using any shortcut key to invoke.
        "<leader>ls",
        vim.lsp.buf.signature_help,
        desc = "Lsp signature help"
      },
      -- diagnostics: move from one error/warning to another, and open all errors in a new window.
      {
        "[d",
        vim.diagnostic.goto_prev,
        desc = "Previous diagnostic"
      },
      {
        "]d",
        vim.diagnostic.goto_next,
        desc = "Next diagnostic"
      },
      {
        "<leader>df",
        vim.diagnostic.open_float,
        desc = "Diagnostic open_float"
      },
      -- already mapped by Telescope with <leader>fd
      -- { "<leader>td", '<cmd>Telescope diagnostics<CR>', desc = "Telescope diagnostics" },
      {
        "<leader>dq",
        vim.diagnostic.setqflist,
        desc = "Diagnostic setqflist"
      },
      {
        "<leader>dl",
        vim.diagnostic.setloclist,
        desc = "Diagnostic setloclist"
      },
      {
        "<leader>lf",
        vim.lsp.buf.format,
        desc = "Lsp format"
      },
      -- Symbols, are special keywords in your code such as variables, functions, etc.
      {
        "<leader>lr",
        vim.lsp.buf.rename,
        desc = "Lsp rename"
      },
      {
        -- Code actions
        -- Code actions in that case are available suggestions to fix/remove these errors and warnings. Not all language servers provide this service.
        "<leader>la",
        vim.lsp.buf.code_action,
        desc = "Lsp code_action"
      },
      {
        -- Get information about language servers
        "<leader>li",
        "<cmd>LspInfo<CR>",
        desc = "Lsp Info"
      },
    },
    opts = function()
      return {
        -- servers = require("leovim.plugins.dev.settings.lsp.servers"),
        -- setup = require("leovim.plugins.dev.settings.lsp.setup"),
        diagnostics = {
          underline = true,
          update_in_insert = false,
          severity_sort = true,
          -- disable virtual text
          virtual_text = true,
          -- show signs
          signs = true,
          --  for <leader>do, vim.diagnostics.open_float
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
      }
    end,
    config = function(_, opts)
      -- local lspconfig = require("lspconfig")
      -- local cmp_nvim_lsp = require("cmp_nvim_lsp")
      -- local capabilities = cmp_nvim_lsp.default_capabilities()
      -- capabilities.textDocument.completion.completionItem.snippetSupport = true
      -- local on_attach = function(client, bufnr)
      --   require("illuminate").on_attach(client)
      -- end
      --
      -- if opts.servers then
      --   for name, server_opts in pairs(opts.servers) do
      --     -- local name = "gopls"
      --     -- local server_opts = opts.servers[name]
      --     Opts = {
      --       on_attach = on_attach,
      --       capabilities = capabilities,
      --     }
      --     Opts = vim.tbl_deep_extend("force", Opts, server_opts)
      --     lspconfig[name].setup(Opts)
      --   end
      -- end
      -- lspconfig["gopls"].setup({
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      -- })

      -- setup diagnostics
      local signs = require("leovim.config").icons.diagnostics
      for _, sign in pairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.symbol, numhl = "" })
      end
      vim.diagnostic.config(opts.diagnostic)

      -- Formatting
      -- Only a few language servers (lua-language-server) provide formatting but others (bash-language-server) don’t.
      -- use null-ls which kind of merges formatters with language servers. https://smarttech101.com/nvim-lsp-set-up-null-ls-for-beginners/
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function()
          vim.lsp.buf.format()
        end,
      })
      -- NOTE: setting callback = vim.lsp.buf.format directly doesn't work, that's weird
      -- vim.api.nvim_create_autocmd({ "BufWritePre" },
      -- 	{ group = vim.api.nvim_create_augroup("UserLspConfig", {}), callback = vim.lsp.buf.format })

      -- To appropriately highlight codefences returned from denols
      vim.g.markdown_fenced_languages = { "ts=typescript" }

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
          vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    end,
  },
}
