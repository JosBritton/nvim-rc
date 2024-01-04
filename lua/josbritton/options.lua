local state = vim.fn.stdpath("state")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- modify formatoptions for all buffers
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        vim.opt.formatoptions:remove("o")
    end,
})

vim.opt.showcmd = false

-- hybrid line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"

-- prevent windows from changing
vim.opt.equalalways = false

-- use OS clipboard
vim.opt.clipboard = "unnamedplus"
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

-- render space for column even if it has no content (prevents text from shifting)
-- vim.opt.signcolumn = "yes"

-- decrease update time
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

vim.opt.hidden = true

vim.opt.completeopt = { "menuone", "noselect" }

vim.opt.termguicolors = true

vim.opt.wrap = false

-- vim.o.cursorline = true
vim.opt.backspace = { "indent", "eol", "start" }

vim.opt.scrolloff = 8

vim.opt.hlsearch = true
vim.opt.incsearch = true
