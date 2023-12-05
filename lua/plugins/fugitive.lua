return {
    "tpope/vim-fugitive",
    init = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "[G]it [S]tatus" })
    end,
}
