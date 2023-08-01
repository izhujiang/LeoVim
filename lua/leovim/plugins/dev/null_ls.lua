return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    -- event = { "BufReadPost", "BufNewFile" },
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jose-elias-alvarez/typescript.nvim",
    },
    opts = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local code_actions = null_ls.builtins.code_actions
      local methods = null_ls.methods

      -- TODO: optimize config to improve performance (such as format and diagnostics only saving)
      return {
        debug = false,
        sources = {
          formatting.deno_fmt.with({
            condition = function(utils) -- ndicating whether null-ls should register the source.
              return utils.root_has_file({ "deno.jsonc" })
            end,
          }),
          -- formatting.black.with { extra_args = { "--fast" } },
          -- formatting.cmake_format,
          formatting.gofumpt,
          formatting.goimports,
          -- formatting.google_java_format,
          formatting.rome.with({
            filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },
            -- To prefer using a local executable for a built-in. This will cause null-ls to search upwards from the current buffer's directory,
            -- try to find a local executable at each parent directory, and fall back to a global executable if it can't find one locally.
            prefer_local = "node_modules/.bin",
            timeout = 1000,
          }),
          formatting.shfmt,             -- shell script formatting
          formatting.stylua.with({
            condition = function(utils) -- ndicating whether null-ls should register the source.
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
          require("typescript.extensions.null-ls.code-actions"),
        },
      }
    end,
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  },
}
