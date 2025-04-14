return {
    {
        "saghen/blink.pairs",
        event = "InsertEnter",
        version = false, -- use latest commit
        build = (function()
            -- rustup is makes building from nightly much easier, use if possible
            if vim.fn.executable("rustup") ~= 1 then
                if vim.fn.executable("cargo") ~= 1 then
                    return -- no build will occur, and may fallback to lua if unbuilt!
                end
                return "cargo build --release" -- requires nightly!
            end
            return "rustup run nightly cargo build --release"
        end)(),
        --- @module "blink.pairs"
        --- @type blink.pairs.Config
        opts = {
            mappings = {
                -- you can call require("blink.pairs.mappings").enable()
                --   and require("blink.pairs.mappings").disable()
                --   to enable/disable mappings at runtime
                enabled = true,
                -- see the defaults:
                -- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L10
                pairs = {},
            },
            highlights = {
                enabled = false,
                groups = {},
                matchparen = { enabled = false },
            },
            debug = false,
        },
    },
    {
        "saghen/blink.cmp",
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = (function()
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
            },
        },
        event = "InsertEnter",
        -- version = "*", -- latest stable release
        build = (function()
            -- rustup is makes building from nightly much easier, use if possible
            if vim.fn.executable("rustup") ~= 1 then
                if vim.fn.executable("cargo") ~= 1 then
                    return -- no build will occur, and may fallback to lua if unbuilt!
                end
                return "cargo build --release" -- requires nightly!
            end
            return "rustup run nightly cargo build --release"
        end)(),
        ---@module "blink.cmp"
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                ["<C-h"] = {},
                ["<C-l"] = {},
                ["<Esc>"] = { "fallback" },
                preset = "enter",
            },

            appearance = {
                -- "mono" (default) for "Nerd Font Mono" or "normal" for "Nerd Font"
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            completion = {
                list = {
                    -- https://cmp.saghen.dev/configuration/completion#list
                    -- Manual, Auto Insert
                    selection = {
                        preselect = false,
                        auto_insert = true,
                    },
                },
                menu = {
                    direction_priority = { "s", "n" },
                    draw = {
                        treesitter = {},
                        -- treesitter = { "lsp" },
                        components = {
                            label = {
                                width = { fill = false, max = 30 },
                                text = function(ctx)
                                    return ctx.label
                                end,
                                highlight = function(ctx)
                                    -- label and label details
                                    local highlights = {
                                        {
                                            0,
                                            #ctx.label,
                                            group = ctx.deprecated
                                                    and "BlinkCmpLabelDeprecated"
                                                or "BlinkCmpLabel",
                                        },
                                    }
                                    if ctx.label_detail then
                                        table.insert(highlights, {
                                            #ctx.label,
                                            #ctx.label + #ctx.label_detail,
                                            group = "BlinkCmpLabelDetail",
                                        })
                                    end

                                    -- characters matched on the label by the fuzzy matcher
                                    for _, idx in ipairs(ctx.label_matched_indices) do
                                        table.insert(
                                            highlights,
                                            { idx, idx + 1, group = "BlinkCmpLabelMatch" }
                                        )
                                    end

                                    return highlights
                                end,
                            },

                            label_description = {
                                width = { max = 60, fill = false },
                                text = function(ctx)
                                    return ctx.label_detail .. ctx.label_description
                                end,
                                highlight = "BlinkCmpLabelDescription",
                            },
                        },
                        columns = {
                            { "label" },
                            { "kind" },
                            { "label_description" },
                            -- { "label", "label_description", gap = 1 },
                            -- { "kind_icon", "kind" },
                        },
                    },
                },
                accept = {
                    create_undo_point = true,
                    -- some LSPs may add auto brackets themselves. You may be able to configure this
                    -- behavior in your LSP client configuration
                    -- auto_brackets = true,
                },
                documentation = {
                    auto_show = true,
                    -- NOTE: will NOT wrap lines to fit in window, only line breaks in content are
                    -- considered
                    window = {
                        -- border is practically required for vertical windowing
                        border = "single",
                        scrollbar = true,
                        direction_priority = {
                            -- allow extending popup window only, do not surround line with popup
                            menu_north = { "e", "w", "n" },
                            menu_south = { "e", "w", "s" },
                            -- -- force horizontal windowing only
                            -- menu_north = { "e", "w" },
                            -- menu_south = { "e", "w" },
                        },
                        max_height = 20,
                    },
                    auto_show_delay_ms = 500,
                },
            },

            snippets = { preset = "luasnip" },

            -- can extend without redefining it, using `opts_extend`
            sources = {
                default = { "lazydev", "lsp", "path", "snippets" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            },
            fuzzy = {
                implementation = "prefer_rust_with_warning",
                -- default behavior is to download prebuilt binareis when `version` is defined
                -- force compilation from source
                prebuilt_binaries = {
                    download = false,
                },
            },
            signature = {
                -- 2025-03-30 marked as experimental (opt-in)
                enabled = true,
                trigger = {
                    show_on_trigger_character = true,
                    show_on_insert_on_trigger_character = true,
                    show_on_keyword = true,
                },
                window = {
                    show_documentation = true, -- very important nvim-cmp esque behavior
                    border = "single",
                    -- treesitter_highlighting = false,
                    direction_priority = { "s", "n" },
                    max_height = 80, -- includes length of often large docs
                },
            },
            cmdline = {
                keymap = {
                    ["<C-h"] = {},
                    ["<C-l"] = {},
                    ["<CR>"] = { "accept", "fallback" },
                    ["<Up>"] = {
                        function(cmp)
                            if cmp.is_menu_visible() then
                                cmp.select_prev()
                                -- do not run next command
                                return true
                            end
                        end,
                        -- if menu is not active, fallback to normal binding
                        "fallback",
                    },
                    ["<Down>"] = {
                        function(cmp)
                            if cmp.is_menu_visible() then
                                cmp.select_next()
                                -- do not run next command
                                return true
                            end
                        end,
                        -- if menu is not active, fallback to normal binding
                        "fallback",
                    },
                },
            },
        },
        opts_extend = { "sources.default" },
    },
}
