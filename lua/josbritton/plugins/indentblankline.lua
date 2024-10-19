return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile", "FileReadPre" },
    config = function()
        require("ibl").setup({
            indent = { char = "│" },
            -- scope highlighting from treesitter
            scope = {
                highlight = { "LineNrAbove" },
            },
        })
    end,
}
