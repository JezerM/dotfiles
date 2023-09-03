return {
    -- LSP
    {
        "neovim/nvim-lspconfig",
        event = "BufEnter",
        dependencies = {
            {
                "ray-x/lsp_signature.nvim",
                opts = function() return require("plugins.configs.lsp-signature") end
            },
            "b0o/schemastore.nvim",
        }
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
            "ray-x/cmp-treesitter",
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
        },
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
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

    -- Themes
    --"morhetz/gruvbox"
    "ellisonleao/gruvbox.nvim",
    "sainnhe/gruvbox-material",
    "sainnhe/everforest",
    "nkakouros-original/numbers.nvim",
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "arkav/lualine-lsp-progress"
        }
    },
    {
        "b0o/incline.nvim",
        event = "BufReadPre",
        opts = function() return require("plugins.configs.incline") end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        opts = function() return require("plugins.configs.indent-blankline") end,
    },

    -- Lua colors
    {
        "norcalli/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = function() return require("plugins.configs.colorizer") end,
        config = function(_, opts)
            require("colorizer").setup(opts.filetypes, opts.options)
        end
    },

    -- Snippets
    "SirVer/ultisnips",
    "mattn/emmet-vim",

    -- Markdown
    {
        "ellisonleao/glow.nvim",
        ft = "markdown",
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = "cd app && npm install"
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

    -- Explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
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

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-lua/popup.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        cmd = "Telescope",
        keys = function()
            local builtin = require("telescope.builtin")
            return {
                { "<leader>ff", builtin.find_files, desc = "Find file" },
                { "<leader>fg", builtin.git_files, desc = "Find git file" },
                { "<leader>fs", builtin.live_grep, desc = "Search text" },
                { "<leader>fb", builtin.buffers, desc = "Find buffer" },
                { "<leader>ft", builtin.treesitter, desc = "Find treesitter symbols" },
                { "<leader>f ", builtin.builtin, desc = "Show telescope builtins" },
            }
        end,
        opts = function() return require("plugins.configs.telescope") end,
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
            telescope.load_extension("ui-select")
        end,
    },

    -- Syntax
    {
        "leafOfTree/vim-vue-plugin",
        ft = "vue"
    },
    --"sheerun/vim-polyglot",
    {
        "folke/todo-comments.nvim",
        event = "BufReadPost",
        config = function (_)
            require("todo-comments").setup()
        end
    },
    --"leafgarland/typescript-vim",
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        }
    },

    -- Utils
    {
        "folke/which-key.nvim",
        keys = { "<leader>", "<c-r>", '"', "'", "`", "c", "v", "g" },
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
            { "<leader>cc", mode = "n", desc = "Comment toggle current line" },
            { "<leader>cb", mode = "n", desc = "Comment toggle current block" },
            { "<leader>c", mode = { "n", "o" }, desc = "Comment toggle linewise" },
            { "<leader>c", mode = "x", desc = "Comment toggle linewise (visual)" },
            { "<leader>b", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
            { "<leader>b", mode = "x", desc = "Comment toggle blockwise (visual)" },
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
