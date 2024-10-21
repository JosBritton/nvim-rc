local id = vim.api.nvim_create_augroup("LazyUser", { clear = false })
vim.api.nvim_create_autocmd("BufEnter", {
    group = id,
    nested = true,
    callback = function(args)
        local res = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(args.buf))
        if res and res.type == "directory" then
            vim.api.nvim_del_augroup_by_id(id)
            vim.cmd("do User DirEnter")
            vim.api.nvim_exec_autocmds(
                args.event,
                { buffer = args.buf, data = args.data }
            )
        end
    end,
})
