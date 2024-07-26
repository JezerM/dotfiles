local prettier = require("efmls-configs.formatters.prettier_d")
local phpcbf = require("efmls-configs.formatters.phpcbf")
local clang_format = require("efmls-configs.formatters.clang_format")

local languages = {
    c = { clang_format },
    html = { prettier },
    css = { prettier },
    less = { prettier },
    sass = { prettier },
    javascript = { prettier },
    typescript = { prettier },
    typescriptreact = { prettier },
    vue = { prettier },
    react = { prettier },
    svelte = { prettier },
    php = { phpcbf },
    markdown = { prettier },
}

return {
    filetypes = vim.tbl_keys(languages),
    settings = {
        rootMarkers = { ".git/" },
        languages = languages,
    },
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
    },
}
