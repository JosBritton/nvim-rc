return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- automatically install LSPs to stdpath for neovim
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        -- useful status updates for LSP
        { "j-hui/fidget.nvim", opts = {} },
        "folke/neodev.nvim",
    },
    cmd = { "Mason" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        --  this function gets run when an LSP connects to a particular buffer.
        local on_attach = function(_, bufnr)
            -- in this case, we create a function that lets us more easily define mappings specific
            -- for LSP related items. It sets the mode, buffer and description for us each time.
            local nmap = function(keys, func, desc)
                if desc then
                    desc = "LSP: " .. desc
                end

                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
            end

            nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
            nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

            nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
            nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
            nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
            nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
            nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
            nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

            -- see `:help K` for why this keymap
            nmap("K", vim.lsp.buf.hover, "Hover Documentation")
            nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

            -- lesser used LSP functionality
            -- nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
            -- nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
            -- nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
            -- nmap("<leader>wl", function()
            --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            -- end, "[W]orkspace [L]ist Folders")

            -- manual format binding
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format current buffer with LSP" })

            -- create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
                vim.lsp.buf.format()
            end, { desc = "Format current buffer with LSP" })
        end

        -- document existing key chains
        -- require("which-key").register {
        -- ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
        -- ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
        -- ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
        -- ["<leader>h"] = { name = "More git", _ = "which_key_ignore" },
        -- ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
        -- ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
        -- ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
        -- }

        -- mason-lspconfig requires that these setup functions are called in this order
        -- before setting up the servers.
        require("mason").setup()
        require("mason-lspconfig").setup()

        -- enable the following language servers
        --  feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  add any additional override configuration in the following tables. They will be passed to
        --  the `settings` field of the server config. You must look up that documentation yourself.
        --
        --  if you want to override the default filetypes that your language server will attach to you can
        --  define the property "filetypes" to the map in question.
        local servers = {
            -- clangd = {},
            -- gopls = {},
            -- pyright = {},
            -- rust_analyzer = {},
            -- tsserver = {},
            -- html = { filetypes = { "html", "twig", "hbs"} },

            lua_ls = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                    -- toggle below to ignore Lua_LS"s noisy `missing-fields` warnings
                    -- diagnostics = { disable = { "missing-fields" } },
                },
            },
        }

        -- setup neovim lua configuration
        require("neodev").setup()

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        -- ensure the servers above are installed
        local mason_lspconfig = require "mason-lspconfig"

        mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(servers),
        }

        mason_lspconfig.setup_handlers {
            function(server_name)
                require("lspconfig")[server_name].setup {
                    capabilities = capabilities,
                    on_attach = on_attach,
                    settings = servers[server_name],
                    filetypes = (servers[server_name] or {}).filetypes,
                }
            end,
        }

        -- switch for controlling whether you want autoformatting.
        --  use :KickstartFormatToggle to toggle autoformatting on or off
        local format_is_enabled = true
        -- vim.api.nvim_create_user_command("KickstartFormatToggle", function()
        --     format_is_enabled = not format_is_enabled
        --     print("Setting autoformatting to: " .. tostring(format_is_enabled))
        -- end, {})

        -- create an augroup that is used for managing our formatting autocmds.
        --      we need one augroup per client to make sure that multiple clients
        --      can attach to the same buffer without interfering with each other.
        local _augroups = {}
        local get_augroup = function(client)
            if not _augroups[client.id] then
                local group_name = "kickstart-lsp-format-" .. client.name
                local id = vim.api.nvim_create_augroup(group_name, { clear = true })
                _augroups[client.id] = id
            end

            return _augroups[client.id]
        end

        -- whenever an LSP attaches to a buffer, we will run this function.
        --
        -- see `:help LspAttach` for more information about this autocmd event.
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach-format", { clear = true }),
            -- this is where we attach the autoformatting for reasonable clients
            callback = function(args)
                local client_id = args.data.client_id
                local client = vim.lsp.get_client_by_id(client_id)
                local bufnr = args.buf

                -- only attach to clients that support document formatting
                if not client.server_capabilities.documentFormattingProvider then
                    return
                end

                -- tsserver usually works poorly. Sorry you work with bad languages
                -- you can remove this line if you know what you're doing :)
                if client.name == "tsserver" then
                    return
                end

                -- create an autocmd that will run *before* we save the buffer.
                --  run the formatting command for the LSP that has just attached.
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = get_augroup(client),
                    buffer = bufnr,
                    callback = function()
                        if not format_is_enabled then
                            return
                        end

                        vim.lsp.buf.format {
                            async = false,
                            filter = function(c)
                                return c.id == client.id
                            end,
                        }
                    end,
                })
            end,
        })
    end,
}
