return {
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && yarn install",
        cond = function()
            return vim.fn.executable "yarn" == 1
        end,
    },
}
