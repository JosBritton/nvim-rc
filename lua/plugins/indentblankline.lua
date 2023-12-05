return {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
        local hl = { "CursorColumn", "Whitespace" }
        require("ibl").setup {
            indent = { char = "│" },
            -- scope highlighting from treesitter
            -- whitespace = { remove_blankline_trail = true },
            -- scope = {
            --     enabled = true,
            --     show_start = true,
            --     show_end = true,
            --     injected_languages = false,
            --     highlight = { "Function", "Label" },
            --     priority = 500,
            -- },
        }
    end,
}
