return {
  {
    -- Quickstart configs for Nvim LSP
    -- nvim-lspconfig providing basic, default Nvim LSP client configurations for various LSP servers.
    "neovim/nvim-lspconfig",
    version = false,             -- last release is way too old, version must > v0.1.6, which using lua_ls instead of sumneko_lua
    dependencies = {
      "williamboman/mason.nvim", -- ensure lsp servers has been installed. and mason/bin directory added to $PATH
    },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>zL", "<cmd>LspInfo<cr>",          desc = "LSP Info" },
      { "<leader>le", vim.diagnostic.open_float,   desc = "Diagnostic(LSP)" },
      { "<leader>lq", vim.diagnostic.setqflist,    desc = "Diagnostic Quickfix(LSP)" },
      { "<leader>lQ", vim.diagnostic.setloclist,   desc = "Diagnostic Loclist(LSP)" },
      { "<leader>ld", vim.lsp.buf.definition,      desc = "Definition(LSP)" },
      { "<leader>lD", vim.lsp.buf.declaration,     desc = "Declaration(LSP)" },
      { "<leader>lr", vim.lsp.buf.references,      desc = "References(LSP)" },
      { "<leader>li", vim.lsp.buf.implementation,  desc = "Implementation(LSP)" },
      { "<leader>ls", vim.lsp.buf.document_symbol, desc = "Document_symbol(LSP)" },
      { "<leader>lh", vim.lsp.buf.signature_help,  desc = "Signature_help(LSP)" },
      { "<leader>la", vim.lsp.buf.code_action,     desc = "Code Action(LSP)" },
      { "<leader>lc", vim.lsp.codelens.run,        desc = "CodeLens Action(LSP)" },
      { "<leader>ln", vim.lsp.buf.rename,          desc = "Rename(LSP)" },
      { "<leader>lf", vim.lsp.buf.format,          desc = "Format(LSP)" },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local lsp_server = require("leovim.plugins.core.lsp.server")

      local servers = { "lua_ls", "gopls" }
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
      local null_ls = require("null-ls")
      local code_actions = null_ls.builtins.code_actions
      -- local completion = null_ls.builtins.completion
      local diagnostics = null_ls.builtins.diagnostics
      local formatting = null_ls.builtins.formatting

      local methods = null_ls.methods
      return {
        -- debug = true,
        -- root_dir(function) Determines the root of the null-ls server.
        -- On startup, null-ls will call root_dir with the full path to the first file that null-ls attaches to.
        -- root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          -- Code Actions
          -- code_actions.gitrebase,    -- { "gitrebase" }
          -- code_actions.gitsigns,     -- Git operations at the current cursor position (stage / preview / reset hunks, blame, etc.)
          code_actions.gomodifytags, -- Go tool to modify struct field tags
          code_actions.impl,         -- implementing an interface (go)
          -- code_actions.refactoring,  -- { "go", "javascript", "lua", "python", "typescript" }

          -- Completion
          -- completion.spell,       -- Spell suggestions
          -- completion.luasnip,     -- DON'T use luasnip and tags, which have
          -- been sources of nvim-cmp.
          -- been completion.tags,

          -- Diagnostics
          -- diagnostics.actionlint.with({
          --   method = methods.DIAGNOSTICS_ON_SAVE,
          -- }),                         -- GitHub Actions workflow files.
          -- diagnostics.buf,         -- Filetypes: { "proto" }
          -- diagnostics.checkmake.with({
          --   method = methods.DIAGNOSTICS_ON_SAVE,
          -- }),                         -- Filetypes: { "make" }
          -- diagnostics.checkstyle.with({ extra_args = { "-c",
          -- "/google_checks.xml" }, }),   -- Filetypes: { "java" }
          -- diagnostics.cmake_lint,         -- Filetypes: { "cmake" }
          -- diagnostics.codespell.with({
          --   method = methods.DIAGNOSTICS_ON_SAVE,
          -- }),                           -- common misspellings in text files
          diagnostics.commitlint, -- conventional commit format.
          -- diagnostics.cppcheck,      -- fast static analysis of C/C++ code
          -- diagnostics.dotenv_linter, -- Lightning-fast linter for .env files.
          -- diagnostics.editorconfig_checker.with({
          --   method = methods.DIAGNOSTICS_ON_SAVE,
          -- }),                        -- .editorconfig
          diagnostics.golangci_lint, -- Go linter aggregator.
          -- diagnostics.hadolint.with({
          --   method = methods.DIAGNOSTICS_ON_SAVE,
          -- }),                        -- Filetypes: { "dockerfile" }
          diagnostics.markdownlint.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }), -- Markdown style and syntax checker.

          diagnostics.selene.with({
            condition = function(utils)
              return utils.root_has_file({ "selene.toml" })
            end,
            method = methods.DIAGNOSTICS_ON_SAVE,
          }), -- Lua code linter. Filetypes: { "lua", "luau" }
          -- diagnostics.staticcheck,   -- Advanced Go linter.
          -- diagnostics.todo_comments,    -- TODO comments
          -- diagnostics.vint.with({
          --   method = methods.DIAGNOSTICS_ON_SAVE,
          -- }),                        -- Linter for Vimscript.
          -- diagnostics.yamllint.with({
          --   method = methods.DIAGNOSTICS_ON_SAVE,
          -- }),                        -- A linter for YAML files.
          -- diagnostics.zsh.with({
          --   method = methods.DIAGNOSTICS_ON_SAVE,
          -- }),                        -- zsh linter

          -- Formatting
          -- Formatter, linter, bundler, and more for JavaScript, TypeScript,
          -- JSON, HTML, Markdown, CSS and GraphQL.
          formatting.biome,
          -- formatting.buf,           -- Protocol Buffers
          -- formatting.cmake_format,
          -- By default, gopls uses gofmt for formatting Go code.
          formatting.gofumpt,   -- A stricter version of gofmt with more stylistic rules.
          formatting.goimports, -- A superset of gofmt that also manages imports.
          -- formatting.google_java_format,
          -- formatting.markdownlint, -- A Node.js style checker and lint tool for Markdown files
          -- formatting.pg_format,     -- PostgreSQL SQL syntax beautifier
          formatting.prettier, -- an opinionated code formatter.(web files, json, markdown, GraphQL ...)
          -- formatting.prisma_format, -- Filetypes: { "prisma" }
          -- formatting.remark,        --  extensive and complex Markdown formatter/prettifier
          -- formatting.rustywind,     -- organizing Tailwind CSS classes
          formatting.shfmt,  -- A shell parser, formatter, and interpreter with bash support.
          formatting.stylua, -- Filetypes: { "lua", "luau" }
          -- formatting.yamlfmt,

          -- Golang:
          -- gopls, provides IDE-like features such as autocompletion, linting,
          -- and formatting for Go code. It integrates with editors (like
          -- VSCode, Neovim, etc.) to offer real-time support for Go
          -- developers. It typically uses gofmt as the default formatter but
          -- can also be configured to use goimports or gofumpt.
          -- gofmt, the “standard” for Go code formatting, formats Go code according to a canonical style.
          -- goimports, a superset of gofmt that also manages imports.
          -- gofumpt, a stricter version of gofmt with more stylistic rules.

          -- lua:
          -- •	lua_ls: Real-time code intelligence and basic formatting, often integrated into editors.
          -- •	selene: A static analyzer and linter to check for code quality issues.
          -- •	stylua: A code formatter that enforces a consistent style across your Lua codebase.
        },
      }
    end,
  },
}
