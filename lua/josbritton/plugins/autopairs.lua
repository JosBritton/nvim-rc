return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
        -- assume these effect performance
        enable_check_bracket_line = true, -- don't add paris when pair is imbalanced on line
        ignored_next_char = "[%w%.]", -- ignore alphanumeric and `.` symbol

        -- important for generic rules like opening curly brackets
        map_cr = true,

        -- try to delete pairs
        map_c_w = true, -- map <C-w> to delete a pair if possible
        map_c_h = false, -- conflicts with ctrl-backspace map!!
    },
}
