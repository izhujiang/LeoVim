return {
  keys = {
    { "<leader>zI", "<cmd>NullLsInfo<cr>", desc = "Info(null_ls)" },
  },

  opts = function()
    local null_ls = require("null-ls")
    local code_actions = null_ls.builtins.code_actions
    -- local completion = null_ls.builtins.completion
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    local methods = null_ls.methods

    return {
      debug = false,
      --   -- root_dir(function) Determines the root of the null-ls server.
      --   -- On startup, null-ls will call root_dir with the full path to the first file that null-ls attaches to.
      --   -- root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
      should_attach = function(bufnr)
        local buf_name = vim.api.nvim_buf_get_name(bufnr)
        return not (
          buf_name:match("^git://")
          -- or buf_name:match(".go$")
          or buf_name == "go.mod"
          or buf_name == "go.work"
          or buf_name:match(".c$")
          or buf_name:match(".cpp$")
          or buf_name:match(".h$")
          or buf_name:match(".hpp$")
          or buf_name:match(".rs$")
          or buf_name:match(".py$")
          -- or buf_name:match(".json$")
          or buf_name == "Cargo.toml"
        )
      end,
      sources = {
        -- Code Actions (gra)
        code_actions.gitrebase, -- { "gitrebase" }
        -- https://github.com/ThePrimeagen/refactoring.nvim
        -- code_actions.refactoring, -- { "go", "javascript", "lua", "python", "typescript" }

        -- Diagnostics
        -- diagnostics.actionlint.with({
        --   method = methods.DIAGNOSTICS_ON_SAVE,
        -- }),                         -- GitHub Actions workflow files.
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
        -- diagnostics.dotenv_linter, -- Lightning-fast linter for .env files.
        -- diagnostics.editorconfig_checker.with({
        --   method = methods.DIAGNOSTICS_ON_SAVE,
        -- }),                        -- .editorconfig

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

        -- diagnostics.vint.with({
        --   method = methods.DIAGNOSTICS_ON_SAVE,
        -- }),                        -- Linter for Vimscript.
        -- diagnostics.yamllint.with({
        --   method = methods.DIAGNOSTICS_ON_SAVE,
        -- }),                        -- A linter for YAML files.

        -- Formatting
        -- Formatter, linter, bundler, and more for JavaScript, TypeScript, JSON, HTML, Markdown, CSS and GraphQL.
        -- formatting.buf, -- Protocol Buffers
        -- formatting.cmake_format,
        -- formatting.markdownlint, -- A Node.js style checker and lint tool for Markdown files
        -- formatting.pg_format,     -- PostgreSQL SQL syntax beautifier
        -- formatting.prisma_format, -- Filetypes: { "prisma" }
        -- formatting.remark,        --  extensive and complex Markdown formatter/prettifier
        -- formatting.shfmt, -- A shell parser, formatter, and interpreter with bash support.
        -- formatting.stylua, -- Filetypes: { "lua", "luau" }
        -- formatting.yamlfmt,

        -- Golang:
        -- gopls, provides IDE-like features such as autocompletion, linting, and formatting for Go code.
        -- It typically uses gofmt as the default formatter but can also be configured to use goimports or gofumpt.
        --    gofmt, the “standard” for Go code formatting, formats Go code according to a canonical style.
        --    goimports, a superset of gofmt that also manages imports.
        --    gofumpt, a stricter version of gofmt with more stylistic rules.

        -- lua:
        -- •	lua_ls: Real-time code intelligence and basic formatting, often integrated into editors.
        -- •	selene: A static analyzer and linter to check for code quality issues.
        -- •	stylua: A code formatter that enforces a consistent style across your Lua codebase.
      },
    }
  end,
}
