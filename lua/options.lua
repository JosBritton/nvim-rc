-- must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- hybrid line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- enable mouse mode
-- vim.o.mouse = "a"

-- use OS clipboard
vim.o.clipboard = "unnamedplus"

vim.o.breakindent = true

-- persist undo history (permanently lost if file is modified externally!)
vim.o.undofile = true
vim.o.backup = false
vim.o.swapfile = true

-- case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.smartindent = true
vim.o.expandtab = true

-- render space for column even if it has no content (prevents text from shifting)
vim.wo.signcolumn = "yes"

-- decrease update time
vim.o.updatetime = 50
vim.o.timeoutlen = 300

vim.o.completeopt = "menuone,noselect"

vim.o.termguicolors = true

vim.o.wrap = false

vim.o.cursorline = true
vim.o.backspace = "indent,eol,start"

-- always center the cursor in the buffer
-- vim.o.scrolloff = 999

vim.o.scrolloff = 8

vim.o.hlsearch = true
vim.o.incsearch = true

vim.o.colorcolumn = "100"
