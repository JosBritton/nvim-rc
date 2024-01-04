return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        -- load treesitter only after first render of a buffer has completed
        -- (defer setup for 0ms)
        vim.defer_fn(function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "c", "cpp", "go", "lua", "python", "rust", "tsx", "javascript",
                    "typescript", "vimdoc", "vim", "bash", "markdown"
                },
                auto_install = true,
                sync_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        -- init_selection = "<c-space>",
                        -- node_incremental = "<c-space>",
                        scope_incremental = "<c-s>",
                        node_decremental = "<M-space>",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- you can use the capture groups defined in textobjects.scm
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner",
                        },
                    },
                },
            }
        end, 0)
    end
}
