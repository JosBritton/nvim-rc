return {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile", "FileReadPre" },
    config = function()
        require("colorizer").setup()
    end,
}
