return {
  -- nvim-navic, A simple statusline/winbar component that uses LSP to show your current code context.
  -- usage: call the functions:
  --  is_available(bufnr)
  --  get_location(opts, bufnr)
  "SmiteshP/nvim-navic",
  init = function()
    vim.g.navic_silence = true
    vim.opt.showtabline = 2
  end,
  opts = {
    lsp = {
      auto_attach = true,
    },
    -- highlight = false,
    depth_limit = 5,
    -- lazy_update_context = true,
    icons = require("leovim.config.defaults").icons.kinds,
  },
}