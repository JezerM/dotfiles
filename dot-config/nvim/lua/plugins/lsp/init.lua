local lspconfig = require("lspconfig")
local options = require("plugins.lsp.options")

local function apply_on_attach(table)
    local on_attach = table.on_attach

    table.on_attach = function(client, bufnr)
        if on_attach ~= nil then
            on_attach(client, bufnr)
        end
        options.on_attach(client, bufnr)
    end
end

local language_servers = {
    "bashls",
    "clangd",
    "cssls",
    "dockerls",
    "efm", -- Diagnostics/formatter
    "eslint",
    "gdscript",
    "asm_lsp",
    "html",
    "jdtls",
    "jsonls",
    "lemminx",
    "kotlin_language_server",
    "phpactor",
    "pyright",
    "lua_ls",
    "rust_analyzer",
    "sourcekit",
    "sqlls",
    "svelte",
    "taplo",
    "texlab",
    "tsserver",
    "rescriptls",
    "ruby_lsp",
    "tailwindcss",
    "volar",
    "yamlls",
}

for _, lsp in ipairs(language_servers) do
    local ok, config = pcall(require, "plugins.lsp.configs." .. lsp)
    if not ok then
        config = {}
    end

    apply_on_attach(config)
    lspconfig[lsp].setup(config)
end

return {}
