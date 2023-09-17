return {

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },                -- source: nvim-lsp
      { "hrsh7th/cmp-buffer" },                  -- source: buffer
      { "hrsh7th/cmp-path" },                    -- source: path
      { "hrsh7th/cmp-cmdline" },                 -- nvim-cmp source for vim's cmdline
      { "saadparwaiz1/cmp_luasnip" },            -- source: luasnip
      { "hrsh7th/cmp-nvim-lua" },                -- source: complete neovim's Lua runtime API such vim.lsp.*
      { "hrsh7th/cmp-nvim-lsp-signature-help" }, -- source: function signatures
      { "tzachar/cmp-tabnine" },                 -- source: Tabnine
      { "L3MON4D3/LuaSnip" },                    -- Snippet Engine for Neovim
    },
    opts = function()
      local has_words_before = function()
        -- unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local defaults = require("cmp.config.default")()
      local cmp_mapping = require("cmp.config.mapping")
      local cmp_types = require("cmp.types.cmp")
      local ConfirmBehavior = cmp_types.ConfirmBehavior
      local SelectBehavior = cmp_types.SelectBehavior

      return {
        preselect = cmp.PreselectMode.None, -- disable lsp select item automatically, which enable cmp to select the first snip, and other sources as well
        completion = {
          keyword_length = 1,
          completeopt = "menu,menuone,noinsert",
          -- completeopt = "menu,menuone,noinsert,noselect",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp_mapping.preset.insert({
          ["<C-k>"] = cmp_mapping(cmp_mapping.select_prev_item(), { "i", "c" }),
          ["<C-j>"] = cmp_mapping(cmp_mapping.select_next_item(), { "i", "c" }),
          ["<Down>"] = cmp_mapping(cmp_mapping.select_next_item({ behavior = SelectBehavior.Select }), { "i" }),
          ["<Up>"] = cmp_mapping(cmp_mapping.select_prev_item({ behavior = SelectBehavior.Select }), { "i" }),
          ["<C-d>"] = cmp_mapping.scroll_docs(-4),
          ["<C-f>"] = cmp_mapping.scroll_docs(4),
          ["<C-y>"] = cmp_mapping({
            i = cmp_mapping.confirm({ behavior = ConfirmBehavior.Replace, select = false }),
            -- c = function(fallback)
            --   if cmp.visible() then
            --     cmp.confirm({ behavior = ConfirmBehavior.Replace, select = true })
            --   else
            --     fallback()
            --   end
            -- end,
          }),
          ["<Tab>"] = cmp_mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif luasnip.jumpable(1) then
              luasnip.jump(1)
            elseif has_words_before() then
              -- cmp.complete()
              fallback()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp_mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-Space>"] = cmp_mapping.complete(),
          ["<C-e>"] = cmp_mapping.abort(),
          ["<CR>"] = cmp_mapping({
            i = function(fallback)
              if cmp.visible() then
                -- local confirm_opts = { behavior = ConfirmBehavior.Replace, select = false }
                local confirm_opts = { behavior = ConfirmBehavior.Replace, select = true }
                local entry = cmp.get_selected_entry()
                -- local is_copilot = entry and entry.source.name == "copilot"
                -- if is_copilot then
                --   confirm_opts.behavior = ConfirmBehavior.Replace
                --   confirm_opts.select = true
                -- end
                if cmp.confirm(confirm_opts) then
                  return -- success, exit early
                end
              end
              fallback() -- if not exited early, always fallback
            end,
            s = cmp.mapping.confirm({ select = true }),
            -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          }),
        }),

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
            item.menu = ({
              nvim_lsp = "[LSP]",
              spell = "[Spellings]",
              zsh = "[Zsh]",
              buffer = "[Buffer]",
              ultisnips = "[Snip]",
              luasnip = "[Snip]",
              treesitter = "[Treesitter]",
              nvim_lua = "[Lua]",
              path = "[Path]",
              nvim_lsp_signature_help = "[Signature]",
              cmdline = "[Vim Command]",
              cmp_tabnine = "[Tabnine]",
            })[entry.source.name]

            return item
          end,
        },
        sources = cmp.config.sources(
          { -- group 1
            { name = "nvim_lsp",    priority = 900, keyword_length = 1 },
            { name = "luasnip",     priority_ = 700 },
            { name = "cmp_tabnine", priority = 500 },
            { name = "nvim_lua" },
          },
          { -- group 2
            { name = "buffer" },
            { name = "path" },
          },
          {
            { name = "nvim_lsp_signature_help", keyword_length = 2 },
          }

        -- { name = "copilot",                group_index = 1 },
        -- https://smarttech101.com/nvim-lsp-autocompletion-mapping-snippets-fuzzy-search/
        -- 📓 Note 1: The above settings make sure that buffer source is visible in the completion menu only when the nvim_lsp and ultisnips sources are not available.
        -- Similarly, nvim_lsp_signature_help will be visible only when the nvim_lsp, ultisnips, and buffer are not available. The same goes for source path.
        -- 📓 Note 2: Having nvim_lsp and ultisnips in a single bracket will allow them to be mixed in the listing otherwise, all the autocompletion menu’s place is taken over by nvim_lsp.
        ),
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sorting = defaults.sorting,
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      local cmp_mapping = require("cmp.config.mapping")
      local cmp_types = require("cmp.types.cmp")
      local ConfirmBehavior = cmp_types.ConfirmBehavior

      cmp.setup(opts)

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" },
        }, {
          { name = "buffer" },
        }),
      })
      -- autocompletion for command line
      local confirm_completion = function(fallback)
        if cmp.visible() then
          cmp.confirm({ behavior = ConfirmBehavior.Replace, select = true })
        else
          fallback()
        end
      end
      cmp.setup.cmdline(":", {
        preselect = cmp.PreselectMode.None,
        completion = {
          keyword_length = 1,
          -- completeopt = "menu,menuone,noinsert",
          completeopt = "menu,menuone,noinsert,noselect",
        },
        mapping = cmp.mapping.preset.cmdline({
          ["<C-y>"] = cmp_mapping({
            c = confirm_completion,
          }),
        }),

        sources = cmp.config.sources({
          { name = "path",    keyword_length = 1 },
          { name = "cmdline", keyword_length = 1 },
        }),
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
      })

      -- autocompletion for search (/)
      cmp.setup.cmdline("/", {
        preselect = cmp.PreselectMode.None,
        completion = {
          keyword_length = 1,
          -- completeopt = "menu,menuone,noinsert",
          completeopt = "menu,menuone,noinsert,noselect",
        },
        sources = {
          { name = "buffer" },
        },
        mapping = cmp.mapping.preset.cmdline({
          ["<C-y>"] = cmp_mapping({
            c = confirm_completion,
          }),
        }),
      })

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    end,
  },

  -- snippets engine
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
        or nil,
    dependencies = {
      { "rafamadriz/friendly-snippets" },
    },
    config = function()
      require("luasnip.loaders.from_lua").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load()
    end,
  },

  -- TabNine plugin for hrsh7th/nvim-cmp
  {
    "tzachar/cmp-tabnine",
    build = "./install.sh",
    opts = {
      max_lines = 1000,
      max_num_results = 20,
      sort = true,
      run_on_every_keystroke = true,
      snippet_placeholder = "..",
      ignored_file_types = {
        -- default is not to ignore
        -- uncomment to ignore in lua:
        -- lua = true
      },
      show_prediction_strength = false,
    },
    config = function(_, opts)
      local tabnine = require("cmp_tabnine.config")
      tabnine:setup(opts)
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "spectre_panel", "vim" },
      disable_in_macro = true,       -- disable when recording or executing a macro
      disable_in_visualblock = true, -- disable when insert after visual block mode
      disable_in_replace_mode = true,
      ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
      enable_moveright = true,
      enable_afterquote = true,          -- add bracket pairs after quote
      enable_check_bracket_line = false, --- check bracket in same line
      enable_bracket_in_quote = true,
      enable_abbr = false,               -- trigger abbreviation
      break_undo = true,                 -- switch for basic rule break undo sequence
      check_ts = true,                   -- check treesitter
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },

      map_cr = true,
      map_bs = true,   -- map the <BS> key
      map_c_h = true,  -- Map the <C-h> key to delete a pair
      map_c_w = false, -- map <c-w> to delete a pair if possible

      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0, -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    },
    config = function(_, opts)
      local status_ok, autopairs = pcall(require, "nvim-autopairs")
      if not status_ok then
        return
      end
      autopairs.setup(opts)

      pcall(function()
        local function on_confirm_done(...)
          require("nvim-autopairs.completion.cmp").on_confirm_done()(...)
        end
        require("cmp").event:off("confirm_done", on_confirm_done)
        require("cmp").event:on("confirm_done", on_confirm_done)
      end)
    end,
  },

  -- Nvim-Surround (Manipulating SurrOundings)
  -- usage:
  -- 	ys{iw/motion}" ' { [ ( t }  Examples: ys$"
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
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Comments
  -- Smart and powerful comment plugin for neovim
  -- Supports line (//) and block (/* */) comments
  -- Dot (.) repeat support for gcc, gbc
  -- usage:
  --  g{c/b}{c/motion}
  --  gcO/o/A
  {
    "numToStr/Comment.nvim",
    keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
    opts = {
      ---Lines to be ignored while comment/uncomment. a regex string or a function that returns a regex string.
      ignore = "^$",
      ---Pre-hook, called before commenting the line
      pre_hook = function(...)
        local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
        if loaded and ts_comment then
          return ts_comment.create_pre_hook()(...)
        end
      end,
    },
  },
}