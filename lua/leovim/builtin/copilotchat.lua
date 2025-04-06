-- "CopilotC-Nvim/CopilotChat.nvim",
return {
  keys = {
    -- window management
    {
      "<leader>aa",
      function()
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle CopilotChat",
      mode = { "n", "v" },
    },
    {
      "<leader>ac",
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
  opts = {
    -- See Configuration section for options
  },
}