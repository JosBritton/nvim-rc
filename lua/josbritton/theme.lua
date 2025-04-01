local ok, _ = pcall(vim.cmd.colorscheme, "juliana")
if not ok then
    vim.cmd.colorscheme("default")
end
