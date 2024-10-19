return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({
                    async = true,
                    lsp_format = "fallback",
                })
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
    },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- enable "format_on_save lsp_fallback" for specific languages
            local enable_filetypes = { lua = true }
            ---@type nil|conform.LspFormatOpts
            local lsp_format_opt
            if enable_filetypes[vim.bo[bufnr].filetype] then
                lsp_format_opt = "fallback"
            else
                lsp_format_opt = "never"
            end
            return {
                timeout_ms = 500,
                lsp_format = lsp_format_opt,
            }
        end,
        formatters_by_ft = {
            lua = { "stylua" },
            -- conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            --
            -- you can use 'stop_after_first' to run the first available formatter from
            -- the list
            -- javascript = { "prettierd", "prettier", stop_after_first = true },
        },
    },
}
