require "lsp_signature".setup({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    floating_window = true,
    toggle_key = "<M-x>",
    handler_opts = {
        border = "rounded"
    }
})

-- vim: shiftwidth=4 tabstop=4
