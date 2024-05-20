return {
    on_startup = {
        cursorline = true,
        cursorcolumn = true,
    },
    always_highlight_number = true,
    never = {
        cursorcolumn = {
            "neo-tree",
            "startup",
        },
        cursorline = {
            "startup"
        }
    },
}
-- vim: shiftwidth=4 tabstop=4
