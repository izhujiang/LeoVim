return {
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

  keys = {
    -- pattern: <leader>f{target} desc="{target}"
    { "<leader>f'", "<cmd>FzfLua marks<cr>", desc = "Find mark" },
    { '<leader>f"', "<cmd>FzfLua registers<cr>", desc = "Find register" },
    { "<leader>f:", "<cmd>FzfLua command_history<cr>", desc = "Find command(:) history" },
    { "<leader>f/", "<cmd>FzfLua search_history<cr>", desc = "Find search(/) history" },
    -- repeat last find
    { "<leader>f.", "<cmd>FzfLua resume<cr>", desc = "last find" },

    -- Search for a string in your current working directory and get results live as you type,
    { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Search(grep)" },
    { "<leader>s", "<cmd>FzfLua live_grep<cr>", desc = "Search(grep)" },

    { "<leader>fa", "<cmd>FzfLua autocmds<cr>", desc = "Find autocommand" },
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find buffer" },
    { "<leader>fc", "<cmd>FzfLua commands<cr>", desc = "Find Ex-command" },
    -- { "<leader>fC", "<cmd>FzfLua colorschemes<cr>", desc = "Find colorscheme" },
    -- diagnostics
    { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Find diagnostic(buffer)" },
    { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Find diagnostic(workspace)" },
    -- TODO: keymap nvim-dap dap_*** commands
    {
      "<leader>ff",
      function()
        -- TODO: if get_root() return nil, then use current path
        local root = require("leovim.utils").get_root()
        if root == nil then
          require("fzf-lua").files()
        else
          require("fzf-lua").files({ cwd = root })
        end
      end,
      desc = "Find file",
    },
    -- git
    { "<leader>fgb", "<cmd>FzfLua git_blame<cr>", desc = "Find blame" },
    { "<leader>fgB", "<cmd>FzfLua git_branches<cr>", desc = "Find branche" },
    { "<leader>fgc", "<cmd>FzfLua git_bcommits<cr>", desc = "Find commit(buffer)" },
    { "<leader>fgC", "<cmd>FzfLua git_commits<cr>", desc = "Find commit" },
    { "<leader>fgf", "<cmd>FzfLua git_files<cr>", desc = "Find file" },
    { "<leader>fgg", "<cmd>FzfLua git_status<cr>", desc = "Find git status" },
    { "<leader>fgs", "<cmd>FzfLua git_stash<cr>", desc = "Find git stash" },
    { "<leader>fgt", "<cmd>FzfLua git_tags<cr>", desc = "Find git tag" },

    { "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Find helptag" },
    { "<leader>fH", "<cmd>FzfLua highlights<cr>", desc = "Find highlight" },
    { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Find keymap" },
    { "<leader>fj", "<cmd>FzfLua jumps<cr>", desc = "Find jump" },
    -- lsp (TODO:)
    { "<leader>fla", "<cmd>FzfLua lsp_code_actions<cr>", desc = "Find code action" },
    { "<leader>flc", "<cmd>FzfLua lsp_incoming_calls<cr>", desc = "Find incoming call" },
    { "<leader>flC", "<cmd>FzfLua lsp_outgoing_calls<cr>", desc = "Find outgoing call" },
    { "<leader>fld", "<cmd>FzfLua lsp_definitions<cr>", desc = "Find definition" },
    { "<leader>flD", "<cmd>FzfLua lsp_declarations<cr>", desc = "Fid declaration" },
    { "<leader>fll", "<cmd>FzfLua lsp_finder<cr>", desc = "LSP finder" },
    { "<leader>fli", "<cmd>FzfLua lsp_implementations<cr>", desc = "Find implementation" },
    { "<leader>flr", "<cmd>FzfLua lsp_references<cr>", desc = "Find reference" },
    { "<leader>fls", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Find symbol(document)" },
    { "<leader>flS", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Find symbol(workspace)" },
    { "<leader>flt", "<cmd>FzfLua lsp_typedefs<cr>", desc = "Find type definition" },
    { "<leader>flw", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "Search symbol(dynamic)" },
    --
    { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "Find mark" },
    { "<leader>fM", "<cmd>FzfLua man_pages<cr>", desc = "Find manpage" },
    { "<leader>fq", "<cmd>FzfLua quickfix<cr>", desc = "Find error" },
    { "<leader>fQ", "<cmd>FzfLua loclist<cr>", desc = "Find error(loc)" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Open(recent)" },
    { "<leader>fs", "<cmd>FzfLua spell_suggest<cr>", desc = "Spell suggest" },
    { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Search(grep) current word" },

    -- For Intra-File Navigation: Yes, Tree-sitter can replace tags within a single file.
    -- Its real-time parsing is very useful for jumping to definitions, functions, or classes within a file.
    { "<leader>ft", "<cmd>FzfLua treesitter<cr>", desc = "Find treesitter" },
    -- Cross-file navigation: Use tags or a language server for fast, project-wide symbol indexing and jumping to definitions
    { "<leader>fT", "<cmd>FzfLua tags<cr>", desc = "Find tag" },
    { "<leader>fz", "<cmd>FzfLua zoxide<cr>", desc = "Find recent directory" }, -- zoxide

    -- TODO: DAP support
    {
      "<C-x><C-f>",
      function()
        require("fzf-lua").complete_path()
      end,
      mode = { "n", "v", "i" },
      desc = "Complete path",
    },
    {
      "<C-x><C-l>",
      function()
        require("fzf-lua").complete_line()
      end,
      mode = { "n", "v", "i" },
      desc = "Complete line",
    },
  },
}