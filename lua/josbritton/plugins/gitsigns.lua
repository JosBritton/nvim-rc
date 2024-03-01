return {
    -- adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    -- event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add          = { text = "+" },
            change       = { text = "~" },
            delete       = { text = "-" },
            topdelete    = { text = "‾" },
            changedelete = { text = "~" },
            untracked    = { text = "┆" },
        },
        on_attach = function(bufnr)
            vim.keymap.set("n", "<leader>hs", require("gitsigns").stage_hunk,
                { buffer = bufnr, desc = "Stage git hunk" })
            vim.keymap.set("v", "<leader>hs", function()
                require("gitsigns").stage_hunk
                { vim.fn.line("."), vim.fn.line("v") }
            end, { buffer = bufnr, desc = "Stage git hunk" })

            vim.keymap.set("n", "<leader>hr", require("gitsigns").reset_hunk,
                { buffer = bufnr, desc = "Reset git hunk" })
            vim.keymap.set("v", "<leader>hr", function()
                require("gitsigns").reset_hunk
                { vim.fn.line("."), vim.fn.line("v") }
            end, { buffer = bufnr, desc = "Reset git hunk" })

            vim.keymap.set({ "n", "v" }, '<leader>hS', require("gitsigns").stage_buffer,
                { buffer = bufnr, desc = "Stage git buffer" })
            vim.keymap.set({ "n", "v" }, '<leader>hu', require("gitsigns").undo_stage_hunk,
                { buffer = bufnr, desc = "Undo stage git hunk" })
            vim.keymap.set({ "n", "v" }, '<leader>hR', require("gitsigns").reset_buffer,
                { buffer = bufnr, desc = "Reset git buffer" })
            vim.keymap.set({ "n", "v" }, '<leader>hp', require("gitsigns").preview_hunk,
                { buffer = bufnr, desc = "Preview git hunk" })
            vim.keymap.set({ "n", "v" }, '<leader>tb', require("gitsigns").toggle_current_line_blame,
                { buffer = bufnr, desc = "Toggle current git blame line" })
            vim.keymap.set({ "n", "v" }, '<leader>td', require("gitsigns").toggle_deleted,
                { buffer = bufnr, desc = "Git toggle deleted" })
            vim.keymap.set({ "o", "x", "v" }, "ih", require("gitsigns").select_hunk,
                { buffer = bufnr, desc = "Select git hunk from text object" })

            -- don't override the built-in and fugitive keymaps
            local gs = package.loaded.gitsigns
            vim.keymap.set({ "n", "v" }, "]c", function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
            vim.keymap.set({ "n", "v" }, "[c", function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
        end,
    },
}
