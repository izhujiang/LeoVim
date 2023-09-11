return {

  -- fugitive.vim: A Git wrapper. (fugitive.vim vs lazygit)
  --  fugitive.vim: command-line git in vim,
  --  lazygit: a simple terminal UI for git commands running in shell or via terminal
  {
    "tpope/vim-fugitive",
    enabled = false,
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
    },
  },
}