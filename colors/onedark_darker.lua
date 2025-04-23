---@param group string
---@param style vim.api.keyset.highlight
local hl = function(group, style)
    vim.api.nvim_set_hl(0, group, style)
end

local M = {}

---@param hex_str string
---@return number[]
local function hexToRgb(hex_str)
    local hex = "[abcdef0-9][abcdef0-9]"
    local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
    hex_str = string.lower(hex_str)

    assert(
        string.find(hex_str, pat) ~= nil,
        "hex_to_rgb: invalid hex_str: " .. tostring(hex_str)
    )

    local r, g, b = string.match(hex_str, pat)
    return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

---@param fg string foreground color
---@param bg string background color
---@param alpha number number between 0 and 1. 0 results in bg, 1 results in fg
---@return string
local function util_blend(fg, bg, alpha)
    local bg = hexToRgb(bg)
    local fg = hexToRgb(fg)

    local blendChannel = function(i)
        local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
        return math.floor(math.min(math.max(0, ret), 255) + 0.5)
    end

    return string.format(
        "#%02X%02X%02X",
        blendChannel(1),
        blendChannel(2),
        blendChannel(3)
    )
end

local function util_darken(hex, amount, bg)
    return util_blend(hex, bg or "#000000", math.abs(amount))
end

local cfg = {
    style = "darker",
    transparent = false, -- don't set background
    ending_tildes = false, -- show the end-of-buffer tildes
    cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
    -- Changing Formats
    code_style = {
        comments = { italic = true },
        keywords = {},
        functions = {},
        strings = {},
        variables = {},
    },
    ---@type table<string, string>?
    colors = {
        -- grey = "#878787",
        -- green = "#00ffaa",
    },
    diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true, -- use undercurl for diagnostics
        background = true, -- use background color for virtual text
    },
    -- called after loaded
    overrides = function()
        -- hl("Visual", { bg = "#4a4a4a" })
    end,
}

---@return nil
function M:load()
    if vim.g.colors_name then
        vim.cmd("hi clear")
    end
    vim.cmd("set t_Co=256")
    vim.g.colors_name = "onedark_darker"
    local palette = {
        dark = {
            black = "#181a1f",
            bg0 = "#282c34",
            bg1 = "#31353f",
            bg2 = "#393f4a",
            bg3 = "#3b3f4c",
            bg_d = "#21252b",
            bg_blue = "#73b8f1",
            bg_yellow = "#ebd09c",
            fg = "#abb2bf",
            purple = "#c678dd",
            green = "#98c379",
            orange = "#d19a66",
            blue = "#61afef",
            yellow = "#e5c07b",
            cyan = "#56b6c2",
            red = "#e86671",
            grey = "#5c6370",
            light_grey = "#848b98",
            dark_cyan = "#2b6f77",
            dark_red = "#993939",
            dark_yellow = "#93691d",
            dark_purple = "#8a3fa0",
            diff_add = "#31392b",
            diff_delete = "#382b2c",
            diff_change = "#1c3448",
            diff_text = "#2c5372",
        },
        darker = {
            black = "#0e1013",
            bg0 = "#1f2329",
            bg1 = "#282c34",
            bg2 = "#30363f",
            bg3 = "#323641",
            bg_d = "#181b20",
            bg_blue = "#61afef",
            bg_yellow = "#e8c88c",
            fg = "#a0a8b7",
            purple = "#bf68d9",
            green = "#8ebd6b",
            orange = "#cc9057",
            blue = "#4fa6ed",
            yellow = "#e2b86b",
            cyan = "#48b0bd",
            red = "#e55561",
            grey = "#535965",
            light_grey = "#7a818e",
            dark_cyan = "#266269",
            dark_red = "#8b3434",
            dark_yellow = "#835d1a",
            dark_purple = "#7e3992",
            diff_add = "#272e23",
            diff_delete = "#2d2223",
            diff_change = "#172a3a",
            diff_text = "#274964",
        },
        cool = {
            black = "#151820",
            bg0 = "#242b38",
            bg1 = "#2d3343",
            bg2 = "#343e4f",
            bg3 = "#363c51",
            bg_d = "#1e242e",
            bg_blue = "#6db9f7",
            bg_yellow = "#f0d197",
            fg = "#a5b0c5",
            purple = "#ca72e4",
            green = "#97ca72",
            orange = "#d99a5e",
            blue = "#5ab0f6",
            yellow = "#ebc275",
            cyan = "#4dbdcb",
            red = "#ef5f6b",
            grey = "#546178",
            light_grey = "#7d899f",
            dark_cyan = "#25747d",
            dark_red = "#a13131",
            dark_yellow = "#9a6b16",
            dark_purple = "#8f36a9",
            diff_add = "#303d27",
            diff_delete = "#3c2729",
            diff_change = "#18344c",
            diff_text = "#265478",
        },
        deep = {
            black = "#0c0e15",
            bg0 = "#1a212e",
            bg1 = "#21283b",
            bg2 = "#283347",
            bg3 = "#2a324a",
            bg_d = "#141b24",
            bg_blue = "#54b0fd",
            bg_yellow = "#f2cc81",
            fg = "#93a4c3",
            purple = "#c75ae8",
            green = "#8bcd5b",
            orange = "#dd9046",
            blue = "#41a7fc",
            yellow = "#efbd5d",
            cyan = "#34bfd0",
            red = "#f65866",
            grey = "#455574",
            light_grey = "#6c7d9c",
            dark_cyan = "#1b6a73",
            dark_red = "#992525",
            dark_yellow = "#8f610d",
            dark_purple = "#862aa1",
            diff_add = "#27341c",
            diff_delete = "#331c1e",
            diff_change = "#102b40",
            diff_text = "#1c4a6e",
        },
        warm = {
            black = "#191a1c",
            bg0 = "#2c2d30",
            bg1 = "#35373b",
            bg2 = "#3e4045",
            bg3 = "#404247",
            bg_d = "#242628",
            bg_blue = "#79b7eb",
            bg_yellow = "#e6cfa1",
            fg = "#b1b4b9",
            purple = "#c27fd7",
            green = "#99bc80",
            orange = "#c99a6e",
            blue = "#68aee8",
            yellow = "#dfbe81",
            cyan = "#5fafb9",
            red = "#e16d77",
            grey = "#646568",
            light_grey = "#8b8d91",
            dark_cyan = "#316a71",
            dark_red = "#914141",
            dark_yellow = "#8c6724",
            dark_purple = "#854897",
            diff_add = "#32352f",
            diff_delete = "#342f2f",
            diff_change = "#203444",
            diff_text = "#32526c",
        },
        warmer = {
            black = "#101012",
            bg0 = "#232326",
            bg1 = "#2c2d31",
            bg2 = "#35363b",
            bg3 = "#37383d",
            bg_d = "#1b1c1e",
            bg_blue = "#68aee8",
            bg_yellow = "#e2c792",
            fg = "#a7aab0",
            purple = "#bb70d2",
            green = "#8fb573",
            orange = "#c49060",
            blue = "#57a5e5",
            yellow = "#dbb671",
            cyan = "#51a8b3",
            red = "#de5d68",
            grey = "#5a5b5e",
            light_grey = "#818387",
            dark_cyan = "#2b5d63",
            dark_red = "#833b3b",
            dark_yellow = "#7c5c20",
            dark_purple = "#79428a",
            diff_add = "#282b26",
            diff_delete = "#2a2626",
            diff_change = "#1a2a37",
            diff_text = "#2c485f",
        },
        light = {
            black = "#101012",
            bg0 = "#fafafa",
            bg1 = "#f0f0f0",
            bg2 = "#e6e6e6",
            bg3 = "#dcdcdc",
            bg_d = "#c9c9c9",
            bg_blue = "#68aee8",
            bg_yellow = "#e2c792",
            fg = "#383a42",
            purple = "#a626a4",
            green = "#50a14f",
            orange = "#c18401",
            blue = "#4078f2",
            yellow = "#986801",
            cyan = "#0184bc",
            red = "#e45649",
            grey = "#a0a1a7",
            light_grey = "#818387",
            dark_cyan = "#2b5d63",
            dark_red = "#833b3b",
            dark_yellow = "#7c5c20",
            dark_purple = "#79428a",
            diff_add = "#e2fbe4",
            diff_delete = "#fce2e5",
            diff_change = "#e2ecfb",
            diff_text = "#cad3e0",
        },
    }
    local c = palette[cfg.style]

    for k, v in pairs(cfg.colors or {}) do
        c[k] = v
    end

    local colors = {
        Fg = { fg = c.fg },
        LightGrey = { fg = c.light_grey },
        Grey = { fg = c.grey },
        Red = { fg = c.red },
        Cyan = { fg = c.cyan },
        Yellow = { fg = c.yellow },
        Orange = { fg = c.orange },
        Green = { fg = c.green },
        Blue = { fg = c.blue },
        Purple = { fg = c.purple },
    }

    hl("Normal", { fg = c.fg, bg = cfg.transparent and c.none or c.bg0 })
    hl("Terminal", { fg = c.fg, bg = cfg.transparent and c.none or c.bg0 })
    hl("EndOfBuffer", {
        fg = cfg.ending_tildes and c.bg2 or c.bg0,
        bg = cfg.transparent and c.none or c.bg0,
    })
    hl("FoldColumn", { fg = c.fg, bg = cfg.transparent and c.none or c.bg1 })
    hl("Folded", { fg = c.fg, bg = cfg.transparent and c.none or c.bg1 })
    hl("SignColumn", { fg = c.fg, bg = cfg.transparent and c.none or c.bg0 })
    hl("ToolbarLine", { fg = c.fg })
    hl("Cursor", { reverse = true })
    hl("vCursor", { reverse = true })
    hl("iCursor", { reverse = true })
    hl("lCursor", { reverse = true })
    hl("CursorIM", { reverse = true })
    hl("CursorColumn", { bg = c.bg1 })
    hl("CursorLine", { bg = c.bg1 })
    hl("ColorColumn", { bg = c.bg1 })
    hl("CursorLineNr", { fg = c.fg })
    hl("LineNr", { fg = c.grey })
    hl("Conceal", { fg = c.grey, bg = c.bg1 })
    hl("Added", colors.Green)
    hl("Removed", colors.Red)
    hl("Changed", colors.Blue)
    hl("DiffAdd", { fg = c.none, bg = c.diff_add })
    hl("DiffChange", { fg = c.none, bg = c.diff_change })
    hl("DiffDelete", { fg = c.none, bg = c.diff_delete })
    hl("DiffText", { fg = c.none, bg = c.diff_text })
    hl("DiffAdded", colors.Green)
    hl("DiffChanged", colors.Blue)
    hl("DiffRemoved", colors.Red)
    hl("DiffDeleted", colors.Red)
    hl("DiffFile", colors.Cyan)
    hl("DiffIndexLine", colors.Grey)
    hl("Directory", { fg = c.blue })
    hl("ErrorMsg", { fg = c.red, bold = true })
    hl("WarningMsg", { fg = c.yellow, bold = true })
    hl("MoreMsg", { fg = c.blue, bold = true })
    hl("CurSearch", { fg = c.bg0, bg = c.orange })
    hl("IncSearch", { fg = c.bg0, bg = c.orange })
    hl("Search", { fg = c.bg0, bg = c.bg_yellow })
    hl("Substitute", { fg = c.bg0, bg = c.green })
    hl("MatchParen", { fg = c.none, bg = c.grey })
    hl("NonText", { fg = c.grey })
    hl("Whitespace", { fg = c.grey })
    hl("SpecialKey", { fg = c.grey })
    hl("Pmenu", { fg = c.fg, bg = c.bg1 })
    hl("PmenuSbar", { fg = c.none, bg = c.bg1 })
    hl("PmenuSel", { fg = c.bg0, bg = c.bg_blue })
    hl("WildMenu", { fg = c.bg0, bg = c.blue })
    hl("PmenuThumb", { fg = c.none, bg = c.grey })
    hl("Question", { fg = c.yellow })
    hl("SpellBad", { fg = c.none, undercurl = true, sp = c.red })
    hl("SpellCap", { fg = c.none, undercurl = true, sp = c.yellow })
    hl("SpellLocal", { fg = c.none, undercurl = true, sp = c.blue })
    hl("SpellRare", { fg = c.none, undercurl = true, sp = c.purple })
    hl("StatusLine", { fg = c.fg, bg = c.bg2 })
    hl("StatusLineTerm", { fg = c.fg, bg = c.bg2 })
    hl("StatusLineNC", { fg = c.grey, bg = c.bg1 })
    hl("StatusLineTermNC", { fg = c.grey, bg = c.bg1 })
    hl("TabLine", { fg = c.fg, bg = c.bg1 })
    hl("TabLineFill", { fg = c.grey, bg = c.bg1 })
    hl("TabLineSel", { fg = c.bg0, bg = c.fg })
    hl("WinSeparator", { fg = c.bg3 })
    hl("Visual", { bg = c.bg3 })
    hl("VisualNOS", { fg = c.none, bg = c.bg2, underline = true })
    hl("QuickFixLine", { fg = c.blue, underline = true })
    hl("Debug", { fg = c.yellow })
    hl("debugPC", { fg = c.bg0, bg = c.green })
    hl("debugBreakpoint", { fg = c.bg0, bg = c.red })
    hl("ToolbarButton", { fg = c.bg0, bg = c.bg_blue })
    hl("FloatBorder", { fg = c.grey, bg = c.bg1 })
    hl("NormalFloat", { fg = c.fg, bg = c.bg1 })

    hl("String", vim.tbl_extend("force", { fg = c.green }, cfg.code_style.strings))
    hl("Character", colors.Orange)
    hl("Number", colors.Orange)
    hl("Float", colors.Orange)
    hl("Boolean", colors.Orange)
    hl("Type", colors.Yellow)
    hl("Structure", colors.Yellow)
    hl("StorageClass", colors.Yellow)
    hl("Identifier", vim.tbl_extend("force", { fg = c.red }, cfg.code_style.variables))
    hl("Constant", colors.Cyan)
    hl("PreProc", colors.Purple)
    hl("PreCondit", colors.Purple)
    hl("Include", colors.Purple)
    hl("Keyword", vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords))
    hl("Define", colors.Purple)
    hl("Typedef", colors.Yellow)
    hl("Exception", colors.Purple)
    hl("Conditional", vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords))
    hl("Repeat", vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords))
    hl("Statement", colors.Purple)
    hl("Macro", colors.Red)
    hl("Error", colors.Purple)
    hl("Label", colors.Purple)
    hl("Special", colors.Red)
    hl("SpecialChar", colors.Red)
    hl("Function", vim.tbl_extend("force", { fg = c.blue }, cfg.code_style.functions))
    hl("Operator", colors.Purple)
    hl("Title", colors.Cyan)
    hl("Tag", colors.Green)
    hl("Delimiter", colors.LightGrey)
    hl("Comment", vim.tbl_extend("force", { fg = c.grey }, cfg.code_style.comments))
    hl(
        "SpecialComment",
        vim.tbl_extend("force", { fg = c.grey }, cfg.code_style.comments)
    )
    hl("Todo", vim.tbl_extend("force", { fg = c.red }, cfg.code_style.comments))

    -- nvim-treesitter@0.9.2 and after
    hl("@annotation", colors.Fg)
    hl("@attribute", colors.Cyan)
    hl("@attribute.typescript", colors.Blue)
    hl("@boolean", colors.Orange)
    hl("@character", colors.Orange)
    hl("@comment", vim.tbl_extend("force", { fg = c.grey }, cfg.code_style.comments))
    hl("@comment.todo", vim.tbl_extend("force", { fg = c.red }, cfg.code_style.comments))
    hl(
        "@comment.todo.unchecked",
        vim.tbl_extend("force", { fg = c.red }, cfg.code_style.comments)
    )
    hl(
        "@comment.todo.checked",
        vim.tbl_extend("force", { fg = c.green }, cfg.code_style.comments)
    )
    hl("@constant", { fg = c.orange })
    hl("@constant.builtin", { fg = c.orange })
    hl("@constant.macro", { fg = c.orange })
    hl("@constructor", { fg = c.yellow, bold = true })

    hl("@diff.add", { link = "DiffAdded" })
    hl("@diff.delete", { link = "DiffDeleted" })
    hl("@diff.plus", { link = "DiffAdded" })
    hl("@diff.minus", { link = "DiffDeleted" })
    hl("@diff.delta", { link = "DiffChanged" })

    hl("@error", colors.Fg)
    hl("@function", vim.tbl_extend("force", { fg = c.blue }, cfg.code_style.functions))
    hl(
        "@function.builtin",
        vim.tbl_extend("force", { fg = c.cyan }, cfg.code_style.functions)
    )
    hl(
        "@function.macro",
        vim.tbl_extend("force", { fg = c.cyan }, cfg.code_style.functions)
    )
    hl(
        "@function.method",
        vim.tbl_extend("force", { fg = c.blue }, cfg.code_style.functions)
    )
    hl("@keyword", vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords))
    hl(
        "@keyword.conditional",
        vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords)
    )
    hl("@keyword.directive", colors.Purple)
    hl("@keyword.exception", colors.Purple)
    hl(
        "@keyword.function",
        vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.functions)
    )
    hl("@keyword.import", colors.Purple)
    hl(
        "@keyword.operator",
        vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords)
    )
    hl(
        "@keyword.repeat",
        vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords)
    )
    hl("@label", colors.Red)
    hl("@markup.emphasis", { fg = c.fg, italic = true })
    hl("@markup.environment", colors.Fg)
    hl("@markup.environment.name", colors.Fg)
    hl("@markup.heading", { fg = c.orange, bold = true })
    hl("@markup.link", colors.Blue)
    hl("@markup.link.url", { fg = c.cyan, underline = true })
    hl("@markup.list", colors.Red)
    hl("@markup.math", colors.Fg)
    hl("@markup.raw", colors.Green)
    hl("@markup.strike", { fg = c.fg, strikethrough = true })
    hl("@markup.strong", { fg = c.fg, bold = true })
    hl("@markup.underline", { fg = c.fg, underline = true })
    hl("@module", colors.Yellow)
    hl("@none", colors.Fg)
    hl("@number", colors.Orange)
    hl("@number.float", colors.Orange)
    hl("@operator", colors.Fg)
    hl("@parameter.reference", colors.Fg)
    hl("@property", colors.Cyan)
    hl("@punctuation.delimiter", colors.LightGrey)
    hl("@punctuation.bracket", colors.LightGrey)
    hl("@string", vim.tbl_extend("force", { fg = c.green }, cfg.code_style.strings))
    hl(
        "@string.regexp",
        vim.tbl_extend("force", { fg = c.orange }, cfg.code_style.strings)
    )
    hl("@string.escape", vim.tbl_extend("force", { fg = c.red }, cfg.code_style.strings))
    hl("@string.special.symbol", colors.Cyan)
    hl("@tag", colors.Purple)
    hl("@tag.attribute", colors.Yellow)
    hl("@tag.delimiter", colors.Purple)
    hl("@text", colors.Fg)
    hl("@note", colors.Fg)
    hl("@warning", colors.Fg)
    hl("@danger", colors.Fg)
    hl("@type", colors.Yellow)
    hl("@type.builtin", colors.Orange)
    hl("@variable", vim.tbl_extend("force", { fg = c.fg }, cfg.code_style.variables))
    hl(
        "@variable.builtin",
        vim.tbl_extend("force", { fg = c.red }, cfg.code_style.variables)
    )
    hl("@variable.member", colors.Cyan)
    hl("@variable.parameter", colors.Red)
    hl("@markup.heading.1.markdown", { fg = c.red, bold = true })
    hl("@markup.heading.2.markdown", { fg = c.purple, bold = true })
    hl("@markup.heading.3.markdown", { fg = c.orange, bold = true })
    hl("@markup.heading.4.markdown", { fg = c.red, bold = true })
    hl("@markup.heading.5.markdown", { fg = c.purple, bold = true })
    hl("@markup.heading.6.markdown", { fg = c.orange, bold = true })
    hl("@markup.heading.1.marker.markdown", { fg = c.red, bold = true })
    hl("@markup.heading.2.marker.markdown", { fg = c.purple, bold = true })
    hl("@markup.heading.3.marker.markdown", { fg = c.orange, bold = true })
    hl("@markup.heading.4.marker.markdown", { fg = c.red, bold = true })
    hl("@markup.heading.5.marker.markdown", { fg = c.purple, bold = true })
    hl("@markup.heading.6.marker.markdown", { fg = c.orange, bold = true })
    -- Old configuration for nvim-treesiter@0.9.1 and below
    hl(
        "@conditional",
        vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords)
    )
    hl("@exception", colors.Purple)
    hl("@field", colors.Cyan)
    hl("@float", colors.Orange)
    hl("@include", colors.Purple)
    hl("@method", vim.tbl_extend("force", { fg = c.blue }, cfg.code_style.functions))
    hl("@namespace", colors.Yellow)
    hl("@parameter", colors.Red)
    hl("@preproc", colors.Purple)
    hl("@punctuation.special", colors.Red)
    hl("@repeat", vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords))
    hl(
        "@string.regex",
        vim.tbl_extend("force", { fg = c.orange }, cfg.code_style.strings)
    )
    hl("@text.strong", { fg = c.fg, bold = true })
    hl("@text.emphasis", { fg = c.fg, italic = true })
    hl("@text.underline", { fg = c.fg, underline = true })
    hl("@text.strike", { fg = c.fg, strikethrough = true })
    hl("@text.title", { fg = c.orange, bold = true })
    hl("@text.literal", colors.Green)
    hl("@text.uri", { fg = c.cyan, underline = true })
    hl("@text.todo", vim.tbl_extend("force", { fg = c.red }, cfg.code_style.comments))
    hl(
        "@text.todo.unchecked",
        vim.tbl_extend("force", { fg = c.red }, cfg.code_style.comments)
    )
    hl(
        "@text.todo.checked",
        vim.tbl_extend("force", { fg = c.green }, cfg.code_style.comments)
    )
    hl("@text.math", colors.Fg)
    hl("@text.reference", colors.Blue)
    hl("@text.environment", colors.Fg)
    hl("@text.environment.name", colors.Fg)
    hl("@text.diff.add", colors.Green)
    hl("@text.diff.delete", colors.Red)
    hl("@lsp.type.comment", { link = "@comment" })
    hl("@lsp.type.enum", { link = "@type" })
    hl("@lsp.type.enumMember", { link = "@constant.builtin" })
    hl("@lsp.type.interface", { link = "@type" })
    hl("@lsp.type.typeParameter", { link = "@type" })
    hl("@lsp.type.keyword", { link = "@keyword" })
    hl("@lsp.type.namespace", { link = "@module" })
    hl("@lsp.type.parameter", { link = "@variable.parameter" })
    hl("@lsp.type.property", { link = "@property" })
    hl("@lsp.type.variable", { link = "@variable" })
    hl("@lsp.type.macro", { link = "@function.macro" })
    hl("@lsp.type.method", { link = "@function.method" })
    hl("@lsp.type.number", { link = "@number" })
    hl("@lsp.type.generic", { link = "@text" })
    hl("@lsp.type.builtinType", { link = "@type.builtin" })
    hl("@lsp.typemod.method.defaultLibrary", { link = "@function" })
    hl("@lsp.typemod.function.defaultLibrary", { link = "@function" })
    hl("@lsp.typemod.operator.injected", { link = "@operator" })
    hl("@lsp.typemod.string.injected", { link = "@string" })
    hl("@lsp.typemod.variable.defaultLibrary", { link = "@variable.builtin" })
    hl("@lsp.typemod.variable.injected", { link = "@variable" })
    hl("@lsp.typemod.variable.static", { link = "@constant" })
    hl("TSAnnotation", colors.Fg)
    hl("TSAttribute", colors.Cyan)
    hl("TSBoolean", colors.Orange)
    hl("TSCharacter", colors.Orange)
    hl("TSComment", vim.tbl_extend("force", { fg = c.grey }, cfg.code_style.comments))
    hl(
        "TSConditional",
        vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords)
    )
    hl("TSConstant", colors.Orange)
    hl("TSConstBuiltin", colors.Orange)
    hl("TSConstMacro", colors.Orange)
    hl("TSConstructor", { fg = c.yellow, bold = true })
    hl("TSError", colors.Fg)
    hl("TSException", colors.Purple)
    hl("TSField", colors.Cyan)
    hl("TSFloat", colors.Orange)
    hl("TSFunction", vim.tbl_extend("force", { fg = c.blue }, cfg.code_style.functions))
    hl(
        "TSFuncBuiltin",
        vim.tbl_extend("force", { fg = c.cyan }, cfg.code_style.functions)
    )
    hl("TSFuncMacro", vim.tbl_extend("force", { fg = c.cyan }, cfg.code_style.functions))
    hl("TSInclude", colors.Purple)
    hl("TSKeyword", vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords))
    hl(
        "TSKeywordFunction",
        vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.functions)
    )
    hl(
        "TSKeywordOperator",
        vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords)
    )
    hl("TSLabel", colors.Red)
    hl("TSMethod", vim.tbl_extend("force", { fg = c.blue }, cfg.code_style.functions))
    hl("TSNamespace", colors.Yellow)
    hl("TSNone", colors.Fg)
    hl("TSNumber", colors.Orange)
    hl("TSOperator", colors.Fg)
    hl("TSParameter", colors.Red)
    hl("TSParameterReference", colors.Fg)
    hl("TSProperty", colors.Cyan)
    hl("TSPunctDelimiter", colors.LightGrey)
    hl("TSPunctBracket", colors.LightGrey)
    hl("TSPunctSpecial", colors.Red)
    hl("TSRepeat", vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords))
    hl("TSString", vim.tbl_extend("force", { fg = c.green }, cfg.code_style.strings))
    hl(
        "TSStringRegex",
        vim.tbl_extend("force", { fg = c.orange }, cfg.code_style.strings)
    )
    hl("TSStringEscape", vim.tbl_extend("force", { fg = c.red }, cfg.code_style.strings))
    hl("TSSymbol", colors.Cyan)
    hl("TSTag", colors.Purple)
    hl("TSTagDelimiter", colors.Purple)
    hl("TSText", colors.Fg)
    hl("TSStrong", { fg = c.fg, bold = true })
    hl("TSEmphasis", { fg = c.fg, italic = true })
    hl("TSUnderline", { fg = c.fg, underline = true })
    hl("TSStrike", { fg = c.fg, strikethrough = true })
    hl("TSTitle", { fg = c.orange, bold = true })
    hl("TSLiteral", colors.Green)
    hl("TSURI", { fg = c.cyan, underline = true })
    hl("TSMath", colors.Fg)
    hl("TSTextReference", colors.Blue)
    hl("TSEnvironment", colors.Fg)
    hl("TSEnvironmentName", colors.Fg)
    hl("TSNote", colors.Fg)
    hl("TSWarning", colors.Fg)
    hl("TSDanger", colors.Fg)
    hl("TSType", colors.Yellow)
    hl("TSTypeBuiltin", colors.Orange)
    hl("TSVariable", vim.tbl_extend("force", { fg = c.fg }, cfg.code_style.variables))
    hl(
        "TSVariableBuiltin",
        vim.tbl_extend("force", { fg = c.red }, cfg.code_style.variables)
    )

    local diagnostics_error_color = cfg.diagnostics.darker and c.dark_red or c.red
    local diagnostics_hint_color = cfg.diagnostics.darker and c.dark_purple or c.purple
    local diagnostics_warn_color = cfg.diagnostics.darker and c.dark_yellow or c.yellow
    local diagnostics_info_color = cfg.diagnostics.darker and c.dark_cyan or c.cyan

    hl("LspCxxHlGroupEnumConstant", colors.Orange)
    hl("LspCxxHlGroupMemberVariable", colors.Orange)
    hl("LspCxxHlGroupNamespace", colors.Blue)
    hl("LspCxxHlSkippedRegion", colors.Grey)
    hl("LspCxxHlSkippedRegionBeginEnd", colors.Red)

    hl("DiagnosticError", { fg = c.red })
    hl("DiagnosticHint", { fg = c.purple })
    hl("DiagnosticInfo", { fg = c.cyan })
    hl("DiagnosticWarn", { fg = c.yellow })

    hl("DiagnosticVirtualTextError", {
        bg = cfg.diagnostics.background
                and util_darken(diagnostics_error_color, 0.1, c.bg0)
            or c.none,
        fg = diagnostics_error_color,
    })
    hl("DiagnosticVirtualTextWarn", {
        bg = cfg.diagnostics.background
                and util_darken(diagnostics_warn_color, 0.1, c.bg0)
            or c.none,
        fg = diagnostics_warn_color,
    })
    hl("DiagnosticVirtualTextInfo", {
        bg = cfg.diagnostics.background
                and util_darken(diagnostics_info_color, 0.1, c.bg0)
            or c.none,
        fg = diagnostics_info_color,
    })
    hl("DiagnosticVirtualTextHint", {
        bg = cfg.diagnostics.background
                and util_darken(diagnostics_hint_color, 0.1, c.bg0)
            or c.none,
        fg = diagnostics_hint_color,
    })

    hl("DiagnosticUnderlineError", {
        undercurl = cfg.diagnostics.undercurl,
        underline = not cfg.diagnostics.undercurl,
        sp = c.red,
    })
    hl("DiagnosticUnderlineHint", {
        undercurl = cfg.diagnostics.undercurl,
        underline = not cfg.diagnostics.undercurl,
        sp = c.purple,
    })
    hl("DiagnosticUnderlineInfo", {
        undercurl = cfg.diagnostics.undercurl,
        underline = not cfg.diagnostics.undercurl,
        sp = c.blue,
    })
    hl("DiagnosticUnderlineWarn", {
        undercurl = cfg.diagnostics.undercurl,
        underline = not cfg.diagnostics.undercurl,
        sp = c.yellow,
    })

    hl("LspReferenceText", { bg = c.bg2 })
    hl("LspReferenceWrite", { bg = c.bg2 })
    hl("LspReferenceRead", { bg = c.bg2 })

    hl("LspCodeLens", vim.tbl_extend("force", { fg = c.grey }, cfg.code_style.comments))
    hl("LspCodeLensSeparator", { fg = c.grey })

    hl("LspDiagnosticsDefaultError", { link = "DiagnosticError" })
    hl("LspDiagnosticsDefaultHint", { link = "DiagnosticHint" })
    hl("LspDiagnosticsDefaultInformation", { link = "DiagnosticInfo" })
    hl("LspDiagnosticsDefaultWarning", { link = "DiagnosticWarn" })
    hl("LspDiagnosticsUnderlineError", { link = "DiagnosticUnderlineError" })
    hl("LspDiagnosticsUnderlineHint", { link = "DiagnosticUnderlineHint" })
    hl("LspDiagnosticsUnderlineInformation", { link = "DiagnosticUnderlineInfo" })
    hl("LspDiagnosticsUnderlineWarning", { link = "DiagnosticUnderlineWarn" })
    hl("LspDiagnosticsVirtualTextError", { link = "DiagnosticVirtualTextError" })
    hl("LspDiagnosticsVirtualTextWarning", { link = "DiagnosticVirtualTextWarn" })
    hl("LspDiagnosticsVirtualTextInformation", { link = "DiagnosticVirtualTextInfo" })
    hl("LspDiagnosticsVirtualTextHint", { link = "DiagnosticVirtualTextHint" })

    hl("ALEErrorSign", { link = "DiagnosticError" })
    hl("ALEInfoSign", { link = "DiagnosticInfo" })
    hl("ALEWarningSign", { link = "DiagnosticWarn" })

    hl("BufferCurrent", { bold = true })
    hl("BufferCurrentMod", { fg = c.orange, bold = true, italic = true })
    hl("BufferCurrentSign", { fg = c.purple })
    hl("BufferInactiveMod", { fg = c.light_grey, bg = c.bg1, italic = true })
    hl("BufferVisible", { fg = c.light_grey, bg = c.bg0 })
    hl("BufferVisibleMod", { fg = c.yellow, bg = c.bg0, italic = true })
    hl("BufferVisibleIndex", { fg = c.light_grey, bg = c.bg0 })
    hl("BufferVisibleSign", { fg = c.light_grey, bg = c.bg0 })
    hl("BufferVisibleTarget", { fg = c.light_grey, bg = c.bg0 })

    hl("CmpItemAbbr", colors.Fg)
    hl("CmpItemAbbrDeprecated", { fg = c.light_grey, strikethrough = true })
    hl("CmpItemAbbrMatch", colors.Cyan)
    hl("CmpItemAbbrMatchFuzzy", { fg = c.cyan, underline = true })
    hl("CmpItemMenu", colors.LightGrey)
    hl("CmpItemKind", { fg = c.purple, reverse = cfg.cmp_itemkind_reverse })

    hl("CocErrorSign", { link = "DiagnosticError" })
    hl("CocHintSign", { link = "DiagnosticHint" })
    hl("CocInfoSign", { link = "DiagnosticInfo" })
    hl("CocWarningSign", { link = "DiagnosticWarn" })

    hl("WhichKey", colors.Red)
    hl("WhichKeyDesc", colors.Blue)
    hl("WhichKeyGroup", colors.Orange)
    hl("WhichKeySeparator", colors.Green)

    hl("GitGutterAdd", { fg = c.green })
    hl("GitGutterChange", { fg = c.blue })
    hl("GitGutterDelete", { fg = c.red })

    hl("HopNextKey", { fg = c.red, bold = true })
    hl("HopNextKey1", { fg = c.cyan, bold = true })
    hl("HopNextKey2", { fg = util_darken(c.blue, 0.7) })
    hl("HopUnmatched", colors.Grey)

    hl("DiffviewFilePanelTitle", { fg = c.blue, bold = true })
    hl("DiffviewFilePanelCounter", { fg = c.purple, bold = true })
    hl("DiffviewFilePanelFileName", colors.Fg)
    hl("DiffviewNormal", { link = "Normal" })
    hl("DiffviewCursorLine", { link = "CursorLine" })
    hl("DiffviewVertSplit", { link = "VertSplit" })
    hl("DiffviewSignColumn", { link = "SignColumn" })
    hl("DiffviewStatusLine", { link = "StatusLine" })
    hl("DiffviewStatusLineNC", { link = "StatusLineNC" })
    hl("DiffviewEndOfBuffer", { link = "EndOfBuffer" })

    hl("DiffviewFilePanelRootPath", colors.Grey)
    hl("DiffviewFilePanelPath", colors.Grey)
    hl("DiffviewFilePanelInsertions", colors.Green)
    hl("DiffviewFilePanelDeletions", colors.Red)
    hl("DiffviewStatusAdded", colors.Green)
    hl("DiffviewStatusUntracked", colors.Blue)
    hl("DiffviewStatusModified", colors.Blue)
    hl("DiffviewStatusRenamed", colors.Blue)
    hl("DiffviewStatusCopied", colors.Blue)
    hl("DiffviewStatusTypeChange", colors.Blue)
    hl("DiffviewStatusUnmerged", colors.Blue)
    hl("DiffviewStatusUnknown", colors.Red)
    hl("DiffviewStatusDeleted", colors.Red)
    hl("DiffviewStatusBroken", colors.Red)

    hl("GitSignsAdd", colors.Green)
    hl("GitSignsAddLn", colors.Green)
    hl("GitSignsAddNr", colors.Green)
    hl("GitSignsChange", colors.Blue)
    hl("GitSignsChangeLn", colors.Blue)
    hl("GitSignsChangeNr", colors.Blue)
    hl("GitSignsDelete", colors.Red)
    hl("GitSignsDeleteLn", colors.Red)
    hl("GitSignsDeleteNr", colors.Red)

    hl("NeoTreeNormal", { fg = c.fg, bg = cfg.transparent and c.none or c.bg_d })
    hl("NeoTreeNormalNC", { fg = c.fg, bg = cfg.transparent and c.none or c.bg_d })
    hl("NeoTreeVertSplit", { fg = c.bg1, bg = cfg.transparent and c.none or c.bg1 })
    hl("NeoTreeWinSeparator", { fg = c.bg1, bg = cfg.transparent and c.none or c.bg1 })
    hl("NeoTreeEndOfBuffer", {
        fg = cfg.ending_tildes and c.bg2 or c.bg_d,
        bg = cfg.transparent and c.none or c.bg_d,
    })
    hl("NeoTreeRootName", { fg = c.orange, bold = true })
    hl("NeoTreeGitAdded", colors.Green)
    hl("NeoTreeGitDeleted", colors.Red)
    hl("NeoTreeGitModified", colors.Yellow)
    hl("NeoTreeGitConflict", { fg = c.red, bold = true, italic = true })
    hl("NeoTreeGitUntracked", { fg = c.red, italic = true })
    hl("NeoTreeIndentMarker", colors.Grey)
    hl("NeoTreeSymbolicLinkTarget", colors.Purple)

    hl("NeotestAdapterName", { fg = c.purple, bold = true })
    hl("NeotestDir", colors.Cyan)
    hl("NeotestExpandMarker", colors.Grey)
    hl("NeotestFailed", colors.Red)
    hl("NeotestFile", colors.Cyan)
    hl("NeotestFocused", { bold = true, italic = true })
    hl("NeotestIndent", colors.Grey)
    hl("NeotestMarked", { fg = c.orange, bold = true })
    hl("NeotestNamespace", colors.Blue)
    hl("NeotestPassed", colors.Green)
    hl("NeotestRunning", colors.Yellow)
    hl("NeotestWinSelect", { fg = c.cyan, bold = true })
    hl("NeotestSkipped", colors.LightGrey)
    hl("NeotestTarget", colors.Purple)
    hl("NeotestTest", colors.Fg)
    hl("NeotestUnknown", colors.LightGrey)

    hl("NvimTreeNormal", { fg = c.fg, bg = cfg.transparent and c.none or c.bg_d })
    hl("NvimTreeNormalFloat", { fg = c.fg, bg = cfg.transparent and c.none or c.bg_d })
    hl("NvimTreeVertSplit", { fg = c.bg_d, bg = cfg.transparent and c.none or c.bg_d })
    hl("NvimTreeEndOfBuffer", {
        fg = cfg.ending_tildes and c.bg2 or c.bg_d,
        bg = cfg.transparent and c.none or c.bg_d,
    })
    hl("NvimTreeRootFolder", { fg = c.orange, bold = true })
    hl("NvimTreeGitDirty", colors.Yellow)
    hl("NvimTreeGitNew", colors.Green)
    hl("NvimTreeGitDeleted", colors.Red)
    hl("NvimTreeSpecialFile", { fg = c.yellow, underline = true })
    hl("NvimTreeIndentMarker", colors.Fg)
    hl("NvimTreeImageFile", { fg = c.dark_purple })
    hl("NvimTreeSymlink", colors.Purple)
    hl("NvimTreeFolderName", colors.Blue)

    hl("TelescopeBorder", colors.Red)
    hl("TelescopePromptBorder", colors.Cyan)
    hl("TelescopeResultsBorder", colors.Cyan)
    hl("TelescopePreviewBorder", colors.Cyan)
    hl("TelescopeMatching", { fg = c.orange, bold = true })
    hl("TelescopePromptPrefix", colors.Green)
    hl("TelescopeSelection", { bg = c.bg2 })
    hl("TelescopeSelectionCaret", colors.Yellow)

    hl("DashboardShortCut", colors.Blue)
    hl("DashboardHeader", colors.Yellow)
    hl("DashboardCenter", colors.Cyan)
    hl("DashboardFooter", { fg = c.dark_red, italic = true })

    hl("FocusedSymbol", { fg = c.purple, bg = c.bg2, bold = true })
    hl("AerialLine", { fg = c.purple, bg = c.bg2, bold = true })

    hl("NavicText", { fg = c.fg })
    hl("NavicSeparator", { fg = c.light_grey })

    hl("rainbowcol1", colors.LightGrey)
    hl("rainbowcol2", colors.Yellow)
    hl("rainbowcol3", colors.Blue)
    hl("rainbowcol4", colors.Orange)
    hl("rainbowcol5", colors.Purple)
    hl("rainbowcol6", colors.Green)
    hl("rainbowcol7", colors.Red)

    hl("TSRainbowRed", colors.Red)
    hl("TSRainbowYellow", colors.Yellow)
    hl("TSRainbowBlue", colors.Blue)
    hl("TSRainbowOrange", colors.Orange)
    hl("TSRainbowGreen", colors.Green)
    hl("TSRainbowViolet", colors.Purple)
    hl("TSRainbowCyan", colors.Cyan)

    hl("RainbowDelimiterRed", colors.Red)
    hl("RainbowDelimiterYellow", colors.Yellow)
    hl("RainbowDelimiterBlue", colors.Blue)
    hl("RainbowDelimiterOrange", colors.Orange)
    hl("RainbowDelimiterGreen", colors.Green)
    hl("RainbowDelimiterViolet", colors.Purple)
    hl("RainbowDelimiterCyan", colors.Cyan)

    hl("IndentBlanklineIndent1", colors.Blue)
    hl("IndentBlanklineIndent2", colors.Green)
    hl("IndentBlanklineIndent3", colors.Cyan)
    hl("IndentBlanklineIndent4", colors.LightGrey)
    hl("IndentBlanklineIndent5", colors.Purple)
    hl("IndentBlanklineIndent6", colors.Red)
    hl("IndentBlanklineChar", { fg = c.bg1, nocombine = true })
    hl("IndentBlanklineContextChar", { fg = c.grey, nocombine = true })
    hl("IndentBlanklineContextStart", { sp = c.grey, underline = true })
    hl("IndentBlanklineContextSpaceChar", { nocombine = true })

    -- Ibl v3
    hl("IblIndent", { fg = c.bg1, nocombine = true })
    hl("IblWhitespace", { fg = c.grey, nocombine = true })
    hl("IblScope", { fg = c.grey, nocombine = true })

    hl("MiniAnimateCursor", { reverse = true, nocombine = true })
    hl("MiniAnimateNormalFloat", { link = "NormalFloat" })

    hl("MiniClueBorder", { link = "FloatBorder" })
    hl("MiniClueDescGroup", { link = "DiagnosticWarn" })
    hl("MiniClueDescSingle", { link = "NormalFloat" })
    hl("MiniClueNextKey", { link = "DiagnosticHint" })
    hl("MiniClueNextKeyWithPostkeys", { link = "DiagnosticError" })
    hl("MiniClueSeparator", { link = "DiagnosticInfo" })
    hl("MiniClueTitle", colors.Cyan)

    hl("MiniCompletionActiveParameter", { underline = true })

    hl("MiniCursorword", { underline = true })
    hl("MiniCursorwordCurrent", { underline = true })

    hl("MiniDepsChangeAdded", { link = "Added" })
    hl("MiniDepsChangeRemoved", { link = "Removed" })
    hl("MiniDepsHint", { link = "DiagnosticHint" })
    hl("MiniDepsInfo", { link = "DiagnosticInfo" })
    hl("MiniDepsMsgBreaking", { link = "DiagnosticWarn" })
    hl("MiniDepsPlaceholder", { link = "Comment" })
    hl("MiniDepsTitle", { link = "Title" })
    hl("MiniDepsTitleError", { link = "DiffDelete" })
    hl("MiniDepsTitleSame", { link = "DiffText" })
    hl("MiniDepsTitleUpdate", { link = "DiffAdd" })

    hl("MiniDiffSignAdd", colors.Green)
    hl("MiniDiffSignChange", colors.Blue)
    hl("MiniDiffSignDelete", colors.Red)
    hl("MiniDiffOverAdd", { link = "DiffAdd" })
    hl("MiniDiffOverChange", { link = "DiffText" })
    hl("MiniDiffOverContext", { link = "DiffChange" })
    hl("MiniDiffOverDelete", { link = "DiffDelete" })

    hl("MiniFilesBorder", { link = "FloatBorder" })
    hl("MiniFilesBorderModified", { link = "DiagnosticWarn" })
    hl("MiniFilesCursorLine", { bg = c.bg2 })
    hl("MiniFilesDirectory", { link = "Directory" })
    hl("MiniFilesFile", { fg = c.fg })
    hl("MiniFilesNormal", { link = "NormalFloat" })
    hl("MiniFilesTitle", colors.Cyan)
    hl("MiniFilesTitleFocused", { fg = c.cyan, bold = true })

    hl("MiniHipatternsFixme", { fg = c.bg0, bg = c.red, bold = true })
    hl("MiniHipatternsHack", { fg = c.bg0, bg = c.yellow, bold = true })
    hl("MiniHipatternsNote", { fg = c.bg0, bg = c.cyan, bold = true })
    hl("MiniHipatternsTodo", { fg = c.bg0, bg = c.purple, bold = true })

    hl("MiniIconsAzure", { fg = c.bg_blue })
    hl("MiniIconsBlue", { fg = c.blue })
    hl("MiniIconsCyan", { fg = c.cyan })
    hl("MiniIconsGreen", { fg = c.green })
    hl("MiniIconsGrey", { fg = c.fg })
    hl("MiniIconsOrange", { fg = c.orange })
    hl("MiniIconsPurple", { fg = c.purple })
    hl("MiniIconsRed", { fg = c.red })
    hl("MiniIconsYellow", { fg = c.yellow })

    hl("MiniIndentscopeSymbol", { fg = c.grey })
    hl("MiniIndentscopePrefix", { nocombine = true }) -- Make it invisible

    hl("MiniJump", { fg = c.purple, underline = true, sp = c.purple })

    hl("MiniJump2dDim", { fg = c.grey, nocombine = true })
    hl("MiniJump2dSpot", { fg = c.red, bold = true, nocombine = true })
    hl("MiniJump2dSpotAhead", { fg = c.cyan, bg = c.bg0, nocombine = true })
    hl("MiniJump2dSpotUnique", { fg = c.yellow, bold = true, nocombine = true })

    hl("MiniMapNormal", { link = "NormalFloat" })
    hl("MiniMapSymbolCount", { link = "Special" })
    hl("MiniMapSymbolLine", { link = "Title" })
    hl("MiniMapSymbolView", { link = "Delimiter" })

    hl("MiniNotifyBorder", { link = "FloatBorder" })
    hl("MiniNotifyNormal", { link = "NormalFloat" })
    hl("MiniNotifyTitle", colors.Cyan)

    hl("MiniOperatorsExchangeFrom", { link = "IncSearch" })

    hl("MiniPickBorder", { link = "FloatBorder" })
    hl("MiniPickBorderBusy", { link = "DiagnosticWarn" })
    hl("MiniPickBorderText", { fg = c.cyan, bold = true })
    hl("MiniPickIconDirectory", { link = "Directory" })
    hl("MiniPickIconFile", { link = "NormalFloat" })
    hl("MiniPickHeader", { link = "DiagnosticHint" })
    hl("MiniPickMatchCurrent", { bg = c.bg2 })
    hl("MiniPickMatchMarked", { bg = c.diff_text })
    hl("MiniPickMatchRanges", { link = "DiagnosticHint" })
    hl("MiniPickNormal", { link = "NormalFloat" })
    hl("MiniPickPreviewLine", { bg = c.bg2 })
    hl("MiniPickPreviewRegion", { link = "IncSearch" })
    hl("MiniPickPrompt", { link = "DiagnosticInfo" })

    hl("MiniStarterCurrent", { nocombine = true })
    hl("MiniStarterFooter", { fg = c.dark_red, italic = true })
    hl("MiniStarterHeader", colors.Yellow)
    hl(
        "MiniStarterInactive",
        vim.tbl_extend("force", { fg = c.grey }, cfg.code_style.comments)
    )
    hl("MiniStarterItem", { fg = c.fg, bg = cfg.transparent and c.none or c.bg0 })
    hl("MiniStarterItemBullet", { fg = c.grey })
    hl("MiniStarterItemPrefix", { fg = c.yellow })
    hl("MiniStarterSection", colors.LightGrey)
    hl("MiniStarterQuery", { fg = c.cyan })

    hl("MiniStatuslineDevinfo", { fg = c.fg, bg = c.bg2 })
    hl("MiniStatuslineFileinfo", { fg = c.fg, bg = c.bg2 })
    hl("MiniStatuslineFilename", { fg = c.grey, bg = c.bg1 })
    hl("MiniStatuslineInactive", { fg = c.grey, bg = c.bg0 })
    hl("MiniStatuslineModeCommand", { fg = c.bg0, bg = c.yellow, bold = true })
    hl("MiniStatuslineModeInsert", { fg = c.bg0, bg = c.blue, bold = true })
    hl("MiniStatuslineModeNormal", { fg = c.bg0, bg = c.green, bold = true })
    hl("MiniStatuslineModeOther", { fg = c.bg0, bg = c.cyan, bold = true })
    hl("MiniStatuslineModeReplace", { fg = c.bg0, bg = c.red, bold = true })
    hl("MiniStatuslineModeVisual", { fg = c.bg0, bg = c.purple, bold = true })

    hl("MiniSurround", { fg = c.bg0, bg = c.orange })

    hl("MiniTablineCurrent", { bold = true })
    hl("MiniTablineFill", { fg = c.grey, bg = c.bg1 })
    hl("MiniTablineHidden", { fg = c.fg, bg = c.bg1 })
    hl("MiniTablineModifiedCurrent", { fg = c.orange, bold = true, italic = true })
    hl("MiniTablineModifiedHidden", { fg = c.light_grey, bg = c.bg1, italic = true })
    hl("MiniTablineModifiedVisible", { fg = c.yellow, bg = c.bg0, italic = true })
    hl("MiniTablineTabpagesection", { fg = c.bg0, bg = c.bg_yellow })
    hl("MiniTablineVisible", { fg = c.light_grey, bg = c.bg0 })

    hl("MiniTestEmphasis", { bold = true })
    hl("MiniTestFail", { fg = c.red, bold = true })
    hl("MiniTestPass", { fg = c.green, bold = true })

    hl("MiniTrailspace", { bg = c.red })

    hl("illuminatedWord", { bg = c.bg2, bold = true })
    hl("illuminatedCurWord", { bg = c.bg2, bold = true })
    hl("IlluminatedWordText", { bg = c.bg2, bold = true })
    hl("IlluminatedWordRead", { bg = c.bg2, bold = true })
    hl("IlluminatedWordWrite", { bg = c.bg2, bold = true })

    hl("cInclude", colors.Blue)
    hl("cStorageClass", colors.Purple)
    hl("cTypedef", colors.Purple)
    hl("cDefine", colors.Cyan)
    hl("cTSInclude", colors.Blue)
    hl("cTSConstant", colors.Cyan)
    hl("cTSConstMacro", colors.Purple)
    hl("cTSOperator", colors.Purple)

    hl("cppStatement", { fg = c.purple, bold = true })
    hl("cppTSInclude", colors.Blue)
    hl("cppTSConstant", colors.Cyan)
    hl("cppTSConstMacro", colors.Purple)
    hl("cppTSOperator", colors.Purple)

    hl("markdownBlockquote", colors.Grey)
    hl("markdownBold", { fg = c.none, bold = true })
    hl("markdownBoldDelimiter", colors.Grey)
    hl("markdownCode", colors.Green)
    hl("markdownCodeBlock", colors.Green)
    hl("markdownCodeDelimiter", colors.Yellow)
    hl("markdownH1", { fg = c.red, bold = true })
    hl("markdownH2", { fg = c.purple, bold = true })
    hl("markdownH3", { fg = c.orange, bold = true })
    hl("markdownH4", { fg = c.red, bold = true })
    hl("markdownH5", { fg = c.purple, bold = true })
    hl("markdownH6", { fg = c.orange, bold = true })
    hl("markdownHeadingDelimiter", colors.Grey)
    hl("markdownHeadingRule", colors.Grey)
    hl("markdownId", colors.Yellow)
    hl("markdownIdDeclaration", colors.Red)
    hl("markdownItalic", { fg = c.none, italic = true })
    hl("markdownItalicDelimiter", { fg = c.grey, italic = true })
    hl("markdownLinkDelimiter", colors.Grey)
    hl("markdownLinkText", colors.Red)
    hl("markdownLinkTextDelimiter", colors.Grey)
    hl("markdownListMarker", colors.Red)
    hl("markdownOrderedListMarker", colors.Red)
    hl("markdownRule", colors.Purple)
    hl("markdownUrl", { fg = c.blue, underline = true })
    hl("markdownUrlDelimiter", colors.Grey)
    hl("markdownUrlTitleDelimiter", colors.Green)

    hl("phpFunctions", vim.tbl_extend("force", { fg = c.fg }, cfg.code_style.functions))
    hl("phpMethods", colors.Cyan)
    hl("phpStructure", colors.Purple)
    hl("phpOperator", colors.Purple)
    hl("phpMemberSelector", colors.Fg)
    hl(
        "phpVarSelector",
        vim.tbl_extend("force", { fg = c.orange }, cfg.code_style.variables)
    )
    hl(
        "phpIdentifier",
        vim.tbl_extend("force", { fg = c.orange }, cfg.code_style.variables)
    )
    hl("phpBoolean", colors.Cyan)
    hl("phpNumber", colors.Orange)
    hl("phpHereDoc", colors.Green)
    hl("phpNowDoc", colors.Green)
    hl(
        "phpSCKeyword",
        vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords)
    )
    hl(
        "phpFCKeyword",
        vim.tbl_extend("force", { fg = c.purple }, cfg.code_style.keywords)
    )
    hl("phpRegion", colors.Blue)

    hl("scalaNameDefinition", colors.Fg)
    hl("scalaInterpolationBoundary", colors.Purple)
    hl("scalaInterpolation", colors.Purple)
    hl("scalaTypeOperator", colors.Red)
    hl("scalaOperator", colors.Red)
    hl(
        "scalaKeywordModifier",
        vim.tbl_extend("force", { fg = c.red }, cfg.code_style.keywords)
    )

    hl("latexTSInclude", colors.Blue)
    hl(
        "latexTSFuncMacro",
        vim.tbl_extend("force", { fg = c.fg }, cfg.code_style.functions)
    )
    hl("latexTSEnvironment", { fg = c.cyan, bold = true })
    hl("latexTSEnvironmentName", colors.Yellow)
    hl("texCmdEnv", colors.Cyan)
    hl("texEnvArgName", colors.Yellow)
    hl("latexTSTitle", colors.Green)
    hl("latexTSType", colors.Blue)
    hl("latexTSMath", colors.Orange)
    hl("texMathZoneX", colors.Orange)
    hl("texMathZoneXX", colors.Orange)
    hl("texMathDelimZone", colors.LightGrey)
    hl("texMathDelim", colors.Purple)
    hl("texMathOper", colors.Red)
    hl("texCmd", colors.Purple)
    hl("texCmdPart", colors.Blue)
    hl("texCmdPackage", colors.Blue)
    hl("texPgfType", colors.Yellow)

    hl("vimOption", colors.Red)
    hl("vimSetEqual", colors.Yellow)
    hl("vimMap", colors.Purple)
    hl("vimMapModKey", colors.Orange)
    hl("vimNotation", colors.Red)
    hl("vimMapLhs", colors.Fg)
    hl("vimMapRhs", colors.Blue)
    hl("vimVar", vim.tbl_extend("force", { fg = c.fg }, cfg.code_style.variables))
    hl(
        "vimCommentTitle",
        vim.tbl_extend("force", { fg = c.light_grey }, cfg.code_style.comments)
    )

    hl("CmpItemKindDefault", { fg = c.purple, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindArray", { fg = c.yellow, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindBoolean", { fg = c.orange, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindClass", { fg = c.yellow, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindColor", { fg = c.green, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindConstant", { fg = c.orange, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindConstructor", { fg = c.blue, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindEnum", { fg = c.purple, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindEnumMember", { fg = c.yellow, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindEvent", { fg = c.yellow, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindField", { fg = c.purple, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindFile", { fg = c.blue, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindFolder", { fg = c.orange, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindFunction", { fg = c.blue, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindInterface", { fg = c.green, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindKey", { fg = c.cyan, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindKeyword", { fg = c.cyan, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindMethod", { fg = c.blue, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindModule", { fg = c.orange, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindNamespace", { fg = c.red, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindNull", { fg = c.grey, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindNumber", { fg = c.orange, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindObject", { fg = c.red, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindOperator", { fg = c.red, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindPackage", { fg = c.yellow, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindProperty", { fg = c.cyan, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindReference", { fg = c.orange, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindSnippet", { fg = c.red, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindString", { fg = c.green, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindStruct", { fg = c.purple, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindText", { fg = c.light_grey, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindTypeParameter", { fg = c.red, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindUnit", { fg = c.green, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindValue", { fg = c.orange, reverse = cfg.cmp_itemkind_reverse })
    hl("CmpItemKindVariable", { fg = c.purple, reverse = cfg.cmp_itemkind_reverse })
end

M:load()

cfg.overrides()
