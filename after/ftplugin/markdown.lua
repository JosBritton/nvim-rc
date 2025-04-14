if vim.bo.buftype == "" then -- only normal markdown buffers
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
    vim.opt_local.colorcolumn = "80" -- limit is 80 on markdownlint
end
