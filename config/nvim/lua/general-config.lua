require("nvim-treesitter.configs").setup {
    highlight = {
        enable = true,
    },
}

require("lspfuzzy").setup{}

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
-- vim: shiftwidth=4 tabstop=4
