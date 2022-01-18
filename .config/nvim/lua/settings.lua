local lspconfig = require "lspconfig"

local on_attach = function(client, bufnr)
    local buf_map = vim.api.nvim_buf_set_keymap
    vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
    vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
    vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
    vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
    vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
    vim.cmd("command! LspOrganize lua lsp_organize_imports()")
    vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
    vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
    vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
    vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
    vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
    vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
    vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")

    buf_map(bufnr, "n", "gd", ":LspDef<CR>", {silent = true})
    buf_map(bufnr, "n", "gr", ":LspRename<CR>", {silent = true})
    buf_map(bufnr, "n", "gR", ":LspRefs<CR>", {silent = true})
    buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>", {silent = true})
    buf_map(bufnr, "n", "K", ":LspHover<CR>", {silent = true})
    buf_map(bufnr, "n", "gs", ":LspOrganize<CR>", {silent = true})
    buf_map(bufnr, "n", "gN", ":LspDiagPrev<CR>", {silent = true})
    buf_map(bufnr, "n", "gn", ":LspDiagNext<CR>", {silent = true})
    buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>", {silent = true})
    buf_map(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>", {silent = true})
    buf_map(bufnr, "n", "gl", "<cmd> LspSignatureHelp<CR>", {silent = true})
    buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>", {silent = true})

    if client.resolved_capabilities.hover then
        vim.api.nvim_exec([[
              augroup hover
                autocmd! * <buffer>
                autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
              augroup end
        ]], true)
    end

    require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    --require "lsp_signature".on_attach()

    if client.resolved_capabilities.document_formatting then
            vim.api.nvim_exec([[
             augroup LspAutocommands
                 autocmd! * <buffer>
                 autocmd BufWritePost <buffer> LspFormatting
             augroup END
             ]], true)
        end
end
local format_async = function(err, result, ctx, _)
  if err ~=nil or result == nil then return end
    if not vim.api.nvim_buf_get_option(ctx.bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, ctx.bufnr)
        vim.fn.winrestview(view)
        vim.api.nvim_buf_call(ctx.bufnr, function()
            vim.api.nvim_command("noautocmd :update")
        end)
    end
end

vim.lsp.handlers["textDocument/formatting"] = format_async
vim.lsp.buf.code_action = require("telescope.builtin").lsp_code_actions
vim.lsp.buf.references = require("telescope.builtin").lsp_references
vim.lsp.buf.implementation = require("telescope.builtin").lsp_implementations

_G.lsp_organize_imports = function()
    local params = {
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
    }
    vim.lsp.buf.execute_command(params)
  end

_G.dump = function(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

local function merge_table(...)
    local ret = {}
    for i = 1, select("#", ...) do
        local t = select(i, ...)
        if t then
            for k, v in pairs(t) do
                if type(k) == "number" then
                    table.insert(ret, v)
                else
                    ret[k] = v
                end
            end
        end
    end
    return ret
end

require "lsp_signature".setup({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    floating_window = true,
    toggle_key = "<M-x>",
    handler_opts = {
        border = "single"
    }
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

lspconfig.clangd.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.hover = true
        on_attach(client)
    end
}
lspconfig.pyright.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.hover = true
        on_attach(client)
    end
}
lspconfig.bashls.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.hover = false
        on_attach(client)
    end
}
require("nvim-treesitter.configs").setup {
    highlight = {
        enable = true,
    },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.cssls.setup {
    cmd = {"vscode-css-language-server", "--stdio"},
    capabilities = capabilities,
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.hover = true
        on_attach(client)
    end
}
lspconfig.jsonls.setup {
    capabilities = capabilities,
    on_attach = function(client)
        client.resolved_capabilities.hover = false
        on_attach(client)
    end,
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
        },
    },
}
lspconfig.vimls.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.hover = false
        --on_attach(client)
    end
}
lspconfig.html.setup {
    capabilities = capabilities,
}
lspconfig.yamlls.setup {
}

lspconfig.texlab.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.hover = false
        on_attach(client)
    end
}

require("lspfuzzy").setup{}

require("colorizer").setup({
    "*";
}, {
    RGGBBAA = true;
    RRGGBB = true;
    names = false;
    css = true;
})

lspconfig.tsserver.setup {
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.hover = true
        on_attach(client)
    end
}
lspconfig.vuels.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.hover = true
        on_attach(client)
    end
}
local filetypes = {
    html = "eslint",
    css = "eslint",
    javascript = "eslint",
    typescript = "eslint",
    typescriptreact = "eslint",
    vue = "eslint",
}
local linters = {
    eslint = {
        sourceName = "eslint",
        command = "eslint_d",
        rootPatterns = {".eslintrc.js", "package.json"},
        debounce = 100,
        args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
        parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "${message} [${ruleId}]",
            security = "severity"
        },
        securities = {[2] = "error", [1] = "warning"}
    }
}
local formatters = {
    prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}}
}
local formatFiletypes = {
    html = "prettier",
    css = "prettier",
    javascript = "prettier",
    typescript = "prettier",
    typescriptreact = "prettier",
    vue = "prettier"
}
lspconfig.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = vim.tbl_keys(filetypes),
    init_options = {
        filetypes = filetypes,
        linters = linters,
        formatters = formatters,
        formatFiletypes = formatFiletypes
    }
}
lspconfig.sqlls.setup{
    cmd = {"sql-language-server", "up", "--method", "stdio"};
    on_attach = on_attach,
}

lspconfig.jdtls.setup{
    cmd = { 'jdtls' },
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.hover = false
        on_attach(client)
    end
}
lspconfig.dockerls.setup{
    cmd = { 'docker-langserver', "--stdio" },
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.hover = false
        on_attach(client)
    end
}

local system_name
if vim.fn.has("mac") == 1 then
    system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
else
    print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = "/home/jezer/Descargas/lua-language-server"
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
    settings = {
        Lua = {
        runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path,
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim', "awesome"},
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            library = merge_table(
                    vim.api.nvim_get_runtime_file("", true),
                    {
                        "/usr/share/awesome/lib/"
                    }
                ),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
            enable = false,
        },
        },
    },
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.hover = true
        on_attach(client)
    end
}

-- vim: shiftwidth=4 tabstop=4
