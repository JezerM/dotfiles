local function line_count()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_line_count(buf)
    local y, x = unpack(vim.api.nvim_win_get_cursor(win))
    return ":" .. y .. "/" .. lines .. "☰  :" .. (x + 1)
end

require("lsp-progress").setup {}

vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = "LspProgressStatusUpdated",
    callback = require("lualine").refresh,
})

return {
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = {
            {
                "filename",
                path = 1,
            },
            require("lsp-progress").progress,
        },
        lualine_x = {
            {
                "filetype",
                colored = true,
                icon_only = false,
                icon = { align = "left" },
            },
            "encoding",
            "fileformat"
        },
        lualine_y = { line_count },
        lualine_z = {
            {
                "diagnostics",
                diagnostics_color = {
                    -- Same values as the general color option can be used here.
                    error = "DiagnosticError", -- Changes diagnostics' error color.
                    warn  = "DiagnosticWarn",  -- Changes diagnostics' warn color.
                    info  = "DiagnosticInfo",  -- Changes diagnostics' info color.
                    hint  = "DiagnosticHint",  -- Changes diagnostics' hint color.
                },
                colored = false,
            }
        }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { line_count },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = { "buffers" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "tabs" }
    }
}

-- vim: shiftwidth=4 tabstop=4
