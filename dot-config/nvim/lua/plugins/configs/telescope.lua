local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")
local actions_layout = require("telescope.actions.layout")

local config = {
    defaults = {
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
        },
        winblend = 0,
        color_devicons = true,
        use_less = true,
        path_display = {},
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,

        mappings = {
            i = {
                --["<esc>"] = require'telescope.actions'.close,
                ["<M-p>"] = actions_layout.toggle_preview,
            },
        },
    },
    pickers = {
        find_files = {
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        }
    },
}

return config
-- vim: shiftwidth=4 tabstop=4
