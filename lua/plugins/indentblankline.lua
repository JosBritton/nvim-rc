return {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
        require("ibl").setup {
            indent = { char = "│" },
            -- scope highlighting from treesitter
            scope = {
                highlight = { "LineNrAbove" },
            },
        }
    end,
}
