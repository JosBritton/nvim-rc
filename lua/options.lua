-- set highlight on search
vim.o.hlsearch = true

-- hybrid line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- enable mouse mode
-- vim.o.mouse = "a"

-- use OS clipboard
vim.o.clipboard = "unnamedplus"

-- enable break indent
vim.o.breakindent = true

-- save undo history
vim.o.undofile = true

-- case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
vim.o.termguicolors = true

-- vim: ts=2 sts=2 sw=2 et
