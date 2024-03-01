return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- install real fzf
        --{ "junegunn/fzf", build = "./install --completion --key-bindings --no-update-rc" },
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
        { "<leader>?",  "<cmd>Telescope oldfiles<CR>",   desc = "[?] Find recently opened files" },
        -- { "<leader><space>", "<cmd>Telescope buffers<CR>", desc = "[ ] Find existing buffers" },
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
        { "<C-p>",      "<cmd>Telescope git_files<CR>",  desc = "Search Git Files" },
        { "<leader>pf", "<cmd>Telescope find_files<CR>", desc = "Search [P]roject [F]iles" },
        { "<leader>ps", "<cmd>Telescope live_grep<CR>",  desc = "Search [P]roject by Grep [S]tring" },

        -- { "<leader>sh", "<cmd>Telescope help_tags<CR>",   desc = "[S]earch [H]elp" },
        -- { "<leader>sw", "<cmd>Telescope grep_string<CR>", desc = "[S]earch current [W]ord" },
        -- { "<leader>sg", "<cmd>Telescope live_grep<CR>",   desc = "[S]earch by [G]rep" },
        -- { "<leader>sd", "<cmd>Telescope diagnostics<CR>", desc = "[S]earch [D]iagnostics" },
        -- { "<leader>sr", "<cmd>Telescope resume<CR>",      desc = "[S]earch [R]esume" },
        -- { "<leader>sG", "<cmd>LiveGrepGitRoot<CR>",       desc = "[S]earch by [G]rep on Git Root" },
    },
    cmd = {
        "LiveGrepGitRoot",
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
        }

        if vim.fn.executable "rg" ~= 1 then
            error("ripgrep not installed")
        end

        if vim.fn.executable "fzf" ~= 1 then
            error("fzf not installed")
        end

        -- enable telescope fzf native, if installed
        pcall(require("telescope").load_extension, "fzf")

        -- telescope live_grep in git root
        -- function to find the git root directory based on the current buffer's path
        local function find_git_root()
            -- use the current buffer's path as the starting point for the git search
            local current_file = vim.api.nvim_buf_get_name(0)
            local current_dir
            local cwd = vim.fn.getcwd()
            -- if the buffer is not associated with a file, return nil
            if current_file == "" then
                current_dir = cwd
            else
                -- extract the directory from the current file's path
                current_dir = vim.fn.fnamemodify(current_file, ":h")
            end

            -- find the Git root directory from the current file's path
            local git_root = vim.fn.systemlist("git -C " ..
                vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
            if vim.v.shell_error ~= 0 then
                print("Not a git repository. Searching on current working directory")
                return cwd
            end
            return git_root
        end

        -- custom live_grep function to search in git root
        local function live_grep_git_root()
            local git_root = find_git_root()
            if git_root then
                require("telescope.builtin").live_grep({
                    search_dirs = { git_root },
                })
            end
        end

        vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

        -- vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
        -- vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
        -- vim.keymap.set("n", "<leader>/", function()
        --   -- you can pass additional configuration to telescope to change theme, layout, etc.
        --   require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        --     winblend = 10,
        --     previewer = false,
        --   })
        -- end, { desc = "[/] Fuzzily search in current buffer" })

        -- vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
        -- vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
        -- vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
        -- vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
        -- vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
        -- vim.keymap.set("n", "<leader>sG", ":LiveGrepGitRoot<cr>", { desc = "[S]earch by [G]rep on Git Root" })
        -- vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
        -- vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
    end
}
