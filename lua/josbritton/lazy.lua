local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end

---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("LazyUser", {}),
    callback = function(args)
        local res = vim.loop.fs_stat(vim.api.nvim_buf_get_name(args.buf))
        if res and res.type == "directory" then
            vim.cmd("do User DirEnter")
        end
    end
})

require("lazy").setup("josbritton.plugins", {
    install = {
        colorscheme = { "juliana" }
    },
    checker = {
        enabled = true,
        notify = false
    },
    change_detection = {
        notify = false
    },
})
