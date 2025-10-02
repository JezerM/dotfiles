local presets = require("markview.presets")

return {
    preview = {
        modes = { "i", "n", "no", "c" },
        hybrid_modes = { "i", "n" },
        linewise_hybrid_mode = true,
        debounce = 0,
    },
    markdown = {
        headings = presets.headings.glow,
        tables = presets.tables.rounded,
    },
}
