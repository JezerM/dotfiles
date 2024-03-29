local lspconfig = require "lspconfig"
local lspconfig_configs = require "lspconfig.configs"
local lspconfig_util = require "lspconfig.util"

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

local handler_override_config = {
    border = "rounded",
    style = "minimal",
    focusable = true,
}

local LspAutocommands = vim.api.nvim_create_augroup("LspAutocommands", {})

local function toggle_format_on_save(input)
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

local function on_attach(client, bufnr)
    local cmd = vim.api.nvim_buf_create_user_command
    local default_opts = { buffer = bufnr, remap = false, silent = true }
    local function map(mode, key, command, opts)
        vim.keymap.set(mode, key, command, vim.tbl_extend("force", default_opts, opts))
    end

    require("lazy").load({ plugins = { "telescope.nvim" } })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, handler_override_config)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help,
        handler_override_config)

    vim.lsp.buf.definition = require("telescope.builtin").lsp_definitions
    vim.lsp.buf.references = require("telescope.builtin").lsp_references
    vim.lsp.buf.implementation = require("telescope.builtin").lsp_implementations

    vim.b.can_format = true

    cmd(bufnr, "LspToggleFormat", function(input) toggle_format_on_save(input) end,
        {
            complete = function() return { "enable", "disable" } end,
            nargs = "?",
        })

    if client.server_capabilities.hoverProvider then
        map("n", "K", function() vim.lsp.buf.hover() end, { desc = "Hover symbol" })
    end
    map("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Show definition" })
    map("n", "gr", function() vim.lsp.buf.rename() end, { desc = "Rename symbol" })
    map("n", "ga", function() vim.lsp.buf.code_action() end, { desc = "Show code actions" })
    map("n", "<Leader>vr", function() vim.lsp.buf.references() end, { desc = "Show references" })
    map("n", "<Leader>a", function() vim.diagnostic.open_float() end, { desc = "Show diagnostics" })
    map("n", "[d", function() vim.diagnostic.goto_prev() end, { desc = "Previous diagnostic" })
    map("n", "]d", function() vim.diagnostic.goto_next() end, { desc = "Next diagnostic" })
    map("n", "<Leader>vtf", function() toggle_format_on_save() end, { desc = "Toggle format on save" })

    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd({ "BufWritePre" }, {
            group = LspAutocommands,
            buffer = bufnr,
            desc = ("Format on file save (" .. client.name .. ")"),
            callback = function()
                if not vim.b.can_format then return end
                vim.lsp.buf.format()
            end
        })
    end
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
    cmd = { "vscode-css-language-server", "--stdio" },
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
lspconfig.html.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}
lspconfig.yamlls.setup {}
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
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

local omnisharp_mono_bin = os.getenv("HOME") .. "/.local/bin/OmniSharpMono/OmniSharp.exe"
local omnisharp_net_bin = os.getenv("HOME") .. "/.local/bin/OmniSharp/OmniSharp.dll"

local omnisharp_bin = {}
if file_exists(omnisharp_net_bin) then
    omnisharp_bin = { "dotnet", omnisharp_net_bin }
elseif file_exists(omnisharp_mono_bin) then
    omnisharp_bin = { "mono", omnisharp_mono_bin }
end

lspconfig.omnisharp.setup {
    use_mono = true,
    cmd = vim.tbl_extend(
        "keep",
        omnisharp_bin,
        { "--languageserver", "--hostPID", tostring(pid) }
    ),
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = true

        on_attach(client, bufnr)
    end
}

lspconfig.tailwindcss.setup {}

lspconfig.tsserver.setup {
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}
local tsserver_path = "/usr/lib/node_modules/typescript/lib/tsserverlibrary.js"
if (vim.fn.has("mac")) then
    tsserver_path = "/opt/homebrew/lib/node_modules/typescript/lib/tsserverlibrary.js"
end

local function get_typescript_server_path(root_dir)
    local project_root = lspconfig_util.find_node_modules_ancestor(root_dir)
    return project_root and (lspconfig_util.path.join(project_root, "node_modules", "typescript", "lib"))
        or tsserver_path
end

lspconfig.volar.setup {
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
    init_options = {
        typescript = {
            tsdk = tsserver_path,
            -- Alternative location if installed as root:
            -- tsdk = '/usr/local/lib/node_modules/typescript/lib'
        }
    },
    on_new_config = function(new_config, new_root_dir)
        new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
    end,
}
lspconfig.svelte.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.hover = true
        on_attach(client, bufnr)
    end
}
local formatters = {
    prettier = { command = "prettier", args = { "--stdin-filepath", "%filepath" } },
    clang = { command = "clang-format", args = { "%filepath" } },
    phpcbf = { command = "phpcbf", args = { "-" }, isStdout = true, ignoreExitCode = true, }
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
    react = "prettier",
    svelte = "prettier",
    php = "phpcbf",
}
lspconfig.diagnosticls.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end,
    filetypes = {
        "c", "html", "css", "javascript",
        "less", "sass",
        "typescript", "typescriptreact",
        "vue", "react", "php",
    },
    init_options = {
        formatters = formatters,
        formatFiletypes = formatFiletypes
    }
}
lspconfig.eslint.setup {
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "astro" },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = false
        on_attach(client, bufnr)
    end
}
lspconfig.sqlls.setup {
    cmd = { "sql-language-server", "up", "--method", "stdio" },
    on_attach = on_attach,
}

lspconfig.rust_analyzer.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}
lspconfig.sourcekit.setup {
    cmd = { "/Library/Developer/CommandLineTools/usr/bin/sourcekit-lsp" },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
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
lspconfig.jdtls.setup {
    cmd = { "jdtls" },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}
lspconfig.kotlin_language_server.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.hover = false
        on_attach(client, bufnr)
    end,
}
lspconfig.dockerls.setup {
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
                globals = { "vim", "awesome" },
            },
            workspace = {
                checkThirdParty = false,
                -- Make the server aware of Neovim runtime files
                library = {
                    vim.env.VIMRUNTIME,
                    "/usr/share/awesome/lib/"
                }
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.hoverProvider = true
        on_attach(client, bufnr)
    end
}

-- vim: shiftwidth=4 tabstop=4
