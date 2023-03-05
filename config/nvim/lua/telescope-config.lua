local telescope = require("telescope")

local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")
local actions_layout = require("telescope.actions.layout")

telescope.setup {
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
        file_sorter =  sorters.get_fuzzy_file,
        file_ignore_patterns = { },
        generic_sorter =  sorters.get_generic_fuzzy_sorter,
        winblend = 0,
        border = { },
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        use_less = true,
        path_display = { },
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = previewers.buffer_previewer_maker,

        mappings = {
            i = {
                --["<esc>"] = require'telescope.actions'.close,
                ["<M-p>"] = actions_layout.toggle_preview,
            },
        },
    },
    pickers = { },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown { }
        }
    },
}

require("telescope").load_extension("emoji")
require("telescope").load_extension("packer")
require("telescope").load_extension("ui-select")

-- vim: shiftwidth=4 tabstop=4
