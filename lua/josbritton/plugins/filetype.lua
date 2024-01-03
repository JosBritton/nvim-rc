return {
    "nathom/filetype.nvim",
    lazy = false,
    config = function()
        require("filetype").setup({
            extensions = {
                mdx = "mdx"
            },
        })
    end,
}
