return {
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      { "hrsh7th/cmp-buffer" },                                -- source: buffer words
      { "hrsh7th/cmp-path" },                                  -- source: file path
      { "hrsh7th/cmp-nvim-lsp" },                              -- source: neovim builtin LSP client
      { "hrsh7th/cmp-nvim-lua" },                              -- source: neovim's Lua runtime API such vim.lsp.*
      { "hrsh7th/cmp-nvim-lsp-signature-help" },               -- source: function signatures
      { "saadparwaiz1/cmp_luasnip" },                          -- source: luasnip
      { "L3MON4D3/LuaSnip" },                                  -- Snippet Engine for Neovim
      { "hrsh7th/cmp-cmdline" },                               -- source: cmdline
      { "petertriho/cmp-git",                 config = true }, -- source: git
      { "Exafunction/codeium.nvim",           config = true }, -- source: codeium
    },
    opts = function(_, opts)
      -- local has_words_before = function()
      --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      -- end

      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local luasnip = require("luasnip")
      local auto_select = false

      return vim.tbl_deep_extend("keep", {
        auto_brackets = {}, -- configure any filetype to auto add brackets
        completion = {
          keyword_length = 1,
          completeopt = "menuone" .. (auto_select and "" or ",noselect"),
        },
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- preset.insert setup <DOWN>, <UP> <C-n>, <C-p>, <C-y>, and <C-e>
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          -- TODO: try acting as vscode
          ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            elseif cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        matching = {
          -- fuzzy_matching not friedly to ultisnips
          disallow_fuzzy_matching = true,
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            local icons_kinds = require("leovim.config.defaults").icons.kinds
            local auto_cmp_menus = require("leovim.config.defaults").autocompletion.menu
            if icons_kinds[item.kind] then
              item.kind = string.format("%s%s", icons_kinds[item.kind], item.kind)
            end
            item.menu = auto_cmp_menus[entry.source.name]
            return item
          end,
        },

        -- https:
        -- //smarttech101.com/nvim-lsp-autocompletion-mapping-snippets-fuzzy-search/
        -- 📓 Note 1: The above settings make sure that buffer source is visible in the completion menu only when the nvim_lsp and ultisnips sources are not available.
        -- Similarly, nvim_lsp_signature_help will be visible only when the nvim_lsp, ultisnips, and buffer are not available. The same goes for source path.
        -- 📓 Note 2: Having nvim_lsp and ultisnips in a single bracket will allow them to be mixed in the listing otherwise, all the autocompletion menu’s place is taken over by nvim_lsp.
        sources = {
          { name = "nvim_lsp",                group_index = 1, priority = 900, keyword_length = 1 },
          { name = "luasnip",                 group_index = 1, priority_ = 500 },
          -- { name = "copilot", group_index = 1, priority = 800 },
          { name = "codeium",                 group_index = 1, priority = 700 },
          { name = "nvim_lua",                group_index = 1 },

          { name = "buffer",                  group_index = 2 },
          { name = "path",                    group_index = 2 },

          { name = "nvim_lsp_signature_help", group_index = 3 },

          { name = "git",                     group_index = 4 },
        },

        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sorting = defaults.sorting,
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
      }, opts or {})
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" },
        }, {
          { name = "buffer" },
        }),
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    end,
  },

  -- snippets engine
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      { "rafamadriz/friendly-snippets" },
    },
    config = function(opts)
      require("luasnip").setup(opts)
      -- be sure to load this first since it overwrites the snippets table.
      -- local luasnip = require("luasnip")
      -- luasnip.snippets = require("luasnip_snippets").load_snippets()

      -- require("luasnip.loaders.from_lua").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load()
      -- require("luasnip.loaders.from_snipmate").lazy_load()
    end,
  },

  --A super powerful autopair plugin for Neovim that supports multiple
  --characters.
  -- usage:
  --      just type open pair like: {|
  --      fast_wrap open pair and words (|foo bar, <M-e>, <M-e>$ <M-e>q[hH]
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "spectre_panel", "vim" },
      -- disable_in_macro = true,           -- disable when recording or executing a macro
      disable_in_visualblock = true, -- disable when insert after visual block mode
      -- disable_in_replace_mode = true,
      -- ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
      -- enable_moveright = true,
      -- enable_afterquote = true,          -- add bracket pairs after quote
      -- enable_check_bracket_line = true, --- check bracket in same line
      -- enable_bracket_in_quote = true,
      -- enable_abbr = false,               -- trigger abbreviation
      -- break_undo = true,                 -- switch for basic rule break undo sequence
      check_ts = true, -- check treesitter
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },

      -- map_cr = true,
      -- map_bs = true,   -- map the <BS> key
      map_c_h = true, -- Map the <C-h> key to delete a pair
      map_c_w = true, -- map <c-w> to delete a pair if possible

      fast_wrap = {
        -- map = "<M-e>",
        -- chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        -- end_key = "$",
        before_key = "h",
        after_key = "l",
        cursor_pos_before = false,
        -- keys = "qwertyuiopzxcvbnmasdfghjkl",
        -- check_comma = true,
        -- highlight = "Search",
        -- highlight_grey = "Comment",
      },
    },
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)

      -- insert `(` after select function or method item when accepting completion pressing <C-y>
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Nvim-Surround (Manipulating SurrOundings)
  -- usage:
  -- 	y[sS]{motion}{char} or yss[SS]{char}, char: " ' { [ ( t }  Examples: ys$"
  -- 	cs{s1}{s2}
  -- 	ds{s1}
  -- 	Use a single character as an alias for several text-object,
  -- 	  q for nearest quote(', ", or `),
  -- 	  t for tag,
  -- 	  b for bracket,
  -- 	  f for function
  {
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    -- opts = {
    -- keymaps = {
    --   insert = "<C-g>s",
    --   insert_line = "<C-g>s",
    --   normal = "ys",
    --   normal_cur = "yss",
    --   normal_line = "yS",
    --   normal_cur_line = "ySS",
    --   visual = "S",
    --   visual_line = "gS",
    --   delete = "ds",
    --   change = "cs",
    -- },
    -- },
    config = true,
  },
}
