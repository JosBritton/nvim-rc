return {
    "tpope/vim-rhubarb",
    dependencies = { "tpope/vim-fugitive" },
    lazy = false,
    init = function()
        vim.keymap.set("n", "<leader>gg", vim.cmd.Git, { desc = "[G.]it Status" })
        vim.keymap.set("n", "<leader>gb", vim.cmd.GBrowse, { desc = "[G]it [B]rowse" })
    end,
}
