require("lazy").setup({
  -- Git related plugins
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",
  { import = "plugins" },
}, {
  install = {
    colorscheme = { "onedark" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = true,
  },
})

-- vim: ts=2 sts=2 sw=2 et
