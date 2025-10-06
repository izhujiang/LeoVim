return {
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  cmd = { "gopls" },
  root_markers = { "go.work", "go.mod", ".git" },
  single_file_support = false,

  settings = {
    gopls = {
      -- Build
      -- buildFlags = []
      -- env = {}
      directoryFilters = {
        "-**/node_modules", -- Exclude all `node_modules` directories
        "-**/.git", -- Exclude all `.git` directories
        "-**/vendor", -- Exclude Go `vendor` directories
        "-**/tmp", -- Exclude temporary files
        "-**/build", -- Exclude build artifacts
      },
      -- templateExtensions = []
      -- standaloneTags = ["ignore"]
      -- workspaceFiles = []

      -- Formatting
      -- Enable goimports-style formatting
      gofumpt = true, -- Use gofumpt to enforce stricter formatting
      -- local = ""

      -- UI
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
      -- semanticTokens = false,

      -- Completion
      usePlaceholders = false, -- IMPORTANT, DON'T enable placeholders for function parameters when completions
      -- completionBudget= "100ms"
      -- matcher = "Fuzzy"
      -- experimentalPostfixCompletions = true, -- Optional, for postfix completions
      -- completeFunctionCalls = true

      -- Diagnostic
      staticcheck = true, -- Enable static analysis (complete set)
      -- Staticcheck analyzers, like all other analyzers, can be explicitly enabled or disabled using the analyzers configuration setting;
      analyses = {
        -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        --  . all the usual bug-finding analyzers from the go vet suite (e.g. printf; see go tool vet help for the complete list);
        --  . a number of analyzers with more substantial dependencies that prevent them from being used in go vet (e.g. nilness);
        --  . analyzers that augment compilation errors by suggesting quick fixes to common mistakes (e.g. fillreturns); and
        --  . a handful of analyzers that suggest possible style improvements (e.g. simplifyrange).

        -- ST1005 = false, -- disables specific staticcheck rule
        -- nilness = true,
        -- unusedparams = true,
        -- unusedwrite = true,
        shadow = true,
      },

      -- annotations = {} -- annotations specifies the various kinds of compiler optimization details that should be reported as diagnostics
      diagnosticsTrigger = "Save",
      -- analysisProgressReporting = true,

      -- Documentation
      -- hoverKind = "FullDocumentation",
      -- linkTarget = "pkg.go.dev",
      -- linksInHover = true,

      -- Inlayhint
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },

      -- Navigation
      -- importShortcut = "Both",
      -- symbolMatcher = "FastFuzzy",
      -- symbolStyle = "Dynamic",
      -- symbolScope = "all",
    },
  },
}