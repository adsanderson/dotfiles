return {
  { "loctvl842/monokai-pro.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    lazy = false,
    priority = 1000,
    opts = {
      colorscheme = "monokai-pro",
    },
  },
}
