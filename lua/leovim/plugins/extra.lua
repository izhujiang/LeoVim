return {
  {
    -- enhanced increment/decrement plugin for Neovim.
    -- Increment/decrement based on various type of rules
    -- n-ary (2 <= n <= 36) integers
    -- date and time
    -- constants (an ordered set of specific strings, such as a keyword or operator)
    -- true ⇄ false
    -- && ⇄ ||
    -- a ⇄ b ⇄ ... ⇄ z
    -- hex colors
    -- semantic version
    -- TODO: <C-a> <C-x> not working appropriately
    "monaqa/dial.nvim",
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local augend = require("dial.augend")
      return {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%d/%m/%Y"],
          augend.date.alias["%Y-%m-%d"],
          augend.constant.alias.bool,
          augend.constant.alias.Alpha,
        },
        typescript = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.new({ elements = { "let", "const" } }),
        },
        visual = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.alpha,
          augend.constant.alias.Alpha,
        },
      }
    end,
    config = function(_, opts)
      require("dial.config").augends:register_group(opts)

      vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
      vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
      vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual("visual"), { noremap = true })
      vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual("visual"), { noremap = true })

      -- enable only for specific FileType
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("leovim_" .. "typescript", { clear = true }),
        pattern = { "javascript", "typescript" },
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("typescript"), { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "<C-x>", require("dial.map").dec_normal("typescript"), { noremap = true })
        end,
      })
    end,
  },
}