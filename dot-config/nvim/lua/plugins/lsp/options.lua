local lspconfig = require("lspconfig")
local lspconfig_util = require("lspconfig.util")

require("lspconfig.ui.windows").default_options.border = "rounded"

local lib = {}

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        focusable = true,
        padding = 4,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = ""
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "TSDanger",
            [vim.diagnostic.severity.WARN] = "TSWarning",
            [vim.diagnostic.severity.INFO] = "TSTodo",
            [vim.diagnostic.severity.HINT] = "TSNote"
        },
    },
})

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

function lib.on_attach(client, bufnr)
    local cmd = vim.api.nvim_buf_create_user_command
    local default_opts = { buffer = bufnr, remap = false, silent = true }
    local function map(mode, key, command, opts)
        vim.keymap.set(mode, key, command, vim.tbl_extend("force", default_opts, opts))
    end

    require("lazy").load({ plugins = { "telescope.nvim" } })

    vim.lsp.buf.definition = require("telescope.builtin").lsp_definitions
    vim.lsp.buf.references = require("telescope.builtin").lsp_references
    vim.lsp.buf.implementation = require("telescope.builtin").lsp_implementations

    local hover = vim.lsp.buf.hover
    vim.lsp.buf.hover = function() hover(handler_override_config) end

    local signature_help = vim.lsp.buf.signature_help
    vim.lsp.buf.signature_help = function() signature_help(handler_override_config) end

    -- Only allow EFM and ESLint to format files
    local format = vim.lsp.buf.format
    vim.lsp.buf.format = function()
        format(
            {
                filter = function(c)
                    return c.name == "efm" or c.name == "eslint" or c.name == "lua_ls"
                end
            }
        )
    end

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
    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })
    map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
    map("n", "<Leader>vtf", function() toggle_format_on_save() end, { desc = "Toggle format on save" })
    map("n", "<Leader>vf", function() vim.lsp.buf.format({}) end, { desc = "Toggle format on save" })

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
    end

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

local node_modules_path = "/usr/lib/node_modules"
if (vim.fn.has("mac")) then
    node_modules_path = "/opt/homebrew/lib/node_modules"
end

local tsserver_path = node_modules_path .. "/typescript/lib/"

function lib.get_global_node_modules()
    return node_modules_path
end

function lib.get_typescript_server_path(root_dir)
    local project_root = lspconfig_util.find_node_modules_ancestor(root_dir)
    return project_root and (lspconfig_util.path.join(project_root, "node_modules", "typescript", "lib"))
        or tsserver_path
end

return lib
