return {
    filetypes = { "gd", "gdscript", "gdscript3" },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.hoverProvider = true
        vim.api.nvim_set_option_value("tabstop", 4, { buf = bufnr })
        vim.api.nvim_set_option_value("shiftwidth", 4, { buf = bufnr })
    end
}
