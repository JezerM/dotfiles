local presets = require("markview.presets")

return {
    headings = presets.headings.glow_labels,
    hybrid_modes = { "n" },
    tables = {
        enable = true,
        use_virt_lines = true,
    },
    callbacks = {
        on_enable = function(_, win)
            -- vim.wo[win].conceallevel = 2;
            -- You need to add the short name of the modes where you want everything under the cursor be concealed.
            -- E.g. "nc" will make it conceal under the cursor on normal & command mode. On the other hand, "" will make it never conceal anything under the cursor.
            -- vim.wo[win].concealcursor = "";
        end
    }
}
