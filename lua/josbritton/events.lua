-- setup detection and action for large files
local id = vim.api.nvim_create_augroup("BigFilePreload", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    group = id,
    once = true,
    callback = function(_ev)
        -- detect very large files and assign a unique filetype
        vim.filetype.add({
            pattern = {
                [".*"] = {
                    function(path, buf)
                        if not path or not buf or vim.bo[buf].filetype == "bigfile" then
                            return
                        end
                        if path ~= vim.api.nvim_buf_get_name(buf) then
                            return
                        end
                        local size = vim.fn.getfsize(path)
                        if size <= 0 then
                            return
                        end

                        local bigfile_size = 1.5 * 1024 * 1024 -- 1.5MB
                        if size > bigfile_size then
                            return "bigfile"
                        end
                        -- average line length (useful for minified files)
                        local bigfile_line_length = 1000
                        local lines = vim.api.nvim_buf_line_count(buf)
                        return (size - lines) / lines > bigfile_line_length and "bigfile"
                            or nil
                    end,
                },
            },
        })

        local id = vim.api.nvim_create_augroup("BigFile", { clear = true })
        vim.api.nvim_create_autocmd({ "FileType" }, {
            group = id,
            pattern = "bigfile",
            callback = function(ev)
                local path =
                    vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ev.buf), ":p:~:.")

                -- notify as warning
                local notify = vim["notify"] --[[@as fun(...)]]
                notify = vim.in_fast_event() and vim.schedule_wrap(notify) or notify
                local msg = table.concat({
                    ("Big file detected `%s`."):format(path),
                    "Some Neovim features have been **disabled**.",
                }, "\n")
                msg = vim.trim(msg)
                notify(msg, vim.log.levels.WARN, { title = "Big File" })

                vim.api.nvim_buf_call(ev.buf, function()
                    -- disable auto-parenthesis match plugin
                    if vim.fn.exists(":NoMatchParen") ~= 0 then
                        vim.cmd([[NoMatchParen]])
                    end

                    vim.wo[0].foldmethod = "manual"
                    vim.wo[0].statuscolumn = ""
                    vim.wo[0].conceallevel = 0

                    -- enable normal syntax
                    local ft = vim.filetype.match({ buf = ev.buf }) or ""
                    vim.schedule(function()
                        if vim.api.nvim_buf_is_valid(ev.buf) then
                            vim.bo[ev.buf].syntax = ft
                        end
                    end)
                end)
            end,
        })
    end,
})

local id = vim.api.nvim_create_augroup("LazyUser", { clear = false })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = id,
    nested = true,
    callback = function(ev)
        local res = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(ev.buf))
        if res and res.type == "directory" then
            vim.api.nvim_del_augroup_by_id(id)
            vim.cmd("do User DirEnter")
            vim.api.nvim_exec_autocmds(ev.event, { buffer = ev.buf, data = ev.data })
        end
    end,
})

-- show file immediately before loading plugins
local id = vim.api.nvim_create_augroup("QuickFile", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = id,
    once = true,
    callback = function(ev)
        if vim.v.vim_did_enter == 1 then
            return
        end

        -- try to guess the filetype (may change later on during startup)
        local ft = vim.filetype.match({ buf = ev.buf })
        if not ft then
            return
        end

        -- Add treesitter highlights and fallback to syntax
        local lang = vim.treesitter.language.get_lang(ft)

        -- disable treesitter for some langs
        if lang == "latex" then
            lang = nil
        end

        if not (lang and pcall(vim.treesitter.start, ev.buf, lang)) then
            vim.bo[ev.buf].syntax = ft
        end

        -- trigger early redraw
        vim.cmd([[redraw]])
    end,
})
