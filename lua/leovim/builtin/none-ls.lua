return {
  keys = {
    { "<leader>zn", "<cmd>NullLsInfo<cr>", desc = "Info(null_ls)" },
  },

  opts = function()
    local null_ls = require("null-ls")
    local code_actions = null_ls.builtins.code_actions
    -- local completion = null_ls.builtins.completion
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    local methods = null_ls.methods

    return {
      debug = true,
      --   -- root_dir(function) Determines the root of the null-ls server.
      --   -- On startup, null-ls will call root_dir with the full path to the first file that null-ls attaches to.
      --   -- root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),

      sources = {
        -- Code Actions
        code_actions.gitrebase, -- { "gitrebase" }
        code_actions.gomodifytags, -- Go tool to modify struct field tags
        code_actions.impl, -- implementing an interface (go)
        code_actions.refactoring, -- { "go", "javascript", "lua", "python", "typescript" }

        -- Completion
        -- completion.spell, -- Spell suggestions, sounds good for plain text
        -- completion.luasnip,     -- DON'T use luasnip and tags, which have been sources of nvim-cmp.
        -- completion.tags,

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
        --
        -- diagnostics.cmake_lint, -- Filetypes: { "cmake" }
        --
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
        diagnostics.markdownlint_cli2,

        -- diagnostics.selene,
        diagnostics.selene.with({
          condition = function(utils)
            return utils.root_has_file({ "selene.toml" })
          end,
          method = methods.DIAGNOSTICS_ON_SAVE,
        }), -- Lua code linter. Filetypes: { "lua", "luau" }

        -- diagnostics.staticcheck,   -- Advanced Go linter.
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
        -- formatting.buf, -- Protocol Buffers
        -- formatting.cmake_format,
        -- By default, gopls uses gofmt for formatting Go code.
        formatting.gofumpt, -- A stricter version of gofmt with more stylistic rules.
        formatting.goimports, -- A superset of gofmt that also manages imports.
        -- formatting.google_java_format,
        -- formatting.markdownlint, -- A Node.js style checker and lint tool for Markdown files
        -- formatting.pg_format,     -- PostgreSQL SQL syntax beautifier
        -- formatting.prisma_format, -- Filetypes: { "prisma" }
        -- formatting.remark,        --  extensive and complex Markdown formatter/prettifier
        -- formatting.rustywind,     -- organizing Tailwind CSS classes
        formatting.shfmt, -- A shell parser, formatter, and interpreter with bash support.
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
}