return {
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.hoverProvider = false
    end
}
