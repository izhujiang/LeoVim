-- fuzzy finder: a highly extendable fuzzy finder over lists.
-- Built on the latest awesome features from neovim core.
-- Optional dependencies:
--    fd - better find utility
--    rg - better grep utility
--    bat - syntax highlighted previews when using fzf's native previewer
--    delta - syntax highlighted git pager for git status previews
--    nvim-dap - for Debug Adapter Protocol (DAP) support
--    nvim-treesitter-context - for viewing treesitter context within the previewer
--    render-markdown.nvim or markview.nvim - for rendering markdown files in the previewer
--    chafa - terminal image previewer (recommended, supports most media file formats)
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    -- pattern: <leader>f{target} desc="{target}"
    { "<leader>f'", "<cmd>FzfLua marks<cr>", desc = "marks" },
    { '<leader>f"', "<cmd>FzfLua registers<cr>", desc = "registers" },
    { "<leader>f:", "<cmd>FzfLua command_history<cr>", desc = "command(:) history" },
    { "<leader>f/", "<cmd>FzfLua search_history<cr>", desc = "search(/) history" },
    -- repeat last find
    { "<leader>f.", "<cmd>FzfLua resume<cr>", desc = "last find" },

    { "<leader>fa", "<cmd>FzfLua autocmds<cr>", desc = "autocommands" },
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "buffers" },
    { "<leader>fc", "<cmd>FzfLua commands<cr>", desc = "commands" },
    { "<leader>fC", "<cmd>FzfLua colorschemes<cr>", desc = "colorschemes" },
    -- diagnostics
    { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "diagnostics(buffer)" },
    { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "diagnostics(workspace)" },
    -- Search for a string in your current working directory and get results live as you type,
    { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "search(live grep)" },
    { "<leader>s", "<cmd>FzfLua live_grep<cr>", desc = "search(live grep)" },

    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "files" },
    -- git
    { "<leader>fgb", "<cmd>FzfLua git_branches<cr>", desc = "git branches" },
    { "<leader>fgB", "<cmd>FzfLua git_blame<cr>", desc = "git blame" },
    { "<leader>fgc", "<cmd>FzfLua git_commits<cr>", desc = "git commits" },
    { "<leader>fgC", "<cmd>FzfLua git_bcommits<cr>", desc = "git commits(buffer)" },
    { "<leader>fgf", "<cmd>FzfLua git_files<cr>", desc = "git files" },
    { "<leader>fgs", "<cmd>FzfLua git_status<cr>", desc = "git status" },
    { "<leader>fgS", "<cmd>FzfLua git_stash<cr>", desc = "git stash" },
    { "<leader>fgt", "<cmd>FzfLua git_tags<cr>", desc = "git tags" },
    --
    { "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "helptags" },
    { "<leader>fH", "<cmd>FzfLua highlights<cr>", desc = "highlight" },
    { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "keymaps" },
    { "<leader>fj", "<cmd>FzfLua jumps<cr>", desc = "jumplist" },
    -- lsp
    { "<leader>fla", "<cmd>FzfLua lsp_code_actions<cr>", desc = "code actions" },
    { "<leader>flc", "<cmd>FzfLua lsp_incoming_calls<cr>", desc = "incoming calls" },
    { "<leader>flC", "<cmd>FzfLua lsp_outgoing_calls<cr>", desc = "outgoing calls" },
    { "<leader>fld", "<cmd>FzfLua lsp_definitions<cr>", desc = "definitions" },
    { "<leader>flD", "<cmd>FzfLua lsp_declarations<cr>", desc = "declarations" },
    { "<leader>flf", "<cmd>FzfLua lsp_finder<cr>", desc = "finder" },
    { "<leader>fli", "<cmd>FzfLua lsp_implementations<cr>", desc = "implementations" },
    { "<leader>flr", "<cmd>FzfLua lsp_references<cr>", desc = "references" },
    { "<leader>fls", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "symbols(document)" },
    { "<leader>flS", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "symbols(workspace)" },
    { "<leader>flt", "<cmd>FzfLua lsp_typedefs<cr>", desc = "type definitions" },
    { "<leader>flw", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "symbols(dynamic)" },
    --
    { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "marks" },
    { "<leader>fM", "<cmd>FzfLua man_pages<cr>", desc = "man pages" },
    { "<leader>fq", "<cmd>FzfLua quickfix<cr>", desc = "quickfix" },
    { "<leader>fQ", "<cmd>FzfLua loclist<cr>", desc = "loclist" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "recent files" },
    -- { "<leader>fR", "<cmd>FzfLua resume<cr>", desc = "last find" },
    -- { "<leader>fs", "<cmd>FzfLua grep<cr>", desc = "Search(grep)" },
    { "<leader>fs", "<cmd>FzfLua spell_suggest<cr>", desc = "spell" },
    { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "search cword" },

    -- For Intra-File Navigation: Yes, Tree-sitter can replace tags within a single file.
    -- Its real-time parsing is very useful for jumping to definitions, functions, or classes within a file.
    { "<leader>ft", "<cmd>FzfLua treesitter<cr>", desc = "treesitter" },
    -- Cross-file navigation: Use tags or a language server for fast, project-wide symbol indexing and jumping to definitions
    { "<leader>fT", "<cmd>FzfLua tags<cr>", desc = "tags" },
    -- change cwd
    { "<leader>fz", "<cmd>FzfLua zoxide<cr>", desc = "recent directories" }, -- zoxide

    {
      "<C-x><C-f>",
      function()
        require("fzf-lua").complete_path()
      end,
      mode = { "n", "v", "i" },
      desc = "complete path",
    },
    {
      "<C-x><C-l>",
      function()
        require("fzf-lua").complete_line()
      end,
      mode = { "n", "v", "i" },
      desc = "complete line",
    },
    -- TODO: keymap nvim-dap dap_*** commands
  },

  opts = {
    -- use the "hide" profile
    "hide",
    -- MISC GLOBAL SETUP OPTIONS
    -- winopts = { ...  },     -- UI Options
    -- keymap = { ...  },      -- Neovim keymaps / fzf binds
    -- actions = { ...  },     -- Fzf "accept" binds
    -- fzf_opts = { ...  },    -- Fzf CLI flags
    -- fzf_colors = { ...  },  -- Fzf `--color` specification
    -- hls = { ...  },         -- Highlights
    -- previewers = { ...  },  -- Previewers options
    -- SPECIFIC COMMAND/PICKER OPTIONS, SEE BELOW
    -- files = { ... },
  },
}