local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.rescript = {
    install_info = {
        url = "https://github.com/rescript-lang/tree-sitter-rescript",
        branch = "main",
        files = { "src/parser.c", "src/scanner.c" },
        generate_requires_npm = false,
        requires_generate_from_grammar = true,
        use_makefile = true, -- macOS specific instruction
    },
}

return {
    modules = {},
    ensure_installed = { "lua", "c", "rust", "javascript", "typescript" },
    ignore_install = {},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    }
}
-- vim: shiftwidth=4 tabstop=4
