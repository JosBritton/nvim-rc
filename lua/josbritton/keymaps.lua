vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    pattern = "*",
})

-- vim.keymap.set("n", "<leader>pv",
--     vim.cmd.Ex,
--     { desc = "Open Netrw" }
-- )

vim.keymap.set({ "c", "i" }, "<C-BS>", "<C-S-W>", { noremap = true, desc = "Delete word" })
vim.keymap.set({ "c", "i" }, "<C-h>", "<C-S-W>", { noremap = true, desc = "Delete word" })

vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { noremap = true, desc = "Clear highlighting" })

--vim.keymap.set("n", "cy", ""*y", { desc = "Yank to OS clipboard" })
--vim.keymap.set("n", "cp", ""*p", { desc = "Paste from OS clipboard" })

-- center buffer on search result navigation
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })

-- vim.keymap.set("n", "n", "nzz", { noremap = true })
-- vim.keymap.set("n", "N", "Nzz", { noremap = true })
vim.keymap.set("n", "*", "*zz", { noremap = true })
vim.keymap.set("n", "#", "#zz", { noremap = true })
vim.keymap.set("n", "g*", "g*zz", { noremap = true })
vim.keymap.set("n", "g#", "g#zz", { noremap = true })

-- center cursor on first result from scroll
vim.keymap.set("c", "<CR>", function()
    return string.find(vim.fn.getcmdtype(), "[/?]") and "<CR>zz" or "<CR>"
end, { expr = true, noremap = true })

-- center buffer on `ctrl + d/u`
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })

-- keep cursor in place with `J`
vim.keymap.set("n", "J", "mzJ`z")

-- move lines
vim.keymap.set("n", "<A-j>", "<Cmd>m .+1<CR>==", { noremap = true, desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<Cmd>m .-2<CR>==", { noremap = true, desc = "Move line up" })
vim.keymap.set("i", "<A-j>", "<Esc><Cmd>m .+1<CR>==gi", { noremap = true, desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<Esc><Cmd>m .-2<CR>==gi", { noremap = true, desc = "Move line up" })
vim.keymap.set("v", "<A-j>", "<Cmd>m '>+1<CR>gv=gv", { noremap = true, desc = "Move line down" })
vim.keymap.set("v", "<A-k>", "<Cmd>m '>-2<CR>gv=gv", { noremap = true, desc = "Move line up" })

-- vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste to void reg" })

vim.keymap.set("n", "Q", "<Nop>")

vim.keymap.set("n", "<C-f>", "<Cmd>silent !tmux neww switchproj<CR>")
vim.keymap.set("n", "<C-Space>", "<Cmd>silent !scratchtmux<CR>")

-- vim.keymap.set("n", "<C-k>", "<Cmd>cnext<CR>zz", { desc = "Quickfix nav next"})
-- vim.keymap.set("n", "<C-j>", "<Cmd>cprev<CR>zz", { desc = "Quickfix nav previous"})
-- vim.keymap.set("n", "<leader>k", "<Cmd>lnext<CR>zz", { desc = "Location list nav next"})
-- vim.keymap.set("n", "<leader>j", "<Cmd>lprev<CR>zz", { desc = "Location list nav previous"})

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Find and replace the word under the cursor" })

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make the current file executable" })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, { desc = "Source current file" })
