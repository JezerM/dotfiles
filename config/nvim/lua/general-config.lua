vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

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
        cursorline = {
            "startup"
        }
    },
}

require("incline").setup {
    hide = {
        cursorline = true,
    }
}

require("treesitter-context").setup {
    enable = true,

}

require("neorg").setup {
    load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
                workspaces = {
                    notes = "~/notes",
                },
            },
        },
        ["core.presenter"] = {
            config = {
                zen_mode = "truezen"
            }
        },
    },
}

-- vim: shiftwidth=4 tabstop=4
