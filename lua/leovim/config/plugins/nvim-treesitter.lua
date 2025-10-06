return {
  keys = {
    { "<leader>zt", "<cmd>TSInstallInfo<cr>", desc = "Info(Tree-sitter install)" },
    { "<leader>zT", "<cmd>TSConfigInfo<cr>", desc = "Info(Tree-sitter config)" },
  },
  opts = {
    -- Automatically install missing parsers when entering buffer,
    -- set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,
    -- install other language parsers manually when necessary
    ensure_installed = {
      "comment",
      "bash",
      "c",
      "cpp",
      "go",
      "gomod",
      "gosum",
      "gotmpl",
      "gowork",
      "html",
      "javascript",
      "typescript",
      "lua",
      "python",
      "regex",
      "rust",
      "markdown",
      "markdown_inline",
    },
    -- modules:
    -- roadmap of nvim-treesitter(https://github.com/nvim-treesitter/nvim-treesitter/issues/4767)
    -- nvim-treesitter will completely drop the module framework, plugins will instead handle setup and attaching themselves.
    -- the bundled modules(indent, incremental_selection, highlight, folding) should be removed:
    highlight = {
      enable = true, -- Enable Tree-sitter-based highlighting
      -- disable = { "c", "rust" },

      -- Disable traditional `syntax on`
      additional_vim_regex_highlighting = false,
      -- For most users and most languages, just using Tree-sitter without syntax on is the recommended approach.
      -- You might use both Tree-sitter and syntax on if you’re working with a language that Tree-sitter doesn’t fully support yet.
      -- In that case, you can enable additional_vim_regex_highlighting = true for that specific language.
    },

    incremental_selection = {
      enable = true,
      -- disable = { "yaml" },
      keymaps = {
        -- TODO: try another keybinds
        init_selection = "<S-space>",
        node_incremental = "<S-space>",
        -- <Ctrl-Shift-space>
        scope_incremental = "<C-S-space>",
        node_decremental = "<S-bs>",
      },
    },
    indent = {
      -- Import: Neovim’s will automatically use Tree-sitter for indentation if it is enabled.
      -- 1) Tree-sitter uses a real-time parser to handle indentation as you type,
      -- 2) Tree-sitter Integration with = Command (filter external program) ({count}== v{motion}= gg=G) when you trigger the = command (for re-indentation).
      -- By default, Neovim uses the = command to re-indent code according to the traditional indentation rules.
      enable = true,
      -- Treesitter indent for Rust, it's been a long-standing issue with {} and blocks.
      -- nvim_treesitter#indent() for html: ignore indentation defined in .editorconfig
      disable = { "html", "rust" },

      -- Tree-sitter Indentation and  lsp.buf.format (LSP-based Formatting) can work together to provide a better overall development experience:
      -- •	Tree-sitter keeps indentation correct as you write and edit code.
      -- •	LSP formatting is called occasionally (manually or on save) to fully reformat your code according to a language’s style guide.
    },
  },
  -- init = function()
  -- disable syntax highlight
  -- vim.cmd("syntax off")

  -- DON'T disable traditional indentation, rust and html (excluded by nvim_treesitter) still use it.
  -- disable traditional indentation and enable treesitter indentation
  -- vim.opt.autoindent = false -- Disable automatic indentation
  -- vim.opt.smartindent = false -- Disable smart indentation
  -- vim.opt.cindent = false -- Disable C-like indentation
  -- vim.cmd("filetype indent off")

  -- Enable Tree-sitter-based folding in Neovim
  -- vim.opt.foldmethod = "expr" -- Use an expression for folding
  -- vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use Tree-sitter for folds

  -- Optional: Set folding options
  -- vim.opt.foldlevel = 99 -- Start with all folds open
  -- vim.opt.foldenable = false -- Disable folding by default
  -- end,
}
