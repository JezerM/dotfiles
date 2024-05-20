vim.g.neo_tree_remove_legacy_commands = 1

local config = {
    sources = {
        "filesystem",
        "buffers",
        "git_status",
    },
    close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    default_source = "filesystem",

    enable_diagnostics = true,
    enable_git_status = true,
    enable_modified_markers = true, -- Show markers for files with unsaved changes.
    enable_refresh_on_write = true, -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.

    git_status_async = true,
    popup_border_style = "rounded",
    source_selector = {
        winbar = true,
        sources = {
            {
                source = "filesystem",
                display_name = " 󰉓 Files ",
            },
            {
                source = "buffers",
                display_name = " 󰈙 Buffers ",
            },
            {
                source = "git_status",
                display_name = " 󰊢 Git ",
            },
        },
        highlight_tab = "NeoTreeTabInactive",
        highlight_tab_active = "NeoTreeTabActive",
        highlight_background = "NeoTreeTabInactive",
        highlight_separator = "NeoTreeTabSeparatorInactive",
        highlight_separator_active = "NeoTreeTabSeparatorActive",
    },
    default_component_configs = {
        git_status = {
            symbols = {
                -- Change type
                added     = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
                modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
                deleted   = "✖", -- this can only be used in the git_status source
                renamed   = "󰁕", -- this can only be used in the git_status source
                -- Status type
                untracked = "",
                ignored   = "",
                unstaged  = "󰄱",
                staged    = "",
                conflict  = "",
            }
        },
        diagnostics = {
            symbols = {
                hint = "󰌶",
                info = "",
                warn = "",
                error = "",
            },
            highlights = {
                hint = "DiagnosticSignHint",
                info = "DiagnosticSignInfo",
                warn = "DiagnosticSignWarn",
                error = "DiagnosticSignError",
            },
        },
    }
}

return config
-- vim: shiftwidth=4 tabstop=4
