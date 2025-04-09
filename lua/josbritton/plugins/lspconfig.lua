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
        { "j-hui/fidget.nvim", opts = {} }, -- status UI when loading LSP
        { "folke/neodev.nvim", opts = {} },
        { "microsoft/python-type-stubs" },
        { "p00f/clangd_extensions.nvim", lazy = true },
        "saghen/blink.cmp",
    },
    config = function()
        ---@type table<string>
        local required_bins = {
            "clangd",
            "rust-analyzer",
        }

        for _, e in ipairs(required_bins) do
            assert(
                vim.fn.executable(e) == 1,
                string.format("`%s` not installed or available.", e)
            )
        end

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
                nmap("<leader>rn", vim.lsp.buf.rename, "LSP: [R]e[n]ame Item")

                -- execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                nmap("<leader>ca", vim.lsp.buf.code_action, "LSP: [C]ode [A]ction")

                -- opens a popup that displays documentation about the word under your cursor
                --  see `:help K` for why this keymap.
                nmap("K", vim.lsp.buf.hover, "Hover Documentation")

                -- WARN: this is not Goto Definition, this is Goto Declaration.
                --  for example, in C this would take you to the header.
                nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                -- manual format binding
                nmap("<leader>f", vim.lsp.buf.format, "Format current buffer with LSP")

                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                if
                    client
                    and client.server_capabilities.inlayHintProvider
                    and vim.lsp.inlay_hint
                then
                    vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
                    nmap("<leader>th", function()
                        vim.lsp.inlay_hint.enable(
                            not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }),
                            { bufnr = ev.buf }
                        )
                    end, "[T]oggle Inlay [H]ints")
                end

                local lsp_formatting_blocklist = {
                    ts_ls = true,
                    lua_ls = true,
                    rust_analyzer = true,
                }
                -- continue only if we need LSP formatting
                if
                    not (client and client.server_capabilities.documentFormattingProvider)
                    or lsp_formatting_blocklist[client.name] ~= nil
                then
                    return
                end

                -- create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(ev.buf, "Format", function(_)
                    vim.lsp.buf.format()
                end, { desc = "Format current buffer with LSP" })

                -- organize Go imports before write
                if client.name == "gopls" then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = id,
                        buffer = ev.buf,
                        callback = function()
                            local params = vim.lsp.util.make_range_params()
                            params.context = { only = { "source.organizeImports" } }

                            local timeout_ms = 1000
                            local result, _ = vim.lsp.buf_request_sync(
                                0,
                                "textDocument/codeAction",
                                params,
                                timeout_ms
                            )
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
                                async = false, -- default
                                filter = function(c)
                                    return c.id == client.id
                                end,
                            })
                        end,
                    })
                    return
                end

                -- LSP autoformatting *before* saving file
                --
                -- if LSP client that is attaching to current buffer is in table `lsp_autoformat_clients`:
                -- if NOT NIL,
                --     enable autoformatting, creating the command `:AutoFormatOFF` to temporarily disable it
                -- if NIL,
                --     create the command `AutoFormatON` to temporarily enable autoformatting

                local lsp_autoformat_clients = {}

                ---@type function
                local enable_lsp_autoformatting
                ---@type function
                local create_autoformat_off_cmd
                ---@type function
                local create_autoformat_on_cmd

                ---@return number # The ID number of the autocommand that was just created
                enable_lsp_autoformatting = function()
                    local cmd = vim.api.nvim_create_autocmd("BufWritePre", {
                        group = id,
                        buffer = ev.buf,
                        callback = function()
                            vim.lsp.buf.format({
                                async = false, -- default
                                filter = function(c)
                                    return c.id == client.id
                                end,
                            })
                        end,
                    })
                    return cmd
                end

                ---@param cmd number The ID number of the autocommand to be deleted
                ---@return nil
                create_autoformat_off_cmd = function(cmd)
                    pcall(vim.api.nvim_buf_del_user_command, ev.buf, "AutoFormatON")

                    -- use with `:AutoFormatOFF`, buffer-local & temporary
                    vim.api.nvim_buf_create_user_command(
                        ev.buf,
                        "AutoFormatOFF",
                        function()
                            local ok, _ = pcall(vim.api.nvim_del_autocmd, cmd)
                            if ok then
                                create_autoformat_on_cmd()
                            end
                        end,
                        { desc = "Disable automatic LSP formatting before saving" }
                    )
                end

                ---@return nil
                create_autoformat_on_cmd = function()
                    pcall(vim.api.nvim_buf_del_user_command, ev.buf, "AutoFormatOFF")

                    -- use with `:AutoFormatON`, buffer-local & temporary
                    vim.api.nvim_buf_create_user_command(
                        ev.buf,
                        "AutoFormatON",
                        function()
                            local ok, cmd = pcall(enable_lsp_autoformatting)
                            if ok then
                                create_autoformat_off_cmd(cmd)
                            end
                        end,
                        { desc = "Enable automatic LSP formatting before saving" }
                    )
                end

                if (lsp_autoformat_clients or {})[client.name] ~= nil then
                    local ok, cmd = pcall(enable_lsp_autoformatting)
                    if ok then
                        create_autoformat_off_cmd(cmd)
                    end
                else
                    create_autoformat_on_cmd()
                end
            end,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend(
            "force",
            capabilities,
            require("blink-cmp").get_lsp_capabilities()
        )

        local system_servers = {
            clangd = {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                root_dir = function(fname)
                    return require("lspconfig.util").root_pattern(
                        "Makefile",
                        ".clangd",
                        ".clang-tidy",
                        ".clang-format",
                        "configure.ac",
                        "configure.in",
                        "config.h.in",
                        "meson.build",
                        "meson_options.txt",
                        "build.ninja"
                    )(fname) or require("lspconfig.util").root_pattern(
                        "compile_commands.json",
                        "compile_flags.txt"
                    )(fname) or vim.fs.dirname(
                        vim.fs.find(".git", { path = fname, upward = true })[1]
                    )
                end,
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
            },
            rust_analyzer = {
                settings = {
                    ["rust-analyzer"] = {
                        inlayHints = {
                            -- maxLength = 25,
                            -- bindingModeHints = {
                            --     enable = true,
                            -- },
                            closureCaptureHints = {
                                enable = true,
                            },
                            closureReturnTypeHints = {
                                enable = true,
                            },
                            discriminantHints = {
                                enable = true,
                            },
                            -- expressionAdjustmentHints = {
                            --     enable = true,
                            --     -- hideOutsideUnsafe = false,
                            --     -- mode = "prefix",
                            -- },
                            -- genericParameterHints = {
                            --     lifetime = {
                            --         enable = true,
                            --     },
                            --     type = {
                            --         enable = true,
                            --     },
                            -- },
                            -- implicitDrops = {
                            --     enable = true,
                            -- },
                            -- implicitSizedBoundHints = {
                            --     enable = true,
                            -- },
                            -- lifetimeElisionHints = {
                            --     enable = true,
                            --     useParameterNames = true,
                            -- },
                            -- rangeExclusiveHints = {
                            --     enable = true,
                            -- },
                            -- reborrowHints = {
                            --     enable = true,
                            -- },
                            -- typeHints = {
                            --     hideClosureInitialization = true,
                            --     hideClosureParameter = true,
                            --     hideNamedConstructor = true,
                            -- },
                        },
                        imports = {
                            granularity = {
                                group = "module", -- def: "crate"
                                enforce = true,
                            },
                            prefix = "self", -- def: "plain"
                            preferNoStd = true,
                            -- prefixExternPrelude = true,
                        },
                        completion = {
                            -- limit = 10,
                            -- fullFunctionSignatures = {
                            --     enable = true, -- def: false
                            -- },
                            -- show private items and fields even if they aren't visible
                            privateEditable = {
                                enable = true,
                            },
                            -- -- expensive?
                            -- termSearch = {
                            --     enable = true,
                            --     fuel = 1000, -- fuel in "units of work"
                            -- },
                        },
                        diagnostics = {
                            styleLints = {
                                enable = true,
                            },
                            -- experimental = {
                            --     enable = true,
                            -- },
                        },
                    },
                },
            },
        }

        local mason_servers = {
            -- keys are lspconfig server names
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
            ts_ls = {
                settings = {
                    implicitProjectConfiguration = {
                        checkJs = true,
                    },
                },
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

        ---@param server_name string
        ---@param server_list table<string, table>
        local function setup_lsp_server(server_name, server_list)
            local server = server_list[server_name] or {}
            -- this handles overriding only values explicitly passed
            -- by the server configuration above
            server.capabilities =
                vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
        end

        local function mason_server_handler(mason_server_name)
            setup_lsp_server(mason_server_name, mason_servers)
        end

        -- installs packages to:
        -- ~/.local/share/nvim/mason/packages
        require("mason-lspconfig").setup({
            ensure_installed = vim.tbl_keys(mason_servers or {}),
            handlers = {
                mason_server_handler,
            },
        })
        for k, _v in pairs(system_servers or {}) do
            setup_lsp_server(k, system_servers or {})
        end
    end,
}
