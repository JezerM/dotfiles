local options = require("plugins.lsp.options")

return {
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
    init_options = {
        typescript = {
            tsdk = "",
        }
    },
    on_new_config = function(new_config, new_root_dir)
        new_config.init_options.typescript.tsdk = options.get_typescript_server_path(new_root_dir)
    end,
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = true
    end
}
