return {
  keys = {
    { "<leader>zd", "<cmd>Dashboard<CR>", desc = "Dashboard" },
  },
  opts = function()
    local logo = vim.split(string.rep("\n", 10), "\n")
    vim.list_extend(logo, {
      "█  █╗     ███████    ████═╗  ██╗   ██╗██╗███╗   ███╗          Z",
      "█  █║     ██╚══╗    ██  ██║  ██║   ██║██║████╗ ████║      Z    ",
      "█  █║     ██████╗  ██╚╗  ██╗ ██║   ██║██║██╔████╔██║   z       ",
      "█  █║     ██╚═══╝   ██╚═██╔╝ ╚██╗ ██╔╝██║██║╚██╔╝██║ z         ",
      "█  ██████╗███████╗  ╚████╔╝   ╚████╔╝ ██║██║ ╚═╝ ██║           ",
      "╚════════╝╚══════╝   ╚═══╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           ",
    })

    vim.list_extend(logo, vim.split(string.rep("\n", 2), "\n"))

    local opts = {
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = logo,
        -- stylua: ignore
        center = {
          { action = "FzfLua files", desc = " Open File", icon = " ", key = "o" },
          { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
          { action = "FzfLua oldfiles", desc = " Recent Files", icon = " ", key = "r" },
          { action = "FzfLua live_grep", desc = " Find Text", icon = " ", key = "f" },
          { action = "lua require('persistence').load()", desc = " Restore Session", icon = " ", key = "s" },
          { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "z" },
          { action = "qa", desc = " Quit", icon = " ", key = "q" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return {
            "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
            "m.zhujiang@gmail.com",
            "Powered by lazy.nvim",
          }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- open dashboard after closing lazy
    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end

    return opts
  end,
}
