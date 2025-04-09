return {
    "mfussenegger/nvim-lint",
    dependencies = {
        "williamboman/mason.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        ---@type string[]
        local required_bins = {
            "shellcheck",
            "markdownlint",
            "yamllint",
        }
        for _i, e in ipairs(required_bins) do
            assert(
                vim.fn.executable(e) == 1,
                ("`%s` not installed or available."):format(e)
            )
        end

        local lint = require("lint")

        lint.linters_by_ft = {
            bash = { "shellcheck" },
            sh = { "shellcheck" },
            markdown = { "markdownlint" },
            yaml = { "yamllint" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })

        -- try once on init
        lint.try_lint()
    end,
}
