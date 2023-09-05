return {
  -- Quickstart configs for Nvim LSP
  {
    "neovim/nvim-lspconfig",
    version = false, -- last release is way too old, version must > v0.1.6, which using lua_ls instead of sumneko_lua
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      -- Definition and Declaration
      { "gd",         vim.lsp.buf.definition,                     desc = "Definition(Lsp)" },
      { "gD",         vim.lsp.buf.declaration,                    desc = "Declaration(Lsp)" },
      { "K",          vim.lsp.buf.hover,                          desc = "Hover(Lsp)" },          -- Hover information
      { "gi",         vim.lsp.buf.implementation,                 desc = "Implementation(Lsp)" }, -- Implementation
      { "gr",         vim.lsp.buf.references,                     desc = "References(Lsp)" },     -- References
      -- diagnostics: move from one error/warning to another, and open all errors in a new window.
      { "]d",         vim.diagnostic.goto_next,                   desc = "Next diagnostic" },
      { "[d",         vim.diagnostic.goto_prev,                   desc = "Previous diagnostic" },
      { "<leader>df", vim.diagnostic.open_float,                  desc = "Open_float(Diagnostics)" },
      { "<leader>dq", vim.diagnostic.setqflist,                   desc = "Setqflist(Diagnostics)" },
      { "<leader>dl", vim.diagnostic.setloclist,                  desc = "Setloclist(Diagnostics)" },
      { "<leader>lj", vim.diagnostic.goto_next,                   desc = "Next Diagnostic" },
      { "<leader>lk", vim.diagnostic.goto_prev,                   desc = "Previous Diagnostic" },
      { "<leader>ld", "<cmd>Telescope diagnostics<CR>",           desc = "Diagnostics(workspace)" },
      { "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>",   desc = "Diagnostics(document)" },
      -- references
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>",  desc = "Symbols(document)" },
      { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Symbols(workspace)" },
      { "<leader>lR", "<cmd>Telescope lsp_references<CR>",        desc = "References" },
      { "<leader>li", vim.show_pos,                               desc = "Inspect" },
      -- Signature help, information about the parameters of your function/method in a floating window.
      -- using the plug-in hrsh7th/cmp-nvim-lsp-signature-help which is more useful without using any shortcut key to invoke.
      { "<leader>lh", vim.lsp.buf.signature_help,                 desc = "Signature help" },
      { "<leader>lc", "<cmd>Telescope lsp_incoming_calls<CR>",    desc = "Incoming calls" },
      { "<leader>lC", "<cmd>Telescope lsp_outcoming_calls<CR>",   desc = "Outcoming calls" },
      -- refractor
      { "<leader>lf", vim.lsp.buf.format,                         desc = "Format" },
      { "<leader>lr", vim.lsp.buf.rename,                         desc = "Rename" },
      -- Code actions in that case are available suggestions to fix/remove these errors and warnings. Not all language servers provide this service.
      { "<leader>la", vim.lsp.buf.code_action,                    desc = "Code action" },
      { "<leader>lA", vim.lsp.codelens.run,                       desc = "CodeLens action" },
      { "<leader>Il", "<cmd>LspInfo<CR>",                         desc = "Info" },
    },
    opts = function()
      return {
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
      }
    end,
    config = function(_, opts)
      -- lsp servers setup are done via mason-lspconfig.

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

  -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",

    },
    opts = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local code_actions = null_ls.builtins.code_actions
      local methods = null_ls.methods

      -- TODO: optimize config to improve performance (such as format and diagnostics only saving)
      return {
        -- debug = true,
        sources = {
          formatting.deno_fmt.with({
            condition = function(utils) -- ndicating whether null-ls should register the source.
              return utils.root_has_file({ "deno.jsonc" })
            end,
          }),
          -- formatting.black.with { extra_args = { "--fast" } },
          -- formatting.cmake_format,
          --
          formatting.gofumpt,
          formatting.goimports,

          -- formatting.google_java_format,
          -- formatting.rome.with({
          --   filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },
          --   -- To prefer using a local executable for a built-in. This will cause null-ls to search upwards from the current buffer's directory,
          --   -- try to find a local executable at each parent directory, and fall back to a global executable if it can't find one locally.
          --   prefer_local = "node_modules/.bin",
          --   timeout = 1000,
          -- }),
          formatting.shfmt,             -- shell script formatting
          formatting.stylua.with({
            condition = function(utils) -- indicating whether null-ls should register the source.
              return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
            end,
          }),

          -- TODO: add linter support
          diagnostics.actionlint.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }), -- static checker for GitHub Actions workflow files.
          diagnostics.checkmake.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
          diagnostics.commitlint.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
          diagnostics.deno_lint.with({
            condition = function(utils)
              return utils.root_has_file({ "deno.jsonc" })
            end,
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
          diagnostics.dotenv_linter.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
          diagnostics.editorconfig_checker.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
          diagnostics.flake8.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
          -- diagnostics.golangci_lint, -- most time gopls is good enough to lint, run golangci_lint in CI.
          diagnostics.hadolint.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
          diagnostics.misspell.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
          diagnostics.shellcheck.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }), -- shell script diagnostics
          diagnostics.tsc.with({
            condition = function(utils)
              return not utils.root_has_file({ "deno.jsonc" })
            end,
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),

          code_actions.gomodifytags,
          code_actions.impl,
          -- code_actions.refactoring,
          -- code_actions.gitsigns.with({
          -- 	disabled_filetypes = { "lua" },
          -- }),
          code_actions.shellcheck, -- shell script code actions
        },
      }
    end,
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  },

  -- TODO:
  -- Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
  {
    "folke/neodev.nvim",
    ft = { "lua" },
    config = function()
      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
      require("neodev").setup({
        -- add any options here, or leave empty to use the default settings
      })
    end,
  },
}
