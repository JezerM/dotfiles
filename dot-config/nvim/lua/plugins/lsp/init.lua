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
    "glint",
    "ruby_lsp",
    "rust_analyzer",
    "sourcekit",
    "sqlls",
    "svelte",
    "taplo",
    "texlab",
    "ts_ls",
    "rescriptls",
    "ruby_lsp",
    "tailwindcss",
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

vim.lsp.util.apply_text_document_edit = function(text_document_edit, index, offset_encoding)
    local text_document = text_document_edit.textDocument
    local bufnr = vim.uri_to_bufnr(text_document.uri)
    if offset_encoding == nil then
        vim.notify_once('apply_text_document_edit must be called with valid offset encoding', vim.log.levels.WARN)
    end

    vim.lsp.util.apply_text_edits(text_document_edit.edits, bufnr, offset_encoding)
end

return {}
