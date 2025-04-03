return {
  opts = {
    lsp = {
      auto_attach = true,
    },
    -- highlight = false,
    depth_limit = 5,
    -- lazy_update_context = true,
    icons = require("leovim.config.defaults").icons.kinds,
  },
  init = function()
    vim.g.navic_silence = true
    vim.opt.showtabline = 2
  end,
}