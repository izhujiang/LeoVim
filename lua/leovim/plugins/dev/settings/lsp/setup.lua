local setup = {
  clangd = function(_, opts)
    local clangd_ext_opts = require("leovim.util").opts("clangd_extensions.nvim")
    require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
    return true
  end,

  gopls = function(_, opts)
    -- workaround for gopls not supporting semanticTokensProvider
    -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
    require("leovim.util").on_attach(function(client, _)
      if client.name == "gopls" then
        if not client.server_capabilities.semanticTokensProvider then
          local semantic = client.config.capabilities.textDocument.semanticTokens
          client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = {
              tokenTypes = semantic.tokenTypes,
              tokenModifiers = semantic.tokenModifiers,
            },
            range = true,
          }
        end
      end
    end)
  end,

  ruff_lsp = function()
    require("leovim.util").on_attach(function(client, _)
      if client.name == "ruff_lsp" then
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
      end
    end)
  end,

  rust_analyzer = function(_, opts)
    local rust_tools_opts = require("lazyvim.util").opts("rust-tools.nvim")
    require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))
    return true
  end,

  tsserver = function(_, opts)
    require("typescript").setup({ server = opts })
    return true
  end,
}

return setup
