return {
    "mfussenegger/nvim-lint",
    dependencies = {
        "williamboman/mason.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        ---@type table<string>
        local required_bins = {
            "shellcheck",
            "markdownlint",
            "yamllint",
        }

        for _, e in ipairs(required_bins) do
            assert(
                vim.fn.executable(e) == 1,
                string.format("`%s` not installed or available.", e)
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
    end,
}
