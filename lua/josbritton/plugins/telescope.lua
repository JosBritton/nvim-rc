return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        -- note: will use LSP features
        "nvim-treesitter/nvim-treesitter", -- required for preview/finding
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        -- build and make available C port of fzf for telescope
        -- (does not require fzf to be installed on the system)
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
                    and (vim.fn.executable("gcc") == 1 or vim.fn.executable("clang") == 1)
            end,
        },
    },
    keys = {
        -- {
        --     "<leader>?",
        --     "<cmd>Telescope oldfiles<CR>",
        --     desc = "[?] Find recently opened files",
        -- },
        {
            "<C-k>",
            "<cmd>Telescope buffers theme=dropdown<CR>",
            desc = "[ ] Find existing buffers",
        },
        {
            "<leader>/",
            function()
                -- you can pass additional configuration to telescope to change theme, layout, etc.
                require("telescope.builtin").current_buffer_fuzzy_find(
                    require("telescope.themes").get_dropdown({
                        winblend = 10,
                        previewer = false,
                    })
                )
            end,
            desc = "[/] Fuzzily search in current buffer",
        },
        {
            "<C-p>",
            "<cmd>Telescope find_files hidden=true<CR>",
            desc = "Search [P]roject by filename",
        },
        {
            "<leader>ps",
            "<cmd>Telescope live_grep<CR>",
            desc = "Search [P]roject by Grep [S]tring",
        },
        -- {
        --     "<leader>sd",
        --     "<cmd>Telescope diagnostics<CR>",
        --     desc = "[S]earch [D]iagnostics",
        -- },
        -- { "<leader>sh", "<cmd>Telescope help_tags<CR>", desc = "[S]earch [H]elp" },
    },
    cmd = {
        "Telescope",
    },
    config = function()
        local actions = require("telescope.actions")
        require("telescope").setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-u>"] = false, -- half-screen movement (up)
                        ["<C-d>"] = false, -- half-screen movement (down)
                        ["<esc>"] = actions.close, -- map ESC to quit in insert mode
                    },
                },
            },
            pickers = {
                find_files = {
                    -- default picker ignores fd ignore file
                    find_command = { "fd", "--type", "f" },
                    push_tagstack_on_edit = true,
                },
                buffers = {
                    mappings = {
                        i = {
                            -- close(delete) open buffer under cursor without closing telescope
                            ["<leader>cc"] = actions.delete_buffer + actions.move_to_top,
                        },
                    },
                    previewer = false,
                    ignore_current_buffer = true,
                },
            },
        })

        -- required to build fzf-native
        assert(
            vim.fn.executable("gcc") == 1 or vim.fn.executable("clang") == 1,
            "`gcc` OR `clang` not installed or available."
        )

        ---@type string[]
        local required_bins = {
            "rg", -- required for live-grepping
            "fd", -- required for finding
            "make", -- required to build fzf-native
        }
        for _i, e in ipairs(required_bins) do
            assert(
                vim.fn.executable(e) == 1,
                ("`%s` not installed or available."):format(e)
            )
        end

        -- fzf *native*
        require("telescope").load_extension("fzf")
    end,
}
