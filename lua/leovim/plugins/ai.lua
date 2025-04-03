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
    opts = require("leovim.builtin.copilot").opts or {},
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
    cmd = { "Codeium" },
    init = require("leovim.builtin.codeium").init,
    opts = require("leovim.builtin.codeium").opts or {},
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
    build = "make tiktoken", -- Only on MacOS or Linux
    dependencies = {
      -- "github/copilot.vim", -- or
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim", -- for curl, log and async functions
    },
    cmd = {
      "CopilotChat",
      "CopilotChatPrompts",
      "CopilotChatModels",
      "CopilotChatAgents",
    },
    keys = require("leovim.builtin.copilotchat").keys or {},
    opts = require("leovim.builtin.copilotchat").opts or {},
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
      --- optional dependencies,
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        -- cond = vim.tbl_contains({ "claude", "openai", "azure", "gemini", "cohere", "copilot" }, vim.g.ai_provider)
        -- and vim.g.ai_ui == "avante",
        opts = require("leovim.builtin.img-clip").opts or {},
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        -- cond = vim.tbl_contains({ "claude", "openai", "azure", "gemini", "cohere", "copilot" }, vim.g.ai_provider)
        --   and vim.g.ai_ui == "avante",
        ft = { "markdown", "Avante" },
        opts = require("leovim.builtin.render-markdown").opts or {},
      },
    },
    opts = require("leovim.builtin.avante").opts or {},
    init = require("leovim.builtin.avante").init,
  },
}