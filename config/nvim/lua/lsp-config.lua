local lspconfig = require "lspconfig"

--vim.lsp.set_log_level("debug")

local on_attach = function(client, bufnr)
    local cmd = vim.api.nvim_buf_create_user_command
    local buf_map = vim.api.nvim_buf_set_keymap

    vim.b.can_format = true

    cmd(bufnr, "LspDef", function() vim.lsp.buf.definition() end, {})
    cmd(bufnr, "LspFormatting", function() vim.lsp.buf.format() end, {})
    cmd(bufnr, "LspCodeAction", function() vim.lsp.buf.code_action() end, {})
    cmd(bufnr, "LspHover", function() vim.lsp.buf.hover() end, {})
    cmd(bufnr, "LspRename", function() vim.lsp.buf.rename() end, {})
    cmd(bufnr, "LspOrganize", function() lsp_organize_imports() end, {})
    cmd(bufnr, "LspRefs", function() vim.lsp.buf.references() end, {})
    cmd(bufnr, "LspTypeDef", function() vim.lsp.buf.type_definition() end, {})
    cmd(bufnr, "LspImplementation", function() vim.lsp.buf.implementation() end, {})
    cmd(bufnr, "LspDiagPrev", function() vim.lsp.buf.goto_prev() end, {})
    cmd(bufnr, "LspDiagNext", function() vim.lsp.buf.goto_next() end, {})
    cmd(bufnr, "LspDiagLine", function() vim.lsp.buf.open_float() end, {})
    cmd(bufnr, "LspSignatureHelp", function() vim.lsp.buf.signature_help() end, {})
    cmd(bufnr, "LspToggleFormat", toggle_format_on_save,
    {
        complete = function() return {"enable", "disable"} end,
        nargs = "?",
    })

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

    --if client.resolved_capabilities.hover then
        --vim.api.nvim_exec([[
              --augroup hover
                --autocmd! * <buffer>
                --autocmd CursorHold  <buffer> lua vim.lsp.buf.hover()
                --autocmd CursorHoldI <buffer> lua vim.lsp.buf.hover()
                --autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
              --augroup end
        --]], true)
    --end

    require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    --require "lsp_signature".on_attach()

    if client.server_capabilities.documentFormattingProvider then
        local LspAutocommands = vim.api.nvim_create_augroup("LspAutocommands", {})
        vim.api.nvim_create_autocmd({"BufWritePre"}, {
            group = LspAutocommands,
            desc = "Format on file save",
            callback = function()
                if not vim.b.can_format then return end
                vim.lsp.buf.format()
            end
        })
    end
end

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

_G.toggle_format_on_save = function(input)
    if input.args == "enable" then
        vim.b.can_format = true
    elseif input.args == "disable" then
        vim.b.can_format = false
    else
        vim.b.can_format = not vim.b.can_format
        print("Can format file on save:", vim.b.can_format)
    end
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
    cmd = { 'clangd' },
    capabilities = {
        offsetEncoding = "utf-8",
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}
lspconfig.pyright.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}
lspconfig.bashls.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.cssls.setup {
    cmd = {"vscode-css-language-server", "--stdio"},
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}
lspconfig.jsonls.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end,
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
        },
    },
}
lspconfig.vimls.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = false
        --on_attach(client)
    end
}
lspconfig.html.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end
}
lspconfig.yamlls.setup {
}

lspconfig.texlab.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end
}

local pid = vim.fn.getpid()
-- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
local omnisharp_bin = os.getenv("HOME") .. "/.local/bin/OmniSharpMono/OmniSharp.exe"

lspconfig.omnisharp.setup{
    cmd = { "mono", omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = false

        on_attach(client, bufnr)
        --local buf_map = vim.api.nvim_buf_set_keymap
        --buf_map(bufnr, "n", "K", ":LspHighlight<CR>", {silent = true})
    end
}

lspconfig.tsserver.setup {
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}
--lspconfig.vuels.setup {
    --on_attach = function(client, bufnr)
        --client.server_capabilities.documentFormattingProvider = false
        --client.server_capabilities.hoverProvider = true
        --on_attach(client, bufnr)
    --end
--}
local tsserver_path = "/usr/lib/node_modules/typescript/lib/tsserverlibrary.js"
if (vim.fn.has("mac")) then
    tsserver_path = "/opt/homebrew/lib/node_modules/typescript/lib/tsserverlibrary.js"
end

lspconfig.volar.setup {
    init_options = {
        typescript = {
            --serverPath = '/path/to/.npm/lib/node_modules/typescript/lib/tsserverlib.js'
            -- Alternative location if installed as root:
            serverPath = tsserver_path,
        }
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}
lspconfig.svelte.setup {
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.hover = true
        on_attach(client, bufnr)
    end
}
local filetypes = {
    html = "eslint",
    css = "eslint",
    javascript = "eslint",
    typescript = "eslint",
    typescriptreact = "eslint",
    vue = "eslint",
    python = "pylint",
    svelte = "eslint",
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
    },
    pylint = {
        sourceName = "pylint",
        command = "pylint",
        args = {
            '--output-format',
            'text',
            '--score',
            'no',
            '--msg-template',
            [['{line}:{column}:{category}:{msg} ({msg_id}:{symbol})']],
            '%file',
        },
        offsetColumn = 1,
        formatLines = 1,
        formatPattern = {
            [[^(\d+?):(\d+?):([a-z]+?):(.*)$]],
            { line = 1, column = 2, security = 3, message = { '[pylint] ', 4 } },
        },
        securities = {
            informational = 'hint',
            refactor = 'info',
            convention = 'info',
            warning = 'warning',
            error = 'error',
            fatal = 'error',
        },
        rootPatterns = { ".pylintrc", '.git', 'pyproject.toml', 'setup.py' },
    },
}
local formatters = {
    prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}},
    clang = {command = "clang-format", args = {"%filepath"}}
}
local formatFiletypes = {
    c = "clang",
    html = "prettier",
    css = "prettier",
    javascript = "prettier",
    typescript = "prettier",
    typescriptreact = "prettier",
    vue = "prettier",
    svelte = "prettier",
}
lspconfig.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = {
        "c", "html", "css", "javascript",
        "typescript", "typescriptreact",
        "vue", "python", "svelte"
    },
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

lspconfig.rust_analyzer.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}
--lspconfig.phpactor.setup {
    --on_attach = function(client, bufnr)
        --client.server_capabilities.documentFormattingProvider = true
        --client.server_capabilities.hoverProvider = true
        --on_attach(client, bufnr)
    --end
--}
lspconfig.phan.setup {
    cmd = { "phan", "-m", "json", "--no-color", "--no-progress-bar", "-x", "-u", "-S", "--language-server-on-stdin" },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end
}
lspconfig.jdtls.setup{
    cmd = { 'jdtls' },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end
}
--[[
   [lspconfig.kotlin_language_server.setup{
   [    on_attach = function(client, bufnr)
   [        client.resolved_capabilities.document_formatting = false
   [        client.resolved_capabilities.hover = false
   [        on_attach(client, bufnr)
   [    end,
   [}
   ]]
lspconfig.dockerls.setup{
    cmd = { 'docker-langserver', "--stdio" },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end
}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
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
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}

-- vim: shiftwidth=4 tabstop=4
