return {
    cmd = { "docker-langserver", "--stdio" },
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = false
    end
}
