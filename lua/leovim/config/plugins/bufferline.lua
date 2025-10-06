return {
  keys = {
    --   -- different from next buffer ]b when mode = "tabs",
    --   -- use gt/gT to switch tabs
    { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next bufferline" },
    { "<leader>bp", "<Cmd>BufferLineCyclePrev<CR>", desc = "Nrevious bufferline" },
    { "<leader>bb", "<cmd>BufferLinePick<cr>", desc = "Jump buffer" },
    { "<leader>bd", "<cmd>BufferLinePickClose<cr>", desc = "Close buffer" },
    {
      "<leader>bD",
      function()
        local bufferline = require("bufferline")
        for _, e in ipairs(bufferline.get_elements().elements) do
          vim.schedule(function()
            vim.cmd("bd " .. e.id)
          end)
        end
      end,
      desc = "Close buffer",
    },
    {
      "<leader>bo",
      function()
        local bufferline = require("bufferline")
        bufferline.close_others()
      end,
      desc = "Close buffer",
    },
    { "<leader>bs", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by directory" },
    { "<leader>bS", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by language" },
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Pin buffer" },
  },
  opts = {
    options = {
      mode = "buffers", -- set to "tabs" to only show tabpages instead
      -- style_preset = bufferline.style_preset.minimal, -- or bufferline.style_preset.default,
      themable = true, -- allows highlight groups to be overridden i.e. sets highlights as default
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(_, _, diagnostics_dict, _)
        local s = " "
        for e, n in pairs(diagnostics_dict) do
          local sym = e == "error" and " " or (e == "warning" and " " or " ")
          s = s .. n .. sym
        end
        return s
      end,

      show_buffer_close_icons = false,
      show_close_icon = false,
      show_tab_indicators = true,
      separator_style = "thin", --"slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
      sort_by = "id",

      hover = { enabled = false },
      always_show_bufferline = true, -- cause vim.o.showtabline = 2
      offsets = {
        -- {
        --   filetype = "NvimTree", -- or "neo-tree" dependent on which file explorer is used
        --   text = "Explorer",
        --   highlight = "Directory",
        --   text_align = "left",
        --   -- separator = true,
        --   -- padding = 5,
        -- },
        {
          filetype = "neo-tree",
          text = "Explorer",
          highlight = "Directory",
          text_align = "left",
          -- separator = true,
        },
        -- {
        --   filetype = "undotree",
        --   text = "Undotree",
        --   highlight = "PanelHeading",
        -- },
        {
          filetype = "DiffviewFiles",
          text = "Diff View",
          highlight = "PanelHeading",
        },
        {
          filetype = "lazy",
          text = "Lazy",
          highlight = "PanelHeading",
        },
      },
    },

    -- when colors_name changed, theme should change too.
    highlights = (vim.g.colors_name or ""):find("catppuccin")
        and require("catppuccin.groups.integrations.bufferline").get()
      or {
        buffer_selected = {
          bold = true,
          italic = true,
        },
      },
  },
}
