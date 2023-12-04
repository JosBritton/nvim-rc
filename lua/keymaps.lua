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

vim.keymap.set("n", "<leader>pv",
    --  vim.cmd.Ex,
    "<Cmd>echo 'Use fuzzy finder with <C-p> instead.'<CR>",
    { desc = "Open Netrw" }
)

vim.keymap.set({ "c", "i" }, "<C-BS>", "<C-S-W>", { noremap = true, desc = "Delete word" })
vim.keymap.set({ "c", "i" }, "<C-h>", "<C-S-W>", { noremap = true, desc = "Delete word" })

vim.keymap.set("n", "<Esc>", "<Cmd>noh<CR>", { noremap = true, desc = "Clear highlighting" })

--vim.keymap.set("n", "cy", ""*y", { desc = "Yank to OS clipboard" })
--vim.keymap.set("n", "cp", ""*p", { desc = "Paste from OS clipboard" })

-- center buffer on search result navigation
vim.keymap.set("n", "n", "nzz", { noremap = true })
vim.keymap.set("n", "N", "Nzz", { noremap = true })
vim.keymap.set("n", "*", "*zz", { noremap = true })
vim.keymap.set("n", "#", "#zz", { noremap = true })
vim.keymap.set("n", "g*", "g*zz", { noremap = true })
vim.keymap.set("n", "g#", "g#zz", { noremap = true })

-- center cursor on first result from scroll
vim.keymap.set("c", "<CR>", function()
    return string.find(vim.fn.getcmdtype(), "[/?]") and "<CR>zz" or "<CR>"
end, { expr = true, noremap = true })
