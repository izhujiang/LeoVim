return {
  -- Quickstart configs for Nvim LSP
  {
    "neovim/nvim-lspconfig",
    version = false, -- last release is way too old, version must > v0.1.6, which using lua_ls instead of sumneko_lua
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim", -- mason.nvim as dependency, to make sure that "${data}/mason/bin" is added to ${PATH} where language servers are located.
    },
    opts = {
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
      inlay_hints = {
        enabled = false,
      },
      -- Enable this to show formatters used in a notification
      -- Useful for debugging formatter issues
      format_notify = false,
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
    },
    config = function(_, opts)
      local Util = require("leovim.util")

      -- Global mappings
      -- diagnostics: move from one error/warning to another, and open all errors in a new window.
      vim.keymap.set(
        "n",
        "]d",
        vim.diagnostic.goto_next,
        { desc = "Next diagnostics(Lsp)", noremap = true, silent = true }
      )
      vim.keymap.set(
        "n",
        "[d",
        vim.diagnostic.goto_prev,
        { desc = "Previous diagnostics(Lsp)", noremap = true, silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>df",
        vim.diagnostic.open_float,
        { desc = "Open_float(Lsp)", noremap = true, silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>dq",
        vim.diagnostic.setqflist,
        { desc = "Setqflist(Diagnostics)", noremap = true, silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>dl",
        vim.diagnostic.setloclist,
        { desc = "Setloclist(Diagnostics)", noremap = true, silent = true }
      )

      vim.keymap.set(
        "n",
        "<leader>ld",
        "<cmd>Telescope diagnostics<CR>",
        { desc = "Diagnostics(workspace)", noremap = true, silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>lD",
        "<cmd>Telescope diagnostics bufnr=0<CR>",
        { desc = "Diagnostics(document)", noremap = true, silent = true }
      )
      -- references
      vim.keymap.set(
        "n",
        "<leader>ls",
        "<cmd>Telescope lsp_document_symbols<CR>",
        { desc = "Symbols(document)", noremap = true, silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>lS",
        "<cmd>Telescope lsp_workspace_symbols<CR>",
        { desc = "Symbols(workspace)", noremap = true, silent = true }
      )
      vim.keymap.set(
        "n",
        "<leader>lR",
        "<cmd>Telescope lsp_references<CR>",
        { desc = "References", noremap = true, silent = true }
      )
      vim.keymap.set("n", "<leader>li", vim.show_pos, { desc = "Inspect", noremap = true, silent = true })

      -- Code actions
      vim.keymap.set(
        "n",
        "<leader>lA",
        vim.lsp.codelens.run,
        { desc = "CodeLens action", silent = true, noremap = true }
      )

      -- -- Use LspAttach autocommand to only map the following keys after the language server attaches to the current buffer
      Util.on_attach(function(client, bufnr)
        -- local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- if client.server_capabilities.hoverProvider then
        --   vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf })
        -- end

        -- Definition and Declaration
        vim.keymap.set(
          "n",
          "gd",
          vim.lsp.buf.definition,
          { desc = "Definition(Lsp)", buffer = bufnr, silent = true, noremap = true }
        )
        vim.keymap.set(
          "n",
          "gD",
          vim.lsp.buf.declaration,
          { desc = "Declaration(Lsp)", buffer = bufnr, silent = true, noremap = true }
        )
        vim.keymap.set(
          "n",
          "K",
          vim.lsp.buf.hover,
          { desc = "Hover(Lsp)", buffer = bufnr, silent = true, noremap = true }
        )
        vim.keymap.set(
          "n",
          "gi",
          vim.lsp.buf.implementation,
          { desc = "Implementation(Lsp)", buffer = bufnr, silent = true, noremap = true }
        )
        vim.keymap.set(
          "n",
          "gr",
          vim.lsp.buf.references,
          { desc = "References(Lsp)", buffer = bufnr, silent = true, noremap = true }
        )

        -- Signature help, information about the parameters of your function/method in a floating window.
        vim.keymap.set(
          "n",
          "<leader>lh",
          vim.lsp.buf.signature_help,
          { desc = "Signature help", buffer = bufnr, silent = true, noremap = true }
        )
        vim.keymap.set(
          "n",
          "<leader>lc",
          "<cmd>Telescope lsp_incoming_calls<CR>",
          { desc = "Incoming calls", buffer = bufnr, silent = true, noremap = true }
        )
        vim.keymap.set(
          "n",
          "<leader>lC",
          "<cmd>Telescope lsp_outcoming_calls<CR>",
          { desc = "Outcoming calls", buffer = bufnr, silent = true, noremap = true }
        )

        -- refractor
        vim.keymap.set(
          "n",
          "<leader>lf",
          vim.lsp.buf.format,
          { desc = "Format", buffer = bufnr, silent = true, noremap = true }
        )
        vim.keymap.set(
          "n",
          "<leader>lr",
          vim.lsp.buf.rename,
          { desc = "Rename", buffer = bufnr, silent = true, noremap = true }
        )

        -- Code actions in that case are available suggestions to fix/remove these errors and warnings.
        vim.keymap.set(
          "n",
          "<leader>la",
          vim.lsp.buf.code_action,
          { desc = "Code action", buffer = bufnr, silent = true, noremap = true }
        )

        -- Format buffer when saving
        -- Only a few language servers (lua-language-server) provide formatting but others (bash-language-server) don’t.
        -- use null-ls which kind of merges formatters with language servers. https://smarttech101.com/nvim-lsp-set-up-null-ls-for-beginners/
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("UserLspConfig", {}),
          buffer = bufnr,
          -- NOTE: setting callback = vim.lsp.buf.format directly doesn't work, that's weird
          callback = function()
            vim.lsp.buf.format({ async = false })
            -- TODO: format async or not depending on the performance of machine, sounds that write twice
            -- vim.lsp.buf.format({ async = true })
          end,
        })
      end)

      -- lsp-handlers are functions with special signatures that are designed to handle
      -- responses and notifications from LSP servers.
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      -- setup diagnostics
      local signs = require("leovim.config").icons.diagnostics
      for _, sign in pairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.symbol, numhl = "" })
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- inlay_hint
      local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
      if opts.inlay_hints.enabled and inlay_hint then
        require("leovim.util").on_attach(function(client, bufnr)
          if client.server_capabilities.inlayHintProvider then
            inlay_hint(bufnr, true)
          end
        end)
      end

      -- To appropriately highlight codefences returned from denols
      vim.g.markdown_fenced_languages = { "ts=typescript" }
    end,
  },

  -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "williamboman/mason.nvim",
    },
    opts = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local code_actions = null_ls.builtins.code_actions
      local methods = null_ls.methods
      local null_opts = {
        -- debug = true,
        -- TODO: config project root
        -- root_dir(function) Determines the root of the null-ls server.
        -- On startup, null-ls will call root_dir with the full path to the first file that null-ls attaches to.
        -- root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          formatting.gofumpt,
          formatting.goimports,

          formatting.deno_fmt.with({
            condition = function(utils)
              return utils.root_has_file({ "deno.jsonc", "deno.json" })
            end,
          }),
          formatting.eslint_d.with({
            condition = function(utils)
              return utils.root_has_file({ "package.json" })
            end,
            timeout = 1000,
          }),

          -- looks for stylua.toml or .stylua.toml in the directory where the tool was executed.
          -- If not found, search for .editorconfig file, otherwise fall back to the default configuration.
          formatting.stylua, -- lua file

          formatting.jq, -- lightweight and flexible JSON processor
          formatting.shfmt,

          formatting.cmake_format,

          diagnostics.commitlint.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),

          diagnostics.dotenv_linter.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),

          diagnostics.editorconfig_checker.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),

          diagnostics.misspell.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),

          diagnostics.deno_lint.with({
            condition = function(utils)
              return utils.root_has_file({ "deno.jsonc", "deno.json" })
            end,
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),

          diagnostics.tsc.with({
            condition = function(utils)
              return utils.root_has_file({ "tsconfig.json" })
            end,
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
          diagnostics.shellcheck.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),

          diagnostics.hadolint.with({ -- dockerfile
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),

          -- diagnostics.checkmake.with({
          --   method = methods.DIAGNOSTICS_ON_SAVE,
          -- }),

          diagnostics.flake8.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),

          -- diagnostics.actionlint.with({ -- GitHub Actions workflow file
          --   method = methods.DIAGNOSTICS_ON_SAVE,
          -- }),

          code_actions.refactoring,
          code_actions.gitsigns.with({
            disabled_filetypes = { "lua" },
          }),

          code_actions.gomodifytags,
          code_actions.impl,

          code_actions.shellcheck, -- shell script code actions
        },
      }

      if vim.loop.os_uname().machine ~= "aarch64" then
        null_opts = vim.tbl_deep_extend(
          "force",
          null_opts,
          {
            sources = {
              diagnostics.selene.with({
                condition = function(utils) -- indicating whether null-ls should register the source.
                  return utils.root_has_file({ "selene.toml" })
                end,
              }),
            },
          }
        )
      end

      return null_opts
    end,
  },

  -- TODO:
  -- Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
  {
    "folke/neodev.nvim",
    ft = { "lua" },
    -- config = function()
    --   -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
    --   require("neodev").setup({
    --     -- add any options here, or leave empty to use the default settings
    --   })
    -- end,
  },
}