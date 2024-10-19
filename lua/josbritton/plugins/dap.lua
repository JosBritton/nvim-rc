return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
        {
            "<F5>",
            "<Cmd>lua require('dap').continue()<CR>",
            desc = "Debug: Start/Continue",
        },
        {
            "<F1>",
            "<Cmd>lua require('dap').step_into()<CR>",
            desc = "Debug: Step Into",
        },
        {
            "<F2>",
            "<Cmd>lua require('dap').step_over()<CR>",
            desc = "Debug: Step Over",
        },
        {
            "<F3>",
            "<Cmd>lua require('dap').step_out()<CR>",
            desc = "Debug: Step Out",
        },
        {
            "<leader>b",
            "<Cmd>lua require('dap').toggle_breakpoint()<CR>",
            desc = "Debug: Toggle Breakpoint",
        },
        {
            "<leader>B",
            function()
                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
            desc = "Debug: Set Breakpoint",
        },
    },
    config = function()
        require("mason-nvim-dap").setup({
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_setup = true,
            automatic_installation = false,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            -- You'll need to check that you have the required things installed
            -- online, please don't ask me how to install them :)
            ensure_installed = {
                -- Update this to ensure that you have the debuggers for the langs you want
                "delve",
            },
        })
    end,
}
