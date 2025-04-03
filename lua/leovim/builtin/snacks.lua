return {
  keys = {
    -- bufdelete
    {
      "<leader>x",
      function()
        Snacks.bufdelete.delete()
      end,
      desc = "Unload",
    },
    {
      "<leader>X",
      function()
        Snacks.bufdelete.all()
      end,
      desc = "Unload all",
    },
    {
      "<leader>O",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "Unload others",
    },
    -- dashboard
    {
      "<leader>zd",
      function()
        Snacks.dashboard.open()
      end,
      desc = "Dashboard",
    },
    {
      "<leader>e",
      function()
        Snacks.picker.files()
      end,
      desc = "Open",
    },
    {
      "<leader>E",
      function()
        Snacks.picker.files({ cwd = require("leovim.utils").get_root() })
      end,
      desc = "Open(root)",
    },
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "Open(smart find)",
    },
    {
      "<leader>pr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Open(recent)",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command history",
    },
    {
      "<leader>jb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Jumpto buffer",
    },
    {
      "<leader>pc",
      function()
        Snacks.picker.commands()
      end,
      desc = "Command",
    },
    {
      "<leader>pC",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorscheme",
    },
    {
      "<leader>pd",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Jumpto diagnostic(buffer)",
    },
    {
      "<leader>pD",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Jumpto diagnostic",
    },
    -- TODO: to popup line picker
    {
      "<leader>jl",
      function()
        Snacks.picker.lines()
      end,
      desc = "Jumpto line",
    },
    {
      "<leader>pn",
      function()
        Snacks.picker.notifications()
      end,
      desc = "Notification",
    },
    {
      "<leader>pp",
      function()
        Snacks.picker.projects()
      end,
      desc = "Select project",
    },
    {
      "<leader>gf",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Open(git_files)",
    },
    -- lazygit, replace "kdheepak/lazygit.nvim"
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "LazyGit",
    },
    {
      "<leader>zp",
      function()
        Snacks.profiler.pick()
      end,
      desc = "Profiler",
    },
    {
      "]]",
      function()
        Snacks.words.jump(1, true)
      end,
      desc = "Next reference",
    },
    {
      "[[",
      function()
        Snacks.words.jump(-1, true)
      end,
      desc = "Previous reference",
    },
    -- scratch
    {
      "<leader><leader>s",
      function()
        Snacks.scratch()
      end,
      desc = "Scratch",
    },
    {
      "<leader>ps",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select scratch",
    },
    {
      "<leader>zn",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.9,
          height = 0.9,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
      desc = "Neovim News",
    },
  },
  opts = {
    -- bigfile
    bigfile = {
      enabled = true,
    },
    -- dashboard
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "s", desc = "Restore Session", action = ":SessionSelect" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = "󰒲 ", key = "z", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
█╗     ███████    ████═╗  ██╗   ██╗██╗███╗   ███╗
█║     ██╚══╗    ██  ██║  ██║   ██║██║████╗ ████║
█║     ██████╗  ██╚╗  ██╗ ██║   ██║██║██╔████╔██║
█║     ██╚═══╝   ██╚═██╔╝ ╚██╗ ██╔╝██║██║╚██╔╝██║
██████╗███████╗  ╚████╔╝   ╚████╔╝ ██║██║ ╚═╝ ██║
══════╝╚══════╝   ╚═══╝     ╚═══╝  ╚═╝╚═╝     ╚═╝

m.zhujiang@gmail.com
]],
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        {
          pane = 2,
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          key = "b",
          action = function()
            Snacks.gitbrowse()
          end,
        },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
            {
              title = "Notifications",
              cmd = "gh notify -s -a -n5",
              action = function()
                vim.ui.open("https://github.com/notifications")
              end,
              key = "N",
              icon = " ",
              height = 5,
              enabled = true,
            },
            {
              title = "Open Issues",
              cmd = "gh issue list -L 3",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              icon = " ",
              height = 7,
            },
            {
              icon = " ",
              title = "Open PRs",
              cmd = "gh pr list -L 3",
              key = "P",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
              height = 7,
            },
            {
              icon = " ",
              title = "Git Status",
              cmd = "git --no-pager diff --stat -B -M -C",
              height = 10,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        { section = "startup" },
      },
    },
    -- dim
    dim = {
      filter = function(buf)
        return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
      end,
    },
    -- explorer, not good enough to replace nvim-tree
    -- explorer = {
    --   enabled = true,
    --   --   replace_netrw = true, -- Replace netrw with the snacks explorer
    -- },
    -- image = {
    --   enabled = false,
    --   -- Image viewer using the Kitty Graphics Protocol.
    --   -- Terminal support: tmux, kitty, wezterm, ghostty
    --   -- :checkhealth snacks
    -- },

    -- indent, visualize indent guides and scopes based on treesitter or indent.
    indent = {
      indent = {
        char = "╎",
      },
      filter = function(buf)
        return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
      end,
    },
    input = {
      enabled = false,
    },
    -- Snacks.picker → a quick, simple UI to pick an item without fuzzy searching.
    -- fzf-lua → a powerful fuzzy finding for searching files, buffers, and commands.
    picker = {
      --   sources = {
      --     explorer = {
      --       -- your explorer picker configuration comes here or leave it empty to use the default settings
      --     },
      --   },
    },
    lazygit = {
      win = {
        style = "lazygit",
        width = 0.9999,
        height = 0.95,
        border = "rounded",
      },
    },
    -- notify = {
    --   -- Utility functions to work with Neovim's vim.notify, encapsulation of vim.notify
    -- },
    -- notifier = {
    --   -- Pretty vim.notify, not good enough as rcarriga/nvim-notify
    -- enabled = false,
    -- },
    -- profiler = {
    --   enabled = false,
    -- },
    quickfile = {
      -- When doing nvim somefile.txt, it will render the file as quickly as possible, before loading plugins.
      enabled = true,
    },
    -- useless
    -- rename = {
    --   enabled = false,
    -- },
    -- ok for javascript, not bug for golang and c, using nvim-treesitter-textobjects
    -- scope = {
    --   cursor = true, -- when true, the column of the cursor is used to determine the scope
    --   edge = true, -- include the edge of the scope (typically the line above and below with smaller indent)
    --   siblings = false, -- expand single line scopes with single line siblings
    --   treesitter = {
    --     -- detect scope based on treesitter. falls back to indent based detection if not available
    --     enabled = true,
    --     blocks = {
    --       enabled = true, -- enable to use the following blocks
    --     },
    --     -- these treesitter fields will be considered as blocks
    --     field_blocks = {
    --       "local_declaration",
    --     },
    --   },
    --   -- These keymaps will only be set if the `scope` plugin is enabled.
    --   -- Alternatively, you can set them manually in your config,
    --   -- using the `Snacks.scope.textobject` and `Snacks.scope.jump` functions.
    --   keys = {
    --     textobject = {
    --       is = {
    --         min_size = 2, -- minimum size of the scope
    --         edge = false, -- inner scope
    --         cursor = false,
    --         treesitter = { blocks = { enabled = false } },
    --         desc = "inner scope",
    --       },
    --       as = {
    --         cursor = false,
    --         min_size = 2, -- minimum size of the scope
    --         treesitter = { blocks = { enabled = false } },
    --         desc = "full scope",
    --       },
    --       ii = nil,
    --       ai = nil,
    --     },
    --     jump = {
    --       ["[s"] = {
    --         min_size = 1, -- allow single line scopes
    --         bottom = false,
    --         cursor = false,
    --         edge = true,
    --         treesitter = { blocks = { enabled = false } },
    --         desc = "scope",
    --       },
    --       ["]s"] = {
    --         min_size = 1, -- allow single line scopes
    --         bottom = true,
    --         cursor = false,
    --         edge = true,
    --         treesitter = { blocks = { enabled = false } },
    --         desc = "scope",
    --       },
    --       ["[i"] = nil
    --       ["]i"] = nil
    --     },
    --   },
    -- },
    scratch = {
      enabled = true,
    },
    scroll = {
      --  "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb"
      enabled = true,
    },
    toggle = {
      enabled = true,
      wk_desc = {
        -- enabled = "disable ",
        -- disabled = "enable ",
        enabled = "",
        disabled = "",
      },
    },
    statuscolumn = {
      enabled = false,
    },
    words = {
      enabled = true,
    },
  },

  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        local Snacks = require("snacks")
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Snacks.input and notifier is friendly to everforest colorscheme
        -- Pretty vim.notify
        -- vim.ui.input = Snacks.input
        -- vim.notify = Snacks.notifier

        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Background(dark)" }):map("<leader>ob")
        Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceallevel" })
          :map("<leader>oc")
        Snacks.toggle.diagnostics({ name = "Diagnostic" }):map("<leader>od")
        local dim = Snacks.toggle.dim()
        dim.opts.name = "Dim"
        dim:map("<leader>oD", { desc = "dim" })
        Snacks.toggle.inlay_hints({ name = "Inlay_hint" }):map("<leader>oi")
        local indent = Snacks.toggle.indent()
        indent.opts.name = "Indent"
        indent:map("<leader>oI")
        Snacks.toggle.option("spell", { name = "Spell", scope = "bo" }):map("<leader>os")
        local scroll = Snacks.toggle.scroll()
        scroll.opts.name = "Scroll"
        scroll:map("<leader>oS")
        Snacks.toggle.option("paste", { name = "Paste" }):map("<leader>op")
        Snacks.toggle.treesitter({ name = "Treesitter", scope = "bo" }):map("<leader>ot")
        Snacks.toggle.option("wrap", { name = "Wrap", scope = "bo" }):map("<leader>ow")
        Snacks.toggle.line_number({ name = "Line_number", scope = "wo" }):map("<leader>on")

        local profiler = Snacks.toggle.profiler()
        profiler.opts.name = "Profiler"
        profiler:map("<leader><leader>p")
        local zoom = Snacks.toggle.zoom()
        zoom.opts.name = "Zoom"
        zoom:map("<leader><leader>Z")
        local zen = Snacks.toggle.zen()
        zen.opts.name = "Zen"
        zen:map("<leader><leader>z")
      end,
    })
  end,
}