require("nvim-treesitter.configs").setup {
    highlight = {
        enable = true,
    },
}

require("colorizer").setup({
    "*";
}, {
    RGGBBAA = true;
    RRGGBB = true;
    names = false;
    css = true;
})

require("gitsigns").setup {
    word_diff = false,
    current_line_blame = true,
}

require("todo-comments").setup { }

require("indent_blankline").setup {
    show_current_context = true,
    show_current_context_start = false,
    show_trailing_blankline_indent = false,
    use_treesitter = true,
    show_first_indent_level = false,
    char = "┆";
    context_char = "│"
}

require("numbers").setup {
    excluded_filetypes = {
        "neo-tree", "neo-tree-popup",
        "startup"
    }
}

require("startup").setup {
    theme = "default",
    options = {
        after = function()
            vim.opt.fillchars:append { eob = " " }
            vim.api.nvim_create_autocmd({"BufDelete"}, {
                buffer = vim.api.nvim_get_current_buf(),
                callback = function()
                    vim.opt.fillchars:append { eob = "~" }
                    return true
                end
            })
        end
    }
}

require("reticle").setup {
    always_highlight_number = true,
    never = {
        cursorcolumn = {
            "neo-tree",
            "startup",
        },
    },
}

require("incline").setup()

-- vim: shiftwidth=4 tabstop=4
