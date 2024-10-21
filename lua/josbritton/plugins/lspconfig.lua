---@class (exact) EventArgs
---@field id number
---@field event string
---@field group number|nil
---@field match string
---@field buf number
---@field file string
---@field data any

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "b0o/schemastore.nvim",
        { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        { "j-hui/fidget.nvim", opts = {} }, -- status UI when loading LSP
        { "folke/neodev.nvim", opts = {} },
        { "microsoft/python-type-stubs" },
    },
    config = function()
        ---@type integer
        local id = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true })
        vim.api.nvim_create_autocmd("LspAttach", {
            group = id,
            callback = function(ev)
                ---@param keys string
                ---@param func function
                ---@param desc string
                local nmap = function(keys, func, desc)
                    vim.keymap.set(
                        "n",
                        keys,
                        func,
                        { buffer = ev.buf, desc = "LSP: " .. desc }
                    )
                end

                -- jump to the definition of the word under your cursor.
                --  This is where a variable was first declared, or where a function is defined, etc.
                --  To jump back, press <C-t>.
                nmap(
                    "gd",
                    require("telescope.builtin").lsp_definitions,
                    "[G]oto [D]efinition"
                )

                -- find references for the word under your cursor.
                nmap(
                    "gr",
                    require("telescope.builtin").lsp_references,
                    "[G]oto [R]eferences"
                )

                -- jump to the implementation of the word under your cursor.
                --  Useful when your language has ways of declaring types without an actual implementation.
                nmap(
                    "gI",
                    require("telescope.builtin").lsp_implementations,
                    "[G]oto [I]mplementation"
                )

                -- jump to the type of the word under your cursor.
                --  useful when you're not sure what type a variable is and you want to see
                --  the definition of its *type*, not where it was *defined*.
                nmap(
                    "<leader>D",
                    require("telescope.builtin").lsp_type_definitions,
                    "Type [D]efinition"
                )

                -- fuzzy find all the symbols in your current document.
                --  symbols are things like variables, functions, types, etc.
                nmap(
                    "<leader>ds",
                    require("telescope.builtin").lsp_document_symbols,
                    "[D]ocument [S]ymbols"
                )

                -- fuzzy find all the symbols in your current workspace.
                --  similar to document symbols, except searches over your entire project.
                nmap(
                    "<leader>ws",
                    require("telescope.builtin").lsp_dynamic_workspace_symbols,
                    "[W]orkspace [S]ymbols"
                )

                -- rename the variable under your cursor.
                --  most Language Servers support renaming across files, etc.
                nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

                -- execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

                -- opens a popup that displays documentation about the word under your cursor
                --  see `:help K` for why this keymap.
                nmap("K", vim.lsp.buf.hover, "Hover Documentation")

                -- WARN: this is not Goto Definition, this is Goto Declaration.
                --  for example, in C this would take you to the header.
                nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                -- manual format binding
                nmap("<leader>f", vim.lsp.buf.format, "Format current buffer with LSP")

                -- create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(ev.buf, "Format", function(_)
                    vim.lsp.buf.format()
                end, { desc = "Format current buffer with LSP" })

                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                if
                    client
                    and client.server_capabilities.inlayHintProvider
                    and vim.lsp.inlay_hint
                then
                    nmap("<leader>th", function()
                        ---@diagnostic disable-next-line: missing-parameter
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end, "[T]oggle Inlay [H]ints")
                end

                if
                    not (client and client.server_capabilities.documentFormattingProvider)
                    or client.name == "ts_ls"
                then
                    return
                end

                -- organize Go imports before write
                if client.name == "gopls" then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = id,
                        buffer = ev.buf,
                        callback = function()
                            local params = vim.lsp.util.make_range_params()
                            params.context = { only = { "source.organizeImports" } }

                            local result, _ = vim.lsp.buf_request_sync(
                                0,
                                "textDocument/codeAction",
                                params,
                                1000
                            ) -- 1000 ms timeout
                            for cid, res in pairs(result or {}) do
                                for _, r in pairs(res.result or {}) do
                                    if r.edit then
                                        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding
                                            or "utf-16"
                                        vim.lsp.util.apply_workspace_edit(r.edit, enc)
                                    end
                                end
                            end
                            vim.lsp.buf.format({
                                async = false,
                                filter = function(c)
                                    return c.id == client.id
                                end,
                            })
                        end,
                    })
                    return
                end

                -- -- create an autocmd that will run *before* we save the buffer.
                -- --  run the formatting command for the LSP that has just attached.
                -- vim.api.nvim_create_autocmd("BufWritePre", {
                --     group = id,
                --     buffer = ev.buf,
                --     callback = function()
                --         vim.lsp.buf.format {
                --             async = false,
                --             filter = function(c)
                --                 return c.id == client.id
                --             end,
                --         }
                --     end,
                -- })
            end,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend(
            "force",
            capabilities,
            require("cmp_nvim_lsp").default_capabilities()
        )

        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        diagnostics = { disable = { "missing-fields" } },
                    },
                },
            },
            jsonls = {
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            },
            yamlls = {
                settings = {
                    yaml = {
                        schemaStore = {
                            -- must disable built-in schemaStore to use schemaStore plugin
                            enable = false,
                            -- avoid TypeError
                            url = "",
                        },
                        schemas = require("schemastore").yaml.schemas(),
                    },
                },
            },
            gopls = {
                settings = {
                    completeUnimported = true,
                    usePlaceholders = true,
                    analyses = {
                        unusedvariable = true,
                        useany = true,
                    },
                    -- gofumpt = true,
                    -- staticcheck = true
                },
            },
            pyright = {
                -- adds all the VSCode msoft type stubs to your pyright env
                -- might not be a great idea
                before_init = function(_, config)
                    ---@type string
                    ---@diagnostic disable-next-line:assign-type-mismatch
                    local std_data = vim.fn.stdpath("data")
                    config.settings.python.analysis.stubPath =
                        vim.fs.joinpath(std_data, "lazy", "python-type-stubs")
                end,
            },
        }

        require("mason").setup({
            max_concurrent_installers = 10,
            ui = {
                icons = {
                    package_installed = "󰄳 ",
                    package_pending = " ",
                    package_uninstalled = "󰄯 ",
                },
            },
        })

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            "stylua",
            "markdownlint",
        })
        require("mason-tool-installer").setup({
            ensure_installed = ensure_installed,
        })

        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    -- this handles overriding only values explicitly passed
                    -- by the server configuration above
                    server.capabilities = vim.tbl_deep_extend(
                        "force",
                        {},
                        capabilities,
                        server.capabilities or {}
                    )
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })
    end,
}
