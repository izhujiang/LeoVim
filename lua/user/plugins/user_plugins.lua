return {
  {
    "izhujiang/fzf-notify",
    -- dir = "~/workspace/products/fzf-notify",
    dependencies = {
      "ibhagwan/fzf-lua",
      "rcarriga/nvim-notify",
    },
    init = function()
      -- Add plugin to runtimepath to source plugin/fzf-notify.lua
      local plugin_path = vim.fn.stdpath("data") .. "/lazy/fzf-notify"

      -- local plugin_path = "~/workspace/products/fzf-notify"
      vim.opt.runtimepath:append(plugin_path)

      -- If runtimepath is modified after startup, manually source it
      vim.cmd("runtime! plugin/fzf-notify.lua")
    end,
    -- or load plugin when VeryLazy event triggered
    event = "VeryLazy",
    -- cmd = { "FzfNotify" },
    keys = {
      {
        "<leader>fn",
        function()
          require("fzf-notify").notify()
        end,
        desc = "Fuzzy find notifications",
      },
    },
    -- config = function()
    --   require("fzf-notify").setup()
    -- end,
  },
}
