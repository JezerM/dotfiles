return {
    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "ray-x/lsp_signature.nvim",
                opts = function() return require("plugins.configs.lsp-signature") end
            },
            "b0o/schemastore.nvim",
            "creativenull/efmls-configs-nvim",
        },
    },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-calc",
            "hrsh7th/cmp-cmdline",
            "f3fora/cmp-spell",
            -- "ray-x/cmp-treesitter",
            "quangnguyen30192/cmp-nvim-ultisnips",

            "onsails/lspkind-nvim",
            {
                "windwp/nvim-autopairs",
                opts = function() return require("plugins.configs.autopairs") end,
                config = function(_, opts)
                    require("nvim-autopairs").setup(opts)
                end
            },
        },
        opts = function() return require("plugins.configs.nvim-cmp") end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context",
            "rescript-lang/tree-sitter-rescript"
        },
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        event = "BufEnter",
        opts = function() return require("plugins.configs.treesitter") end,
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
        build = function()
            require("nvim-treesitter.install").update({ with_sync = false })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = true,
        opts = function() return require("plugins.configs.treesitter-context") end,
    },

    {
        'luckasRanarison/tailwind-tools.nvim',
        name = 'tailwind-tools',
        enabled = false,
        build = ':UpdateRemotePlugins',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-telescope/telescope.nvim', -- optional
            'neovim/nvim-lspconfig',         -- optional
        },
        opts = {
            server = {
                settings = {
                    includeLanguages = {
                        ['typescript.glimmer'] = 'javascript',
                    },
                },
            },
            extension = {
                queries = { 'typescript.glimmer' },
            },
            document_color = {
                inline_symbol = '󱓻 ',
            },
        },
    },

    -- Bigfiles
    "LunarVim/bigfile.nvim",

    -- Themes
    -- "morhetz/gruvbox"
    -- "ellisonleao/gruvbox.nvim",
    "sainnhe/gruvbox-material",
    -- "sainnhe/everforest",
    {
        "nkakouros-original/numbers.nvim",
        opts = function() return require("plugins.configs.numbers") end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "linrongbin16/lsp-progress.nvim",
        },
        opts = function() return require("plugins.configs.lualine") end,
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            show_modified = true,
            include_buftypes = { "", "acwrite" },
            exclude_filetypes = {}
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        opts = function() return require("plugins.configs.indent-blankline") end,
        config = function(_, opts)
            require("ibl").setup(opts)
        end
    },

    -- Lua colors
    {
        "NvChad/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = function() return require("plugins.configs.colorizer") end,
        config = function(_, opts)
            require("colorizer").setup(opts)
        end
    },

    -- Snippets
    "SirVer/ultisnips",
    "mattn/emmet-vim",

    -- Markdown
    {
        "OXY2DEV/markview.nvim",
        enabled = false,
        branch = "dev",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        opts = function() return require("plugins.configs.markview") end,
    },
    {
        "ellisonleao/glow.nvim",
        ft = "markdown",
    },
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        ft = "norg",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        opts = function() return require("plugins.configs.neorg") end,
    },

    -- LaTex
    {
        "lervag/vimtex",
        ft = "tex",
    },

    -- Git
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G" }
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = function() return require("plugins.configs.gitsigns") end,
    },
    {
        "sindrets/diffview.nvim",
    },

    -- Explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        enabled = false,
        keys = {
            { "|", "<Cmd>Neotree toggle<CR>", mode = "n", silent = true, }
        },
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        opts = function() return require("plugins.configs.neo-tree") end
    },
    {
        "stevearc/oil.nvim",
        keys = {
            { "|", "<Cmd>Oil<CR>", desc = "Open parent directory", silent = true, }
        },
        cmd = "Oil",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function() return require("plugins.configs.oil") end
    },
    {
        enabled = false,
        "refractalize/oil-git-status.nvim",
        dependencies = {
            "stevearc/oil.nvim",
        },
        config = true,
    },
    {
        "JezerM/oil-lsp-diagnostics.nvim",
        dependencies = {
            "stevearc/oil.nvim",
        },
        opts = {}
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        cmd = "Telescope",
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Find file" },
            { "<leader>fg", "<cmd>Telescope git_files<cr>",   desc = "Find git file" },
            { "<leader>fs", "<cmd>Telescope live_grep<cr>",   desc = "Live grep" },
            { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find word" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Find buffer" },
            { "<leader>ft", "<cmd>Telescope treesitter<cr>",  desc = "Find treesitter symbols" },
            { "<leader>fo", "<cmd>Telescope oldfiles<cr>",    desc = "Find old files" },
            { "<leader>f ", "<cmd>Telescope builtin<cr>",     desc = "Show telescope builtins" },
        },
        opts = function() return require("plugins.configs.telescope") end,
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            telescope.load_extension("ui-select")
        end,
    },

    -- Harpoon
    {
        "ThePrimeagen/harpoon",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>la", function() require("harpoon.mark").add_file() end,        desc = "Add file to Harpoon" },
            { "<leader>ll", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Toogle Harpoon menu" },
            { "<leader>lp", function() require("harpoon.ui").nav_next() end,          desc = "Navigate to next file" },
            { "<leader>lo", function() require("harpoon.ui").nav_prev() end,          desc = "Navigate to previous file" },
            { "<leader>l1", function() require("harpoon.ui").nav_file(1) end,         desc = "Navigate to file #1" },
            { "<leader>l2", function() require("harpoon.ui").nav_file(2) end,         desc = "Navigate to file #2" },
            { "<leader>l3", function() require("harpoon.ui").nav_file(3) end,         desc = "Navigate to file #3" },
            { "<leader>l4", function() require("harpoon.ui").nav_file(4) end,         desc = "Navigate to file #4" },
        }
    },

    -- Syntax
    {
        "folke/todo-comments.nvim",
        event = "BufReadPost",
        config = function(_)
            require("todo-comments").setup()
        end
    },
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        }
    },

    -- Utils
    {
        "folke/which-key.nvim",
        keys = function()
            local k = { "<leader>", "<c-r>", '"', "'", "`", "c", "v", "g" }
            return vim.tbl_map(function(v) return { v, mode = { "n", "v" } } end, k)
        end,
        cmd = "WhichKey",
        opts = function() return require("plugins.configs.which-key") end
    },
    {
        "andweeb/presence.nvim",
        event = "BufReadPost",
    },
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle undo-tre" }
        },
    },
    {
        "tummetott/reticle.nvim",
        opts = function() return require("plugins.configs.reticle") end
    },
    {
        "numToStr/Comment.nvim",
        keys = {
            { "<leader>cc", mode = "n",          desc = "Comment toggle current line" },
            { "<leader>cb", mode = "n",          desc = "Comment toggle current block" },
            { "<leader>c",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
            { "<leader>c",  mode = "x",          desc = "Comment toggle linewise (visual)" },
            { "<leader>b",  mode = { "n", "o" }, desc = "Comment toggle blockwise" },
            { "<leader>b",  mode = "x",          desc = "Comment toggle blockwise (visual)" },
        },
        opts = function() return require("plugins.configs.comment") end,
        config = function(_, opts)
            require("Comment").setup(opts)
        end,
    },
    "lambdalisue/suda.vim",
    "startup-nvim/startup.nvim",
}
-- vim: shiftwidth=4 tabstop=4
