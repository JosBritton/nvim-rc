return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "b0o/schemastore.nvim",
        { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        { "j-hui/fidget.nvim",       opts = {} }, -- status UI when loading LSP
        { "folke/neodev.nvim",       opts = {} },
    },
    cmd = { "Mason" },
    event = { "BufReadPost", "BufNewFile", "FileReadPost" },
    config = function()
        vim.defer_fn(function() require("josbritton.lspconfig").setup() end, 0)
    end,
}
