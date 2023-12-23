return {
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
    init = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "[G]it [S]tatus" })
        vim.keymap.set("n", "<leader>gb", vim.cmd.GBrowse, { desc = "[G]it [B]rowse" })
    end,
}
