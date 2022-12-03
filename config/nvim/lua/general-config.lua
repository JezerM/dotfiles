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
    word_diff = true,
    current_line_blame = true,
}

require("todo-comments").setup { }
