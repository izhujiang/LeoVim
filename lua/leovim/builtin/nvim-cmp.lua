-- local has_words_before = function()
--   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end
--
local M = {
  opts = function()
    local cmp = require("cmp")
    local defaults = require("cmp.config.default")()
    local luasnip = require("luasnip")
    local auto_select = true

    local opts = {
      default = {
        auto_brackets = {}, -- configure any filetype to auto add brackets
        completion = {
          keyword_length = 2,
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

          -- try acting as vscode
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items..
              cmp.confirm({ select = true })
            -- or select next_item
            -- cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            -- or select prev_item
            -- elseif cmp.visible() then
            --   cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          ["<C-S-k>"] = cmp.mapping(function()
            if cmp.visible_docs() then
              cmp.close_docs()
            else
              cmp.open_docs()
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
            local icons_kinds = require("leovim.builtin.icons").kinds
            local auto_cmp_menus = {
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
              codeium = "[Codeium]",
              copilot = "[Copilot]",
            }
            if icons_kinds[item.kind] then
              -- item.kind = string.format("%s%s", icons_kinds[item.kind], item.kind)
              item.kind = icons_kinds[item.kind]
            end
            -- if entry.source.name == "nvim_lsp" and item.kind == "Function" then
            --   item.abbr = item.abbr .. "()"
            -- end
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
          { name = "nvim_lsp", group_index = 1, priority = 900, keyword_length = 1 },
          { name = "luasnip", group_index = 1, priority_ = 500 },
          -- { name = "copilot", group_index = 1, priority = 800 },
          -- { name = "codeium", group_index = 1, priority = 700 },
          { name = "nvim_lua", group_index = 1 },

          { name = "buffer", group_index = 2 },
          { name = "path", group_index = 2 },

          { name = "nvim_lsp_signature_help", group_index = 3 },

          { name = "git", group_index = 4 },
        },

        confirm_opts = {
          behavior = "replace", -- cmp.ConfirmBehavior.Replace,
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
      },

      filetype = {
        gitcommit = {
          sources = cmp.config.sources({
            { name = "git" },
          }, {
            { name = "buffer" },
          }),
        },
      },
      cmdline = {
        [":"] = {
          completion = {
            keyword_length = 2,
            completeopt = "menuone",
          },
          preselect = cmp.PreselectMode.Item,
          mapping = cmp.mapping.preset.cmdline({
            ["<CR>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.confirm({ select = true })
                -- execute the command
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", true)
              else
                fallback()
              end
            end, { "c" }),
          }),

          sources = cmp.config.sources({
            { name = "path" },
            {
              name = "cmdline",
              option = {
                ignore_cmds = { "Man", "!" },
              },
            },
          }),
        },
        ["/"] = {
          completion = {
            keyword_length = 2,
            completeopt = "menuone,noselect",
          },
          preselect = cmp.PreselectMode.Item,
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = "buffer" },
          },
        },
      },
    }

    if vim.g.ai_provider == "codeium" then
      table.insert(opts.default.sources, 1, {
        name = "codeium",
        group_index = 1,
        priority = 800,
      })
    elseif vim.g.ai_provider == "copilot" then
      table.insert(opts.default.sources, 1, {
        name = "copilot",
        group_index = 1,
        priority = 800,
      })
    end

    return opts
  end,
}

return M