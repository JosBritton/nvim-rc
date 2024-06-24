return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        -- install c port of fzf for telescope only if `make` is available
        -- (does not require real fzf)
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable "make" == 1
            end,
        },
    },
    keys = {
        { "<leader>?",  "<cmd>Telescope oldfiles<CR>",               desc = "[?] Find recently opened files" },
        { "<leader><space>", "<cmd>Telescope buffers<CR>", desc = "[ ] Find existing buffers" },
        {
            "<leader>/",
            function()
                -- you can pass additional configuration to telescope to change theme, layout, etc.
                require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end,
            desc = "[/] Fuzzily search in current buffer"
        },
        { "<C-p>",      "<cmd>Telescope find_files hidden=true<CR>", desc = "Search [P]roject by filename" },
        { "<leader>ps", "<cmd>Telescope live_grep<CR>",              desc = "Search [P]roject by Grep [S]tring" },
        { "<leader>sd", "<cmd>Telescope diagnostics<CR>", desc = "[S]earch [D]iagnostics" },
        { "<leader>sh", "<cmd>Telescope help_tags<CR>",   desc = "[S]earch [H]elp" },
    },
    cmd = {
        "Telescope"
    },
    config = function()
        require("telescope").setup {
            defaults = {
                mappings = {
                    i = {
                        ["<C-u>"] = false,
                        ["<C-d>"] = false,
                    },
                },
            },
            pickers = {
                find_files = {
                    -- default picker ignores fd ignore file
                    find_command = { "fd", "--type", "f"}
                }
            }
        }

        if vim.fn.executable "rg" ~= 1 then
            error("ripgrep not installed")
        end

        if vim.fn.executable "fzf" ~= 1 then
            error("fzf not installed")
        end

        -- enable telescope fzf native, if installed
        pcall(require("telescope").load_extension, "fzf")
    end
}
