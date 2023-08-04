return {

  -- snippets engine
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
        or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },

    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").expand_or_jumpable() and "<Plug>luasnip-expand-or-jump" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<tab>",
        function()
          require("luasnip").jump(1)
        end,
        mode = "s",
      },
      {
        "<s-tab>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = { "i", "s" },
      },
    },
  },

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = {
      "InsertEnter",
      "CmdlineEnter",
    },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
      },

    },
    opts = function()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
            and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local defaults = require("cmp.config.default")()

      return {
        -- preselect = cmp.PreselectMode.None,
        completion = {
          keyword_length = 1,
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- mapping = cmp.mapping.preset.insert({
        mapping = {
          -- override vim builtin I_CTRL_N/P,
          -- Find next/previous match for words that start with the keyword in front of the cursor, looking in places specified with the 'complete' option.
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }, { "i", "c" }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }, { "i", "c" }),

          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }, { "i", "c" }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }, { "i", "c" }),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }, { "i", "c" }),
          -- ["<C-y>"] =cmp.mapping.confirm({ select = true }, { "i", "c" }), -- ["<C-y>"] for confirm Tabnine suggestion.
          ["<CR>"] = cmp.mapping.confirm({ select = true }, { "i", "c" }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          -- TODO: setup <Tab> and <S-Tab>
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },

        matching = {
          -- fuzzy_matching not friedly to ultisnips
          disallow_fuzzy_matching = true,
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            local icons_kinds = require("leovim.config").icons.kinds
            if icons_kinds[item.kind] then
              -- item.kind = icons[item.kind] .. item.kind
              item.kind = string.format("%s %s", icons_kinds[item.kind], item.kind)
            else
              local icons_misc = require("leovim.config").icons.misc
              if entry.source.name == "cmp_tabnine" then
                item.kind = string.format("%s %s", icons_misc.Robot, item.kind)
              end
              if entry.source.name == "emoji" then
                item.kind = string.format("%s %s", icons_misc.Smiley, item.kind)
              end
            end
            vim.menu = ({
              nvim_lsp = "[LSP]",
              spell = "[Spellings]",
              zsh = "[Zsh]",
              buffer = "[Buffer]",
              ultisnips = "[Snip]",
              treesitter = "[Treesitter]",
              -- calc = "[Calculator]",
              nvim_lua = "[Lua]",
              path = "[Path]",
              nvim_lsp_signature_help = "[Signature]",
              cmdline = "[Vim Command]",
              cmp_tabnine = "[Tabnine]",
            })[entry.source.name]

            return item
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp",               group_index = 1, priority = 700, keyword_length = 1 },
          { name = "luasnip",                group_index = 1, priority_ = 900 },
          { name = 'cmp_tabnine',            group_index = 1, priority = 500, },
          { name = "buffer",                 group_index = 2 },
          { name = "nvim_lua",               group_index = 2 },
          { name = "nvim_lsp_signature_help" },
          { name = "path" },
          -- { name = "copilot",                group_index = 1 },
          -- 📓 Note 1: The above settings make sure that buffer source is visible in the completion menu only when the nvim_lsp and ultisnips sources are not available.
          -- Similarly, nvim_lsp_signature_help will be visible only when the nvim_lsp, ultisnips, and buffer are not available. The same goes for source path.
          -- 📓 Note 2: Having nvim_lsp and ultisnips in a single bracket will allow them to be mixed in the listing otherwise, all the autocompletion menu’s place is taken over by nvim_lsp.
        }),
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        -- experimental = {
        -- 	ghost_text = {
        -- 		hl_group = "CmpGhostText",
        -- 	},
        -- },
        sorting = defaults.sorting,
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      require("luasnip/loaders/from_vscode").lazy_load()

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" },
        }, {
          { name = "buffer" },
        }),
      })
      -- autocompletion for command line
      cmp.setup.cmdline(":", {
        preselect = cmp.PreselectMode.Item,
        mapping = cmp.mapping.preset.cmdline(),

        -- mapping = cmp.mapping.preset.cmdline({
        --   ["<CR>"] = {
        --     c = cmp.mapping.confirm({ select = true }),
        --   }
        --   -- ["<CR>"] = cmp.mapping(function(fallback)
        --   --   cmp.confirm({ select = true })
        --   --   -- fallback()
        --   -- end, "c")
        -- }),
        -- TODO: add nvim builtin documentation as source
        -- TODO: mapping <CR> as select and execute the command
        sources = cmp.config.sources({
          { name = "cmdline", keyword_length = 1 },
          { name = "path",    keyword_length = 1 },
        }),
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
      })

      -- autocompletion for search (/)
      -- cmp.setup.cmdline('/', {
      -- 	sources = {
      -- 		{ name = 'buffer' },
      -- 	}
      -- })

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    end,
  },

  -- auto pairs, Minimal and fast autopairs
  -- usage: ([{'"
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },

  -- surround
  -- usage:
  -- 	gs{iw/motion}{" ' { [ ( t }
  -- 	cs{s1}{s2}
  -- 	ds{s1}
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add,            desc = "Add surrounding",                     mode = { "n", "v" } },
        { opts.mappings.delete,         desc = "Delete surrounding" },
        { opts.mappings.find,           desc = "Find right surrounding" },
        { opts.mappings.find_left,      desc = "Find left surrounding" },
        { opts.mappings.highlight,      desc = "Highlight surrounding" },
        { opts.mappings.replace,        desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      -- TODO: try to figure out much better keymaps for surrounding
      mappings = {
        add = "gs",               -- Add surrounding in Normal and Visual modes
        delete = "ds",            -- Delete surrounding
        find = "<leader>sf",      -- Find surrounding (to the right)
        find_left = "<leader>sb", -- Find surrounding (to the left)
        highlight = "<leader>sh", -- Highlight surrounding
        replace = "cs",           -- Replace surrounding
        update_n_lines = "gSn",   -- Update `n_lines`
      },
    },
  },

  -- comments, setting the commentstring option based on the cursor location in the file.
  -- usage: gc, gcc
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring()
              or vim.bo.commentstring
        end,
      },
    },
  },

  -- better text-objects
  -- 		enhances some builtin textobjects (like a(, a), a', and more),
  -- 		creates new ones (like a*, a<Space>, af, a?, and more), and allows user to create their own
  {
    "echasnovski/mini.ai",
    -- keys = {
    --   { "a", mode = { "x", "o" } },
    --   { "i", mode = { "x", "o" } },
    -- },
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      if require("leovim.util").has("which-key.nvim") then
        ---@type table<string, string|table>
        local i = {
          [" "] = "Whitespace",
          ['"'] = 'Balanced "',
          ["'"] = "Balanced '",
          ["`"] = "Balanced `",
          ["("] = "Balanced (",
          [")"] = "Balanced ) including white-space",
          [">"] = "Balanced > including white-space",
          ["<lt>"] = "Balanced <",
          ["]"] = "Balanced ] including white-space",
          ["["] = "Balanced [",
          ["}"] = "Balanced } including white-space",
          ["{"] = "Balanced {",
          ["?"] = "User Prompt",
          _ = "Underscore",
          a = "Argument",
          b = "Balanced ), ], }",
          c = "Class",
          f = "Function",
          o = "Block, conditional, loop",
          q = "Quote `, \", '",
          t = "Tag",
        }
        local a = vim.deepcopy(i)
        for k, v in pairs(a) do
          a[k] = string.gsub(tostring(v), " including.*", "")
        end

        local ic = vim.deepcopy(i)
        local ac = vim.deepcopy(a)
        for key, name in pairs({ n = "Next", l = "Last" }) do
          i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
          a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
        end
        require("which-key").register({
          mode = { "o", "x" },
          i = i,
          a = a,
        })
      end
    end,
  },
}
