return {
    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "ray-x/lsp_signature.nvim",
            "b0o/schemastore.nvim",
        }
    },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
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
            "windwp/nvim-autopairs",
        }
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = false })
        end,
    },

    -- Themes
    --"morhetz/gruvbox"
    "ellisonleao/gruvbox.nvim",
    "sainnhe/gruvbox-material",
    "sainnhe/everforest",
    "lukas-reineke/indent-blankline.nvim",
    "nkakouros-original/numbers.nvim",
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "arkav/lualine-lsp-progress"
        }
    },
    "b0o/incline.nvim",
    "nvim-treesitter/nvim-treesitter-context",

    -- Lua colors
    "norcalli/nvim-colorizer.lua",
    "uga-rosa/ccc.nvim",

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
        }
    },

    -- LaTex
    {
        "lervag/vimtex",
        ft = "tex",
    },

    -- Git
    "tpope/vim-fugitive",
    "lewis6991/gitsigns.nvim",

    -- Explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
    },

    -- Telescope
    "nvim-lua/popup.nvim",
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },
    "nvim-telescope/telescope-ui-select.nvim",

    -- Syntax
    {
        "leafOfTree/vim-vue-plugin",
        ft = "vue"
    },
    --"sheerun/vim-polyglot",
    "folke/todo-comments.nvim",
    --"leafgarland/typescript-vim",
    {
        "folke/trouble.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        }
    },

    -- Utils
    "folke/which-key.nvim",
    "andweeb/presence.nvim",
    "mbbill/undotree",
    "lambdalisue/suda.vim",
    "scrooloose/nerdcommenter",
    "startup-nvim/startup.nvim",
    "tummetott/reticle.nvim",
}
-- vim: shiftwidth=4 tabstop=4
