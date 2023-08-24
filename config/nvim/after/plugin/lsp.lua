local lspconfig = require "lspconfig"

require("lspconfig.ui.windows").default_options.border = "rounded"

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        focusable = true,
        padding = 4,
    }
})

--vim.lsp.set_log_level("debug")

local on_attach = function(client, bufnr)
    local cmd = vim.api.nvim_buf_create_user_command
    local opts = { buffer = bufnr, remap = false, silent = true }

    vim.b.can_format = true

    cmd(bufnr, "LspToggleFormat", function(input) toggle_format_on_save(input) end,
    {
        complete = function() return {"enable", "disable"} end,
        nargs = "?",
    })

    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "ga", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<Leader>vr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<Leader>a", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<Leader>vtf", function() toggle_format_on_save() end, opts)

    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

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

local handler_override_config = {
    border = "rounded",
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, handler_override_config)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, handler_override_config)

function toggle_format_on_save(input)
    if input ~= nil and input.args ~= nil then
        if input.args == "enable" then
            vim.b.can_format = true
        elseif input.args == "disable" then
            vim.b.can_format = false
        end
    end

    vim.b.can_format = not vim.b.can_format
    print("Can format file on save:", vim.b.can_format)
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

lspconfig.clangd.setup {
    cmd = { "clangd" },
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
            schemas = require("schemastore").json.schemas(),
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
lspconfig.yamlls.setup { }
lspconfig.taplo.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}

lspconfig.texlab.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end
}

local pid = vim.fn.getpid()

local function file_exists(name)
   local f = io.open(name,"r")
   if f ~= nil then io.close(f) return true else return false end
end

local omnisharp_mono_bin = os.getenv("HOME") .. "/.local/bin/OmniSharpMono/OmniSharp.exe"
local omnisharp_net_bin = os.getenv("HOME") .. "/.local/bin/OmniSharp/OmniSharp.dll"

local omnisharp_bin = { }
if file_exists(omnisharp_net_bin) then
    omnisharp_bin = { "dotnet", omnisharp_net_bin }
elseif file_exists(omnisharp_mono_bin) then
    omnisharp_bin = { "mono", omnisharp_mono_bin }
end

lspconfig.omnisharp.setup{
    use_mono = true,
    cmd = merge_table(
        omnisharp_bin,
        { "--languageserver", "--hostPID", tostring(pid) }
    ),
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = true

        on_attach(client, bufnr)
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
        },
        languageFeatures = {
            implementation = true, -- new in @volar/vue-language-server v0.33
            references = true,
            definition = true,
            typeDefinition = true,
            callHierarchy = true,
            hover = true,
            rename = true,
            renameFileRefactoring = true,
            signatureHelp = true,
            codeAction = true,
            workspaceSymbol = true,
            completion = {
                defaultTagNameCase = "both",
                defaultAttrNameCase = "kebabCase",
                getDocumentNameCasesRequest = false,
                getDocumentSelectionRequest = false,
            },
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
        client.server_capabilities.document_formatting = false
        client.server_capabilities.hover = true
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
            "--output-format",
            "text",
            "--score",
            "no",
            "--msg-template",
            [['{line}:{column}:{category}:{msg} ({msg_id}:{symbol})']],
            "%file",
        },
        offsetColumn = 1,
        formatLines = 1,
        formatPattern = {
            [[^(\d+?):(\d+?):([a-z]+?):(.*)$]],
            { line = 1, column = 2, security = 3, message = { "[pylint] ", 4 } },
        },
        securities = {
            informational = "hint",
            refactor = "info",
            convention = "info",
            warning = "warning",
            error = "error",
            fatal = "error",
        },
        rootPatterns = { ".pylintrc", ".git", "pyproject.toml", "setup.py" },
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
    less = "prettier",
    sass = "prettier",
    javascript = "prettier",
    typescript = "prettier",
    typescriptreact = "prettier",
    vue = "prettier",
    svelte = "prettier",
    php = "prettier",
}
lspconfig.diagnosticls.setup {
    on_attach = on_attach,
    filetypes = {
        "c", "html", "css", "javascript",
        "less", "sass",
        "typescript", "typescriptreact",
        "vue", "python", "svelte", "php",
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
lspconfig.gdscript.setup {
    filetypes = { "gd", "gdscript", "gdscript3" },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.hoverProvider = true
        vim.api.nvim_buf_set_option(bufnr, "tabstop", 4)
        vim.api.nvim_buf_set_option(bufnr, "shiftwidth", 4)
        on_attach(client, bufnr)
    end
}
lspconfig.phpactor.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}
lspconfig.jdtls.setup{
    cmd = { "jdtls" },
    settings = {
        java = {
            signatureHelp = { enabled = true }
        }
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}
--[[
   [lspconfig.kotlin_language_server.setup{
   [    on_attach = function(client, bufnr)
   [        client.server_capabilities.document_formatting = false
   [        client.server_capabilities.hover = false
   [        on_attach(client, bufnr)
   [    end,
   [}
   ]]
lspconfig.dockerls.setup{
    cmd = { "docker-langserver", "--stdio" },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end
}

lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {"vim", "awesome"},
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
