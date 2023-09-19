return {
  -- Quickstart configs for Nvim LSP
  {
    "neovim/nvim-lspconfig",
    version = false, -- last release is way too old, version must > v0.1.6, which using lua_ls instead of sumneko_lua
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim", -- mason.nvim as dependency, to make sure that "${data}/mason/bin" is added to ${PATH} where language servers are located.
    },
    keys = {
      { "<leader>Il", "<cmd>LspInfo<CR>", desc = "Info" },
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
      -- add any global capabilities here
      capabilities = {},

      on_attach = function(client, bufnr)
        local buf_opts = function(opts)
          return vim.tbl_extend("force", { buffer = bufnr, noremap = true, silent = true }, opts or {})
        end

        require("which-key").register({
          ["<leader>l"] = {
            name = "+LSP",
          }
        }, {
          buffer = bufnr,
          silent = true,
          noremap = true,
        })

        -- Definition and Declaration
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, buf_opts({ desc = "Definition(Lsp)" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, buf_opts({ desc = "Declaration(Lsp)" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts({ desc = "Hover(Lsp)" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buf_opts({ desc = "Implementation(Lsp)" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, buf_opts({ desc = "References(Lsp)" }))

        -- diagnostics: move from one error/warning to another, and open all errors in a new window.
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, buf_opts({ desc = "Next diagnostics(Lsp)" }))
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, buf_opts({ desc = "Previous diagnostics(Lsp)" }))
        vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, buf_opts({ desc = "Open_float(Lsp)" }))
        vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, buf_opts({ desc = "Setqflist(Diagnostics)" }))
        vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, buf_opts({ desc = "Setloclist(Diagnostics)" }))

        vim.keymap.set(
          "n",
          "<leader>ld",
          "<cmd>Telescope diagnostics<CR>",
          buf_opts({ desc = "Diagnostics(workspace)" })
        )
        vim.keymap.set(
          "n",
          "<leader>lD",
          "<cmd>Telescope diagnostics bufnr=0<CR>",
          buf_opts({ desc = "Diagnostics(document)" })
        )
        -- references
        vim.keymap.set(
          "n",
          "<leader>ls",
          "<cmd>Telescope lsp_document_symbols<CR>",
          buf_opts({ desc = "Symbols(document)" })
        )
        vim.keymap.set(
          "n",
          "<leader>lS",
          "<cmd>Telescope lsp_workspace_symbols<CR>",
          buf_opts({ desc = "Symbols(workspace)" })
        )
        vim.keymap.set("n", "<leader>lR", "<cmd>Telescope lsp_references<CR>", buf_opts({ desc = "References" }))
        vim.keymap.set("n", "<leader>li", vim.show_pos, buf_opts({ desc = "Inspect" }))

        -- Signature help, information about the parameters of your function/method in a floating window.
        -- using the plug-in hrsh7th/cmp-nvim-lsp-signature-help which is more useful without using any shortcut key to invoke.
        vim.keymap.set("n", "<leader>lh", vim.lsp.buf.signature_help, buf_opts({ desc = "Signature help" }))
        vim.keymap.set(
          "n",
          "<leader>lc",
          "<cmd>Telescope lsp_incoming_calls<CR>",
          buf_opts({ desc = "Incoming calls" })
        )
        vim.keymap.set(
          "n",
          "<leader>lC",
          "<cmd>Telescope lsp_outcoming_calls<CR>",
          buf_opts({ desc = "Outcoming calls" })
        )

        -- refractor
        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, buf_opts({ desc = "Format" }))
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, buf_opts({ desc = "Rename" }))

        -- Code actions in that case are available suggestions to fix/remove these errors and warnings. Not all language servers provide this service.
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, buf_opts({ desc = "Code action" }))
        vim.keymap.set("n", "<leader>lA", vim.lsp.codelens.run, buf_opts({ desc = "CodeLens action" }))
      end,

      -- Automatically format on save
      autoformat = true,
      -- Enable this to show formatters used in a notification
      -- Useful for debugging formatter issues
      format_notify = false,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },

      servers = {},
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    config = function(_, opts)
      -- setup servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local function make_server_opts(lang_spec_opts)
        local capabilities = vim.tbl_deep_extend(
          "force",
          {},
          vim.lsp.protocol.make_client_capabilities(),
          has_cmp and cmp_nvim_lsp.default_capabilities() or {},
          opts.capabilities or {}
        )

        capabilities.textDocument.completion.completionItem.resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        }
        -- !!! DON'T enable cmp_nvim_lsp snippetSupport
        capabilities.textDocument.completion.completionItem.snippetSupport = false
        -- capabilities.textDocument.completion.completionItem.snippetSupport = true

        local server_opts = vim.tbl_deep_extend("force", {
          -- capabilities = vim.deepcopy(capabilities),
          capabilities = capabilities,
          on_attach = opts.on_attach,
        }, lang_spec_opts or {})

        return server_opts
      end

      local function setup(server)
        local server_opts = make_server_opts(opts.servers[server])

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- TODO: defer to setup servers, trigger filetype autocommand to invoke servers setup.
      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts

          -- print(vim.inspect(server_opts))
          setup(server)
        end
      end

      local Util = require("leovim.util")
      if Util.lsp_get_config("denols") and Util.lsp_get_config("tsserver") then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        Util.lsp_disable("tsserver", is_deno)
        Util.lsp_disable("denols", function(root_dir)
          return not is_deno(root_dir)
        end)
      end

      -- lsp-handlers are functions with special signatures that are designed to handle
      -- responses and notifications from LSP servers.
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
          vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      -- Formatting
      -- Only a few language servers (lua-language-server) provide formatting but others (bash-language-server) don’t.
      -- use null-ls which kind of merges formatters with language servers. https://smarttech101.com/nvim-lsp-set-up-null-ls-for-beginners/
      if opts.autoformat then
        require("leovim.util").on_attach(function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
              -- TODO: format async or not depending on the performance of machine, sounds that write twice
              -- vim.lsp.buf.format({ async = true })
            end,
          })
          -- NOTE: setting callback = vim.lsp.buf.format directly doesn't work, that's weird
          -- vim.api.nvim_create_autocmd({ "BufWritePre" },
          -- 	{ group = vim.api.nvim_create_augroup("UserLspConfig", {}), callback = vim.lsp.buf.format })
        end)
      end

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
    },
    opts = function()
      local null_ls = require("null-ls")
      -- local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      -- local code_actions = null_ls.builtins.code_actions
      local methods = null_ls.methods
      return {
        -- debug = true,
        -- TODO: config project root
        -- root_dir(function) Determines the root of the null-ls server.
        -- On startup, null-ls will call root_dir with the full path to the first file that null-ls attaches to.
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
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

          -- code_actions.refactoring,
          -- code_actions.gitsigns.with({
          -- 	disabled_filetypes = { "lua" },
          -- }),
        },
      }
    end,
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  },
}
