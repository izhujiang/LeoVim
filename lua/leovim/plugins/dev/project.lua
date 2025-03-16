return {
  -- project management
  -- usage:
  --    :AddProject
  --    :ProjectFzf
  --    :ProjectRoot
  "ahmedkhalf/project.nvim",
  event = "VeryLazy", -- project.nvim load project history list asynchronously
  cmd = {
    "ProjectFzf", -- fzf project history list
    "ProjectRoot", -- change root directory manually and update project history list
    "AddProject", -- add current directory into project history list
  },
  keys = {
    { "<leader>fp", "<cmd>ProjectFzf<cr>", desc = "project" },
  },
  opts = {
    -- Manual mode doesn't automatically change your root directory, so you have
    -- the option to manually do so using `:ProjectRoot` command.
    manual_mode = true, -- Prevents auto-changing cwd

    -- Methods of detecting the root directory. **"lsp"** uses the native neovim lsp, while **"pattern"** uses vim-rooter like glob pattern matching.
    -- Here order matters: if one is not detected, the other is used as fallback.
    detection_methods = { "lsp", "pattern" },

    -- All the patterns used to detect root dir, when **"pattern"** is in detection_methods
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "go.mod" },

    -- Don't calculate root dir on specific directories
    exclude_dirs = { "~/.cargo/*" },

    -- Path where project.nvim will store the project history
    -- datapath = vim.fn.stdpath("data"),
  },

  config = function(_, opts)
    require("project_nvim").setup(opts)
    -- require("telescope").load_extension("projects")

    local function project_fzf()
      local projects = require("project_nvim").get_recent_projects()
      if not projects or #projects == 0 then
        vim.notify("No recent projects found", vim.log.levels.WARN)
        return
      end
      require("fzf-lua").fzf_exec(projects, {
        prompt = "Projects> ",
        cwd_prompt = false,
        actions = {
          ["default"] = function(selected_project)
            if vim.opt.autochdir:get() == true then
              require("fzf-lua").files({
                cwd = selected_project[1],
              })
            else
              require("fzf-lua").files({
                cwd = selected_project[1],
                actions = {
                  ["default"] = function(selected_file)
                    -- Trim everything until the first non-blank character (removing icons)
                    -- Remove any non-ASCII characters (like icons) and leading spaces
                    local file_path = selected_file[1]:gsub("^[^%w%s]+%s*", "")
                    vim.cmd("cd " .. selected_project[1]) -- Change cwd when a file is chosen
                    vim.print(file_path)
                    vim.cmd("edit " .. file_path) -- Open the selected file
                  end,
                },
              })
            end
          end,
        },
      })
    end

    vim.api.nvim_create_user_command("ProjectFzf", project_fzf, {})
  end,
}