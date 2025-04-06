return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  single_file_support = true,

  settings = {
    gopls = {
      -- Enable goimports-style formatting
      gofumpt = true, -- Use gofumpt to enforce stricter formatting
      experimentalPostfixCompletions = true, -- Optional, for postfix completions
      directoryFilters = {
        "-**/node_modules", -- Exclude all `node_modules` directories
        "-**/.git", -- Exclude all `.git` directories
        "-**/vendor", -- Exclude Go `vendor` directories
        "-**/tmp", -- Exclude temporary files
        "-**/build", -- Exclude build artifacts
      },
      codelenses = {
        -- important! To enable CodeLens, the go workspace or go module must be validate and clear
        gc_details = true, -- Enable GC optimization details
        generate = true, -- Enable "go generate" CodeLens
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true, -- Enable CodeLens for running tests
        tidy = true, -- Enable "go mod tidy" CodeLens
        upgrade_dependency = true, -- Enable dependency upgrade suggestions
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = true, -- Enable placeholders for function parameters
      completeUnimported = true,
      staticcheck = true, -- Enable static analysis
      semanticTokens = false,
      -- semanticTokens = true,
    },
  },
}