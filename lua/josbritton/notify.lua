---@overload fun(msg: string|string[])
local M = setmetatable({}, {
    __call = function(t, ...)
        return t.notify(...)
    end,
})

M.meta = {
    desc = "Utility functions to work with Neovim's `vim.notify`",
}

---@param msg string|string[]
function M.notify(msg, opts)
    opts = opts or {}
    local notify = vim[opts.once and "notify_once" or "notify"] --[[@as fun(...)]]
    notify = vim.in_fast_event() and vim.schedule_wrap(notify) or notify
    msg = type(msg) == "table" and table.concat(msg, "\n") or msg --[[@as string]]
    msg = vim.trim(msg)
    opts.title = opts.title or "Notification"
    return notify(msg, opts.level, opts)
end

---@param msg string|string[]
function M.warn(msg, opts)
    return M.notify(
        msg,
        vim.tbl_extend("keep", { level = vim.log.levels.WARN }, opts or {})
    )
end

---@param msg string|string[]
function M.info(msg, opts)
    return M.notify(
        msg,
        vim.tbl_extend("keep", { level = vim.log.levels.INFO }, opts or {})
    )
end

---@param msg string|string[]
function M.error(msg, opts)
    return M.notify(
        msg,
        vim.tbl_extend("keep", { level = vim.log.levels.ERROR }, opts or {})
    )
end

return M
