return {
    "tamago324/lir-git-status.nvim",
    dependencies = {
        "tamago324/lir.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local actions = require("lir.actions")

        require("lir").setup {
            show_hidden_files = true,
            ignore = {}, -- { ".DS_Store", "node_modules" } etc.
            devicons = {
                enable = true,
                highlight_dirname = false
            },
            mappings = {
                ["<CR>"] = actions.edit,
                ["-"]    = actions.up,

                ["K"]    = actions.mkdir,
                ["N"]    = actions.newfile,
                ["R"]    = actions.rename,
                ["Y"]    = actions.yank_path,
                ["D"]    = actions.delete,
                ["."]    = actions.toggle_show_hidden,
            },
            float = {
                winblend = 15,
                curdir_window = {
                    enable = false,
                    highlight_dirname = false
                },
            },
            hide_cursor = true,
        }

        require("lir.git_status").setup {
            show_ignored = false,
        }

        -- custom folder icon
        require("nvim-web-devicons").set_icon({
            lir_folder_icon = {
                icon = "",
                color = "#7ebae4",
                name = "LirFolderNode",
            }
        })

        vim.keymap.set("n", "<leader>pv", "<cmd>edit %:h<CR>",
            { noremap = true, silent = true, desc = "Open file explorer" })
    end,
}
