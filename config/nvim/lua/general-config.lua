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

require('gitsigns').setup()
