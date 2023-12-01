return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- automatically install LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    -- useful status updates for LSP
    { "j-hui/fidget.nvim", opts = {} },
    "folke/neodev.nvim",
  },
}
