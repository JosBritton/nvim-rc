return {
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
    -- use a release tag to download pre-built binaries
    version = "1.*",
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
            default = { "lsp", "path", "snippets" },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },

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
}
