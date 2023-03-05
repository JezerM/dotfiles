local custom_gruvbox = require('lualine.themes.gruvbox')

local function line_count()
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_line_count(buf)
    local y, x = unpack(vim.api.nvim_win_get_cursor(win))
    return ":" .. y .. "/" .. lines .. "☰  :" .. ( x + 1 )
end

local gruvbox_colors = {
    -- Background
    bg = "#282828",
    bg0 = "#282828",
    bg0_s = "#32302f",
    bg0_h = "#1d2021",
    bg1 = "#3c3836",
    bg2 = "#504945",
    bg3 = "#665c54",
    bg4 = "#7c6f64",

    -- Foreground
    fg = "#ebdbb2",
    fg0 = "#fbf1c7",
    fg1 = "#ebdbb2",
    fg2 = "#d5c4a1",
    fg3 = "#bdae93",
    fg4 = "#a89984",

    -- Grayer
    gray = "#928374",
    gray1 = "#a89984",
    gray2 = "#928374",

    -- Normal Colors
    red = "#cc241d",
    green = "#98971a",
    yellow = "#d79921",
    blue = "#458588",
    purple = "#b16286",
    aqua = "#689d6a",
    orange = "#d65d0e",

    -- Light colors
    light_red = "#fb4934",
    light_green = "#b8bb26",
    light_yellow = "#fabd2f",
    light_blue = "#83a598",
    light_purple = "#d3869b",
    light_aqua = "#8ec07c",
    light_orange = "#fe8019",
}

custom_gruvbox.command.a.bg = gruvbox_colors.aqua
custom_gruvbox.command.c = { bg = gruvbox_colors.bg1, fg = gruvbox_colors.gray1 }

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = ""},
        section_separators = { left = "\u{e0c6}", right = "\u{e0c7}"},
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { "filename", "lsp_progress" },
        lualine_x = { "filetype", "encoding", "fileformat" },
        lualine_y = { "progress", line_count },
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
        lualine_a = {{ "buffers" }},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "tabs" }
    }
}

-- vim: shiftwidth=4 tabstop=4
