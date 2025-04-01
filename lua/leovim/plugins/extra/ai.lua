return {
  -- AI plugins comparison:
  --    copilot (github/copilot.vim, zbirenbaum/copilot.lua, CopilotC-Nvim/CopilotChat.nvim)
  --    codeium (Exafunction/codeium.nvim)
  --    charGPT (jackMort/ChatGPT.nvim)
  --    avante (yetone/avante.nvim)
  {
    -- Official GitHub Copilot Vim/Neovim Plugin (code generater)
    -- GitHub Copilot is an AI pair programmer tool that helps you write code faster and smarter.
    -- GitHub Copilot turns "natural language prompts" including comments and method names into "coding suggestions" across dozens of languages.
    "github/copilot.vim",
    -- avante.nvim use copilot.lua as copilot provider instead of copilot.vim
    enabled = false,
    cond = vim.g.ai_provider == "copilot",
    cmd = "Copilot",
    init = function()
      vim.g.copilot_no_maps = true
    end,
    config = function()
      -- Block the normal Copilot suggestions
      vim.api.nvim_create_augroup("github_copilot", { clear = true })
      vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
        group = "github_copilot",
        callback = function(args)
          vim.fn["copilot#On" .. args.event]()
        end,
      })
      vim.fn["copilot#OnFileType"]()
    end,
  },
  {
    -- Fully featured & enhanced replacement for copilot.vim complete with API for interacting with Github Copilot
    -- avante.nvim depends on copilot.lua
    "zbirenbaum/copilot.lua",
    cond = vim.g.ai_provider == "copilot",
    build = ":Copilot auth",
    cmd = "Copilot",
    opts = {
      -- It is recommended to disable copilot.lua's suggestion and panel modules,
      -- as they can interfere with completions properly appearing in blink-cmp-copilot.
      suggestion = {
        enabled = false,
        -- auto_trigger = true,
        auto_trigger = false,
        hide_during_completion = true,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = {
        enabled = false,
        auto_refresh = false,
        -- keymap = {
        --   jump_prev = "[[",
        --   jump_next = "]]",
        --   accept = "<CR>",
        --   refresh = "gr",
        --   open = "<M-CR>"
        -- },
        layout = {
          position = "right", -- | top | left | right | horizontal | vertical
          ratio = 0.4,
        },
      },
      -- filetypes = {
      --   markdown = true,
      -- },
      server_opts_overrides = {
        -- trace = "verbose",
        trace = "off",
        settings = {
          advanced = {
            listCount = 10, -- #completions for panel
            inlineSuggestCount = 3, -- #completions for getCompletions
            debugLogging = false,
          },
          telemetry = false,
        },
      },
    },
  },
  {
    -- Free, ultrafast Copilot alternative for Vim and Neovim
    -- But, no embedded chat ui to interact with codeium
    "Exafunction/codeium.nvim",
    cond = vim.g.ai_provider == "codeium",
    event = { "InsertEnter" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = ":Codeium Auth",
    -- event = { "InsertEnter" },
    -- init = function()
    -- disable the automatic triggering of completions
    -- vim.g.codeium_manual = 1

    -- Codeium's default keybindings can be disabled by setting
    -- vim.g.codeium_disable_bindings = 1

    -- disable default <Tab> binding
    -- vim.g.codeium_no_map_tab = 1

    -- disable codeium for all filetypes
    -- codeium_filetypes_disabled_by_default = 1
    -- vim.g.codeium_filetypes = {
    -- bash = false,
    -- typescript = false,
    -- disable automatic text rendering of suggestions
    -- vim.g.codeium_render = false
    -- }
    -- end,
    cmd = { "Codeium" },
    -- {} struct enable to call defaut config function
    opts = {},
    -- config = function(_, opts)
    -- require("codeium").setup(opts)

    -- It's ok to setup the sources for blink and nvim-cmp here,
    -- but prefer to setup in their own config
    -- if vim.g.completion == "blink" then
    --   vim.print("setup source for blink")
    -- elseif vim.g.completion == "nvim-cmp" then
    --   -- appdend codeium to cmp-sources
    --   local cmp = require("cmp")
    --   local config = cmp.get_config()
    --   table.insert(config.sources, {
    --     name = "codeium",
    --     group_index = 1,
    --     priority = 700,
    --   })
    --   cmp.setup(config)
    -- end
    -- end,
  },

  {
    -- appdend codeium or copilot to cmp-sources
    "hrsh7th/nvim-cmp",
    optional = true,
    cond = vim.g.completion == "nvim-cmp",
    dependencies = {
      {
        -- Ref https://www.lazyvim.org/extras/coding/copilot#copilot-cmp
        -- AI pair programmer
        -- Make sure to run :Lazy load copilot-cmp followed by
        -- :Copilot auth
        -- once the plugin is installed to start the authentication process.
        "zbirenbaum/copilot-cmp",
        cond = vim.g.completion == "nvim-cmp" and vim.g.ai_provider == "copilot",
        dependencies = { "zbirenbaum/copilot.lua" },
        opts = {},
      },
    },
    opts = function(_, opts)
      if vim.g.ai_provider == "codeium" then
        table.insert(opts.sources, 1, {
          name = "codeium",
          group_index = 1,
          priority = 800,
        })
      elseif vim.g.ai_provider == "copilot" then
        table.insert(opts.sources, 1, {
          name = "copilot",
          group_index = 1,
          priority = 800,
        })
      end
      return opts
    end,
  },

  -- for blink, ai.lua should in the extra directory which after dev directory.
  {
    "saghen/blink.cmp",
    cond = vim.g.completion == "blink",
    optional = true,
    dependencies = {
      --   -- Compatibility layer for using nvim-cmp sources on blink.cmp
      {
        "saghen/blink.compat",
        cond = vim.g.ai_provider == "codeium",
      },
      -- {
      -- -- for github/copilot.vim
      --   "fang2hou/blink-copilot",
      --   cond = vim.g.ai_provider == "copilot",
      --   dependencies = {
      --     "github/copilot.vim",
      --   },
      -- },
      {
        -- for zbirenbaum/copilot.lua
        "giuxtaposition/blink-cmp-copilot",
        cond = vim.g.ai_provider == "copilot",
        dependencies = {
          "zbirenbaum/copilot.lua",
        },
      },
      {
        "Kaiser-Yang/blink-cmp-avante",
        cond = vim.fn.has("nvim-0.10")
          and vim.tbl_contains({ "claude", "openai", "azure", "gemini", "cohere", "copilot" }, vim.g.ai_provider)
          and vim.g.ai_ui == "avante",
      },
    },
    opts = function(_, opts)
      -- make sure opts has been set on main part of blink.cmp opts config(run first)
      if vim.g.ai_provider == "codeium" then
        opts = vim.tbl_deep_extend("keep", opts or {}, {
          sources = {
            providers = {
              codeium = {
                name = "codeium",
                module = "blink.compat.source",
                -- score_offset = 100,
                async = true,
                opts = {
                  -- some plugins lazily register their completion source when nvim-cmp is
                  -- loaded, so pretend that we are nvim-cmp, and that nvim-cmp is loaded.
                  -- most plugins don't do this, so this option should rarely be needed
                  -- only has effect when using lazy.nvim plugin manager
                  impersonate_nvim_cmp = true,

                  -- print some debug information. Might be useful for troubleshooting
                  -- debug = false,
                },
              },
            },
            -- default = {},  -- DON'T override default
          },
        })
        vim.list_extend(opts.sources.default, { "codeium" })
      elseif vim.g.ai_provider == "copilot" then
        opts = vim.tbl_deep_extend("keep", opts or {}, {
          sources = {
            -- for zbirenbaum/copilot.lua
            providers = {
              copilot = {
                name = "copilot",
                module = "blink-cmp-copilot",
                -- score_offset = 100,
                async = true,
              },
            },
            -- -- for github/copilot.vim
            -- providers = {
            --   copilot = {
            --     name = "copilot",
            --     module = "blink-copilot",
            --     score_offset = 100,
            --     async = true,
            --   },
            -- },
          },
        })
        vim.list_extend(opts.sources.default, { "copilot" })

        -- only available on avante panel(bo.filetype == "AvanteInput"),
        -- @ trigger the mention(files, quickfix) completion.
        -- / trigger the command completion.
        if vim.g.ai_ui == "avante" then
          opts = vim.tbl_deep_extend("keep", opts or {}, {
            sources = {
              providers = {
                avante = {
                  module = "blink-cmp-avante",
                  name = "Avante",
                  opts = {
                    -- options for blink-cmp-avante
                  },
                },
              },
            },
          })
          vim.list_extend(opts.sources.default, { "avante" })
        end
      end
      return opts
    end,
  },

  {
    -- CopilotChat.nvim brings GitHub Copilot Chat capabilities directly nvim.
    -- integration with official model and agent support (GPT-4o, Claude 3.7 Sonnet, Gemini 2.0 Flash, and more)
    -- interactive chat UI with completion, diffs and quickfix integration
    -- extensible context providers for granular workspace understanding (buffers, files, git diffs, URLs, and more)
    -- efficient token usage with tiktoken token counting and memory management
    -- usage:
    --    :CopilotChat <input>?
    --    :CopilotChatPrompts
    --    :CopilotChatModels
    --    :CopilotChatAgents
    --    :CopilotChat<PromptName>
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = vim.g.ai_provider == "copilot" and vim.g.ai_ui == "copilotchat",
    cmd = {
      "CopilotChat",
      "CopilotChatPrompts",
      "CopilotChatModels",
      "CopilotChatAgents",
    },
    keys = {
      -- window management
      {
        "<leader><leader>a",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle CopilotChat",
        mode = { "n", "v" },
      },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toogle CopilotChat",
        mode = { "n", "v" },
      },
      -- chat session management
      {
        "<leader>aq",
        function()
          vim.ui.input({
            prompt = "Quick Chat: ",
          }, function(input)
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end)
        end,
        desc = "QuickChat",
        mode = { "n", "v" },
      },
      {
        "<leader>as",
        ":CopilotChatStop<cr>",
        desc = "Stop chat",
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Reset chat",
      },
      -- prompt & context management
      {
        "<leader>ap",
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "CopilotChatPrompts",
        mode = { "n", "v" },
      },
      {
        "<leader>am",
        function()
          require("CopilotChat").select_modal()
        end,
        desc = "CopilotChatModels",
        mode = { "n", "v" },
      },
      {
        "<leader>aA",
        function()
          require("CopilotChat").select_agent()
        end,
        desc = "CopilotChatAgents",
        mode = { "n", "v" },
      },
      -- history management
      {
        "<leader>al",
        ":CopilotChatLoad ",
        desc = "Load chat",
      },
      {
        "<leader>aS",
        ":copilotChatSave ",
        desc = "Save chat",
      },
    },
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    config = function(_, opts)
      local chat = require("CopilotChat")

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },
  {
    "yetone/avante.nvim",
    cond = vim.fn.has("nvim-0.10")
      and vim.tbl_contains({ "claude", "openai", "azure", "gemini", "cohere", "copilot" }, vim.g.ai_provider)
      and vim.g.ai_ui == "avante",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"!
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
          completions = {
            lsp = { enabled = true },
            blink = { enabled = true },
          },
        },
        ft = { "markdown", "Avante" },
      },
    },
    init = function()
      vim.opt.laststatus = 3
    end,
    opts = {
      provider = vim.g.ai_provider,
      auto_suggestions_provider = vim.g.ai_provider,

      -- customize ai_provider if necessary
      -- https://github.com/yetone/avante.nvim/blob/main/lua/avante/config.lua
      -- openai = {
      --   endpoint = "https://api.openai.com/v1",
      --   model = "gpt-4o",
      --   timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
      --   temperature = 0,
      --   max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
      --   reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      -- },
      -- copilot = {...},
      -- claude = {...},
      --
      behaviour = {
        auto_suggestions = true, -- Experimental stage
        --   auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        --   support_paste_from_clipboard = false,
        --   minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
        --   enable_token_counting = true, -- Whether to enable token counting. Default to true.

        -- The avante.nvim has always used Aider’s method for planning applying,
        -- but its prompts are very picky with models and require ones like claude-3.5-sonnet or gpt-4o to work properly.
        -- Therefore, enable dopted Cursor’s method to implement planning applying, which should work on most models (llama, groq)
        -- https://github.com/yetone/avante.nvim/blob/main/cursor-planning-mode.md
        -- enable_cursor_planning_mode = false / true, -- Whether to enable Cursor Planning Mode. Default to false.
        --   enable_claude_text_editor_tool_mode = false, -- Whether to enable Claude Text Editor Tool Mode.
      },
      -- mappings = {
      -- },
      -- hints = { enabled = true },
      windows = {
        width = 50,
      },
      file_selector = {
        provider = "fzf",
        provider_opts = {},
      },
    },
  },
}