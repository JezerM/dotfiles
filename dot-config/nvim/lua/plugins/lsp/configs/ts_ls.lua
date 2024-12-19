local options = require("plugins.lsp.options")

local node_modules_path = options.get_global_node_modules()
local vue_typescript_plugin_path = node_modules_path .. "/@vue/typescript-plugin/"

return {
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" },
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = vue_typescript_plugin_path,
                languages = { "javascript", "typescript", "vue" },
            },
        },
    },
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = true
    end
}
