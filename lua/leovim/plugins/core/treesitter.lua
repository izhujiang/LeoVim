-- local load_textobjects = false
return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },

    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        event = "VeryLazy",
      },
      {
        "nvim-tree/nvim-web-devicons",
        event = "VeryLazy",
      },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- disable rtp plugin, as we only need its queries for mini.ai
          -- In case other textobject modules are enabled, we will load them
          -- once nvim-treesitter is loaded
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          -- load_textobjects = true
        end,
      },
    },
    cmd = { "TSUpdateSync" },
    -- keys = {
    --   { "<c-space>", desc = "Increment selection" },
    --   { "<bs>", desc = "Decrement selection", mode = "x" },
    -- },
    ---@type TSConfig
    opts = {
      -- TODO:: A list of parser names, or "all"
      -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "comment",
        "cpp",
        "css",
        "diff",
        "dockerfile",
        "dot",
        "gitcommit",
        "go",
        "html",
        "java",
        "javascript",
        "json",
        "json5",
        "jsonc",
        "lua",
        "markdown",
        "markdown_inline",
        "ninja",
        "prisma",
        "python",
        "ruby",
        "ron",
        "rust",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },

      sync_install = false,
      auto_install = true,
      -- List of parsers to ignore installing (for "all")
      ignore_install = {},

      -- Available modules: Highlight, Increment Selection, Indentation, Folding
      modules = {},
      highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        disable = { "c", "rust" },
      },
      indent = {
        enable = true,
        -- disable = { "python", "css" }
        disable = { "css" },
      },
      incremental_selection = {
        enable = false,
        -- keymaps = {
        -- init_selection = "<C-space>",
        -- node_incremental = "<C-space>",
        -- scope_incremental = false,
        -- node_decremental = "<bs>",
        -- },
      },
      autopairs = {
        enable = true,
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      -- vim.cmd.syntax("off") 									-- tree-sitter highlight enabled along with syntax on

      require("nvim-treesitter.configs").setup(opts)

      -- if load_textobjects then
      --   -- PERF: no need to load the plugin, if we only need its queries for mini.ai
      --   if opts.textobjects then
      --     for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
      --       if opts.textobjects[mod] and opts.textobjects[mod].enable then
      --         local Loader = require("lazy.core.loader")
      --         Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
      --         local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
      --         require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
      --         break
      --       end
      --     end
      --   end
      -- end

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = true
    end,
  },
}