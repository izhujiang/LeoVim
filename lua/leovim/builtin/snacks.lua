return {
  keys = {
    -- bufdelete
    {
      "<leader>c",
      function()
        require("snacks").bufdelete.delete()
      end,
      desc = "Unload",
    },
    {
      "<leader>C",
      function()
        require("snacks").bufdelete.all()
      end,
      desc = "Unload all",
    },
    {
      "<leader>O",
      function()
        require("snacks").bufdelete.other()
      end,
      desc = "Unload others",
    },
    -- dashboard
    {
      "<leader>zd",
      function()
        require("snacks").dashboard.open()
      end,
      desc = "Dashboard",
    },
    {
      "<leader>e",
      function()
        require("snacks").picker.files()
      end,
      desc = "Open(cwd)",
    },
    {
      "<C-p>",
      function()
        require("snacks").picker.files({ cwd = require("leovim.utils").get_root() })
      end,
      desc = "Open(root)",
    },
    {
      "<leader>F",
      function()
        require("snacks").picker.smart()
      end,
      desc = "Open(smart find)",
    },
    {
      "<leader>pr",
      function()
        require("snacks").picker.recent()
      end,
      desc = "Open(recent)",
    },
    {
      "<leader>:",
      function()
        require("snacks").picker.command_history()
      end,
      desc = "Command history",
    },
    {
      "gb",
      function()
        require("snacks").picker.buffers()
      end,
      desc = "Jumpto buffer",
    },
    {
      "<leader>pc",
      function()
        require("snacks").picker.commands()
      end,
      desc = "Command",
    },
    {
      "<leader>pC",
      function()
        require("snacks").picker.colorschemes()
      end,
      desc = "Select colorscheme",
    },
    {
      "<leader>pd",
      function()
        require("snacks").picker.diagnostics_buffer()
      end,
      desc = "Jumpto diagnostic(buffer)",
    },
    {
      "<leader>pD",
      function()
        require("snacks").picker.diagnostics()
      end,
      desc = "Jumpto diagnostic",
    },
    {
      "gl",
      function()
        require("snacks").picker.lines()
      end,
      desc = "Jumpto line",
    },
    {
      "<leader>pn",
      function()
        require("snacks").picker.notifications()
      end,
      desc = "Notification",
    },
    {
      "<leader>pp",
      function()
        require("snacks").picker.projects()
      end,
      desc = "Select project",
    },
    {
      "<leader>gf",
      function()
        require("snacks").picker.git_files()
      end,
      desc = "Open(git_files)",
    },
    -- lazygit, replace "kdheepak/lazygit.nvim"
    {
      "<leader>gg",
      function()
        require("snacks").lazygit()
      end,
      desc = "LazyGit",
    },
    {
      "]]",
      function()
        require("snacks").words.jump(1, true)
      end,
      desc = "Next reference",
    },
    {
      "[[",
      function()
        require("snacks").words.jump(-1, true)
      end,
      desc = "Previous reference",
    },
    -- scratch
    {
      "<leader>S",
      function()
        require("snacks").scratch()
      end,
      desc = "Scratch",
    },
    {
      "<leader>ps",
      function()
        require("snacks").scratch.select()
      end,
      desc = "Select scratch",
    },
    {
      "<leader>zp",
      function()
        -- Start/Stop Profiler
        local profiler = require("snacks").profiler
        if not profiler.running() then
          profiler.start()
          vim.notify("start running profiler", vim.log.levels.INFO)
        else
          vim.notify("profiler stopped", vim.log.levels.INFO)
          vim.defer_fn(profiler.stop, 1000)
        end
        -- local profiler = snacks.toggle.profiler()
        -- profiler.opts.name = "Profiler"
        -- profiler:map("<leader>zp")
      end,
      desc = "Start/Stop profiler",
    },
    {
      "<leader>zn",
      function()
        require("snacks").win({
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
  opts = function()
    local icons = require("leovim.builtin.icons")
    return {
      -- bigfile, adds a new filetype bigfile to Neovim, automatically prevents things like LSP(linter, formatter) and Treesitter attaching to the buffer.
      bigfile = {
        enabled = true,
        line_length = 2048, -- average line length (useful for minified files)
      },
      -- dashboard
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            {
              icon = icons.dashboard.Project,
              key = "p",
              desc = "Find Project",
              action = ":lua Snacks.picker.projects()",
            },
            {
              icon = icons.dashboard.FindFile,
              key = "f",
              desc = "Find File",
              action = ":lua Snacks.dashboard.pick('files')",
            },
            {
              icon = icons.dashboard.NewFile,
              key = "n",
              desc = "New File",
              action = ":ene | startinsert",
            },
            {
              icon = icons.da,
              key = "g",
              desc = "Find Text",
              action = ":lua Snacks.dashboard.pick('live_grep')",
            },
            {
              icon = icons.dashboard.RecentFiles,
              key = "r",
              desc = "Recent Files",
              action = ":lua Snacks.dashboard.pick('oldfiles')",
            },
            {
              icon = icons.dashboard.RestoreSession,
              key = "s",
              desc = "Restore Session",
              action = ":SessionSelect",
            },
            {
              icon = icons.dashboard.Settings,
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            {
              icon = icons.dashboard.Lazy,
              key = "z",
              desc = "Lazy",
              action = ":Lazy",
              enabled = package.loaded.lazy ~= nil,
            },
            {
              icon = icons.dashboard.Exit,
              key = "q",
              desc = "Quit",
              action = ":qa",
            },
          },
          header = [[
█╗     ███████    ████═╗  ██╗   ██╗██╗███╗   ███╗
█║     ██╚══╗    ██  ██║  ██║   ██║██║████╗ ████║
█║     ██████╗  ██╚╗  ██╗ ██║   ██║██║██╔████╔██║
█║     ██╚═══╝   ██╚═██╔╝ ╚██╗ ██╔╝██║██║╚██╔╝██║
██████╗███████╗  ╚████╔╝   ╚████╔╝ ██║██║ ╚═╝ ██║
══════╝╚══════╝   ╚═══╝     ╚═══╝  ╚═╝╚═╝     ╚═╝

m.zhujiang@gmail.com
Powered by lazy.nvim
]],
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          {
            pane = 2,
            icon = icons.git.Github,
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function()
              require("snacks").gitbrowse()
            end,
          },
          function()
            local in_git = require("snacks").git.get_root() ~= nil
            local cmds = {
              {
                title = "Notifications",
                cmd = "gh notify -s -a -n5",
                action = function()
                  vim.ui.open("https://github.com/notifications")
                end,
                key = "N",
                icon = icons.git.Notice,
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
                icon = icons.git.Issues,
                height = 7,
              },
              {
                icon = icons.git.PR,
                title = "Open PRs",
                cmd = "gh pr list -L 3",
                key = "P",
                action = function()
                  vim.fn.jobstart("gh pr list --web", { detach = true })
                end,
                height = 7,
              },
              {
                icon = icons.git.Status,
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
    }
  end,

  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        local snacks = require("snacks")
        -- Setup some globals for debugging (lazy-loaded)
        -- _G.dd = function(...)
        --   Snacks.debug.inspect(...)
        -- end
        -- _G.bt = function()
        --   Snacks.debug.backtrace()
        -- end
        -- vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Snacks.input and notifier is friendly to everforest colorscheme
        -- Pretty vim.notify
        -- vim.ui.input = Snacks.input
        -- vim.notify = Snacks.notifier

        snacks.toggle.option("background", { off = "light", on = "dark", name = "Background(dark)" }):map("<leader>ob")
        snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceallevel" })
          :map("<leader>oc")
        snacks.toggle.diagnostics({ name = "Diagnostic" }):map("<leader>od")
        local dim = snacks.toggle.dim()
        dim.opts.name = "Dim"
        dim:map("<leader>oD", { desc = "dim" })
        snacks.toggle.inlay_hints({ name = "Inlay_hint" }):map("<leader>oi")
        local indent = snacks.toggle.indent()
        indent.opts.name = "Indent"
        indent:map("<leader>oI")
        snacks.toggle.option("spell", { name = "Spell", scope = "bo" }):map("<leader>os")
        local scroll = snacks.toggle.scroll()
        scroll.opts.name = "Scroll"
        scroll:map("<leader>oS")
        snacks.toggle.option("paste", { name = "Paste" }):map("<leader>op")
        snacks.toggle.treesitter({ name = "Treesitter", scope = "bo" }):map("<leader>ot")
        snacks.toggle.option("wrap", { name = "Wrap", scope = "bo" }):map("<leader>ow")
        snacks.toggle.line_number({ name = "Line_number", scope = "wo" }):map("<leader>on")

        -- zoom/maximize window
        local zoom = snacks.toggle.zoom()
        zoom.opts.name = "Zoom Mode"
        zoom:map("<A-w>")
        local zen = snacks.toggle.zen()
        zen.opts.name = "Zen Mode"
        zen:map("<A-z>")
      end,
    })
  end,
}