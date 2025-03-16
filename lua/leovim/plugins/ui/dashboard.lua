return {
  -- dashboard, alpha is a fast and fully programmable greeter
  -- TODO: popup and greeter when start up nvim without oponning any file
  "goolord/alpha-nvim",
  dependencies = { "ibhagwan/fzf-lua" },
  cmd = { "Alpha" },
  keys = { { "<leader>zd", "<cmd>Alpha<cr>", desc = "dashboard" } },
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
            ██╗     ███████    ████═╗  ██╗   ██╗██╗███╗   ███╗          Z
            ██║     ██╚══╗    ██  ██║  ██║   ██║██║████╗ ████║      Z
            ██║     ██████╗  ██╚╗  ██╗ ██║   ██║██║██╔████╔██║   z
            ██║     ██╚═══╝   ██╚═██╔╝ ╚██╗ ██╔╝██║██║╚██╔╝██║ z
            ███████╗███████╗  ╚████╔╝   ╚████╔╝ ██║██║ ╚═╝ ██║
            ╚══════╝╚══════╝   ╚═══╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]
    local icons = require("leovim.config.defaults").icons

    dashboard.section.header.val = vim.split(logo, "\n")
    dashboard.section.buttons.val = {
      dashboard.button("p", string.format("%s%s", icons.dashboard.Project, "Projects"), ":ProjectFzf<CR>"),
      dashboard.button("n", string.format("%s%s", icons.dashboard.NewFile, "New file"), ":ene <BAR> startinsert <CR>"),
      dashboard.button(
        "r",
        string.format("%s%s", icons.dashboard.RecentFiles, "Recent files"),
        ":FzfLua oldfiles <CR>"
      ),
      dashboard.button("f", string.format("%s%s", icons.dashboard.FindFile, "Find file"), ":FzfLua files <CR>"),
      dashboard.button("s", string.format("%s%s", icons.dashboard.FindText, "Find text"), ":FzfLua live_grep <CR>"),
      dashboard.button(
        "S",
        string.format("%s%s", icons.dashboard.RestoreSession, "Restore Session"),
        [[:lua require("persistence").load() <cr>]]
      ),
      dashboard.button("z", string.format("%s%s", icons.dashboard.Lazy, "Lazy"), ":Lazy<CR>"),
      dashboard.button("q", string.format("%s%s", icons.dashboard.Quit, "Quit"), ":qa<CR>"),
    }
    dashboard.section.footer.val = "m.zhujiang@gmail.com\nPowered by lazy.nvim"

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end

    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    dashboard.opts.layout[1].val = 8
    return dashboard
  end,
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LeoVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}