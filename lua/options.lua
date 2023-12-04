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

-- case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- render space for column even if it has no content (prevents text from shifting)
vim.wo.signcolumn = "yes"

-- decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.completeopt = "menuone,noselect"

vim.o.termguicolors = true

vim.o.wrap = false

vim.o.cursorline = true
vim.o.backspace = "indent,eol,start"

-- always center the cursor in the buffer
-- vim.o.scrolloff = 999
