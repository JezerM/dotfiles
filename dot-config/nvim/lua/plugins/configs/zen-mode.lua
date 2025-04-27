vim.api.nvim_create_augroup('ZenModeFix', { clear = true })
vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    group = 'ZenModeFix',
    callback = function() require('zen-mode').close() end,
})

return {
    plugins = {
        options = {
            enabled = true,
            ruler = false,
            showcmd = false,
            laststatus = 0, -- turn off the statusline in zen mode
        },
        tmux = { enabled = true },
    }
}
