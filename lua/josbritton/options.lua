local state = vim.fn.stdpath("state")
local data = vim.fn.stdpath("data")

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- time in ms before keymap sequence is completed
vim.opt.timeoutlen = 1000

-- override formatoptions for all buffers
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions:remove("o")
    end,
})

-- ignore compiled files
vim.opt.wildignore:append({
    "*.o",
    "*~",
    "*.pyc",
    "*pycache*",
    "Cargo.lock",
    "Cargo.Bazel.lock",
})

vim.opt.spelllang = "en_us"
vim.opt.spellfile = data .. "/en.utf-8.add"

-- the command bar is just for commands and output
vim.opt.showcmd = false
vim.opt.showmode = false

-- prefer splitting bottom, right
vim.opt.splitbelow = true
vim.opt.splitright = true

-- prevent windows from changing
vim.opt.equalalways = false

-- global statusline
vim.opt.laststatus = 3

-- hybrid line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"

-- use and sync nvim clipboard to OS clipboard
--  schedule the setting after `UiEnter` because it can increase startup-time
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

-- https://github.com/neovim/neovim/issues/23650
--vim.g.netrw_banner = 0

vim.opt.breakindent = true

-- permanently lost if file is modified externally!
vim.opt.undofile = true
vim.opt.undodir = state .. "/undo//" -- def

vim.opt.backup = true
vim.opt.backupdir = state .. "/backup//"

vim.opt.swapfile = true

-- case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.smartindent = true
vim.opt.expandtab = true

-- default for when sleuth has NO reference
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

vim.opt.diffopt:append({
    "hiddenoff", -- no diff for hidden bufs
    "algorithm:minimal", -- spend extra cycles for the smallest possible diff
})

-- render space for column even if it has no content (prevents text from shifting)
vim.opt.signcolumn = "yes"

-- time in ms if nothing is typed to write to swap and trigger `CursorHold` autocmd event
-- (for example, showing completions on hover)
vim.opt.updatetime = 1000

vim.opt.completeopt = { "menuone", "noselect" }

vim.opt.termguicolors = true

vim.opt.wrap = false

-- vim.o.cursorline = true
vim.opt.backspace = { "indent", "eol", "start" }

vim.opt.scrolloff = 14

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.filetype.add({
    extension = {
        mdx = "mdx",
        conf = "conf",
    },
    filename = {
        [".yamllint"] = "yaml",
        ["Chart.lock"] = "yaml",
    },
    pattern = {
        ["${HOME}/%.config/yamllint/config"] = "yaml",
        ["${XDG_CONFIG_HOME}/yamllint/config"] = "yaml",
        ["${HOME}/%.config/git/config"] = "gitconfig",
        ["${XDG_CONFIG_HOME}/git/config"] = "gitconfig",
    },
})

-- remove builtin
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1

-- vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

vim.g.loaded_netrwFileHandlers = 1

local ok, _ = pcall(vim.cmd.colorscheme, "juliana")
if not ok then
    vim.cmd.colorscheme("default")
end

-- ---@type rustaceanvim.Opts
vim.g.rustaceanvim = {
    ---@type rustaceanvim.tools.Opts
    tools = {
        rustc = {
            default_edition = "2021",
        },
        executor = "quickfix",
    },
    ---@type rustaceanvim.lsp.ClientOpts
    server = {
        on_attach = function(_client, bufnr)
            -- vim.keymap.set("n", "<leader>a", function()
            --     vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
            --     -- or vim.lsp.buf.codeAction() if you don't want grouping.
            -- end, { silent = true, buffer = bufnr })
            vim.keymap.set(
                "n",
                "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
                function()
                    vim.cmd.RustLsp({ "hover", "actions" })
                end,
                { silent = true, buffer = bufnr }
            )
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end,
        load_vscode_settings = false,
        default_settings = {
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
