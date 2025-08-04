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
        color_devicons = true,
        path_display = { "filename_first", truncate = 2 },
        dynamic_preview_title = true,
        -- wrap_results = true,
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

vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    callback = function(args)
        if args.data.filetype ~= "help" then
            vim.wo.number = true
            vim.wo.wrap = true
        elseif args.data.bufname:match("*.csv") then
            vim.wo.wrap = false
        end
    end,
})

return config
-- vim: shiftwidth=4 tabstop=4
