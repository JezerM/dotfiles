return {
    cmd = { "vscode-css-language-server", "--stdio" },
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = true
    end
}
