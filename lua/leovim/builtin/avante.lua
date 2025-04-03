-- "yetone/avante.nvim",
return {
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

  init = function()
    vim.opt.laststatus = 3
  end,
}