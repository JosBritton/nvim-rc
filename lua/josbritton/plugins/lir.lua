return {
    "tamago324/lir-git-status.nvim",
    dependencies = {
        "JosBritton/lir.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("nvim-web-devicons").set_icon {
            lir_folder_icon = {
                icon = "",
                color = "#7ebae4",
                name = "LirFolderNode"
            },
        }

        local actions = require("lir.actions")
        require("lir").setup {
            show_hidden_files = true,
            ignore = {},
            devicons = {
                enable = true,
                highlight_dirname = false
            },
            mappings = {
                ["<CR>"] = actions.edit,
                ["-"]    = actions.up,

                ["d"]    = actions.mkdir,
                ["%"]    = actions.newfile,
                ["R"]    = actions.rename,
                ["Y"]    = actions.yank_path,
                ["D"]    = actions.delete,
                ["."]    = actions.toggle_show_hidden,
            },
            hide_cursor = true,
        }

        vim.schedule(function()
            vim.keymap.set("n", "<leader>pv", "<cmd>edit %:h<CR>",
                { noremap = true, silent = true, desc = "Open file explorer" })

            require("lir.git_status").setup {
                show_ignored = false,
            }

            vim.cmd.e() -- reload buffer
        end)
    end,
}
