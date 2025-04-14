return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local gitsigns = require("gitsigns")

        local function on_attach(bufnr)
            ---@param mode string|string[]
            ---@param l string
            ---@param r string|function
            ---@param opts? vim.keymap.set.Opts
            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage git hunk" })

            map("v", "<leader>hs", function()
                -- partial-hunk selections only support line-by-line ranges
                gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "Stage git hunk" })

            map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset git hunk" })
            map("v", "<leader>hr", function()
                -- partial-hunk selections only support line-by-line ranges
                gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "Reset git hunk" })

            map(
                { "n", "v" },
                "<leader>hS",
                gitsigns.stage_buffer,
                { desc = "Stage git buffer" }
            )

            map(
                { "n", "v" },
                "<leader>hR",
                gitsigns.reset_buffer,
                { desc = "Reset git buffer" }
            )

            map(
                { "n", "v" },
                "<leader>hp",
                gitsigns.preview_hunk,
                { desc = "Preview git hunk" }
            )

            map(
                { "n", "v" },
                "<leader>tb",
                gitsigns.toggle_current_line_blame,
                { desc = "Toggle current git blame line" }
            )

            map(
                { "n", "v" },
                "<leader>td",
                gitsigns.preview_hunk_inline,
                { desc = "Preview git hunk inline" }
            )

            map(
                { "o", "x", "v" },
                "ih",
                gitsigns.select_hunk,
                { desc = "Select git hunk from text object" }
            )

            ---@type Gitsigns.NavOpts
            ---@diagnostic disable-next-line: missing-fields
            local nav_opts = {
                wrap = false,
                navigation_message = true,
                preview = false,
                greedy = true,
                target = "unstaged",
            }

            local next_hunk = function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    vim.schedule(function()
                        gitsigns.nav_hunk("next", nav_opts)
                    end)
                end
            end
            map("n", "]c", next_hunk, { desc = "Jump to next hunk" })

            local prev_hunk = function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    vim.schedule(function()
                        gitsigns.nav_hunk("prev", nav_opts)
                    end)
                end
            end
            map("n", "[c", prev_hunk, { desc = "Jump to previous hunk" })

            map("n", "<leader>hb", function()
                gitsigns.blame_line({ full = true })
            end)
        end

        gitsigns.setup({
            max_file_length = 100000,
            signs = {
                add = { text = "+", show_count = false },
                change = { text = "~", show_count = false },
                delete = { text = "-", show_count = false },
                topdelete = { text = "‾", show_count = false },
                changedelete = { text = "~", show_count = false },
                untracked = { text = "┆", show_count = false },
            },
            status_formatter = function(_)
                return ""
            end,
            on_attach = on_attach,
            preview_config = {
                border = "rounded",
            },
            current_line_blame = false,
            update_debounce = 50,
            attach_to_untracked = true,
            word_diff = false,
        })
    end,
}
