require("startup").setup {
    theme = "default",
    options = {
        after = function()
            vim.opt.fillchars:append { eob = " " }
            vim.api.nvim_create_autocmd({"BufDelete"}, {
                buffer = vim.api.nvim_get_current_buf(),
                callback = function()
                    vim.opt.fillchars:append { eob = "~" }
                    return true
                end
            })
        end
    }
}

-- vim: shiftwidth=4 tabstop=4
