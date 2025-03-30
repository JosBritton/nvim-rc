return {
    "tamago324/lir-git-status.nvim",
    dependencies = {
        "JosBritton/lir.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
    },
    event = "User DirEnter",
    keys = {
        { "<leader>pv", nil, desc = "O[p]en File Explorer [V]iew" },
    },
    config = function()
        require("nvim-web-devicons").set_icon({
            lir_folder_icon = {
                icon = "",
                color = "#7ebae4",
                name = "LirFolderNode",
            },
        })

        local actions = require("lir.actions")
        require("lir").setup({
            show_hidden_files = true,
            ignore = {},
            devicons = {
                enable = true,
                highlight_dirname = false,
            },
            mappings = {
                ["<CR>"] = actions.edit,
                ["-"] = actions.up,

                ["d"] = actions.mkdir,
                ["%"] = actions.newfile,
                ["R"] = actions.rename,
                ["Y"] = actions.yank_path,
                ["D"] = actions.delete,
                ["."] = actions.toggle_show_hidden,
            },
            hide_cursor = true,
        })

        vim.keymap.set("n", "<leader>pv", function()
            if vim.bo.filetype == "lir" then
                return
            end

            -- update tag stack with departing item
            local from = { vim.fn.bufnr("%"), vim.fn.line("."), vim.fn.col("."), 0 }
            local items = { { tagname = vim.fn.expand("<cword>"), from = from } }
            vim.fn.settagstack(vim.fn.win_getid(), { items = items }, "t")

            vim.cmd.edit("%:h")
        end, {
            noremap = true,
            silent = true,
            desc = "O[p]en File Explorer [V]iew",
        })

        require("lir.git_status").setup({
            show_ignored = false,
        })
    end,
}
