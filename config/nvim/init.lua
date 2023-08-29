-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

require("packer").startup(function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"
    use "dstein64/vim-startuptime"

    -- Lua
    use {
        "neovim/nvim-lspconfig",
        requires = {
            "ray-x/lsp_signature.nvim",
            "b0o/schemastore.nvim",
        }
    }

    -- Completion
    use {
        "hrsh7th/nvim-cmp",
        requires = {
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
    }
    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function() require("nvim-treesitter.install").update({ with_sync = false }) end,
    }

    -- Themes
    --use "morhetz/gruvbox"
    use "ellisonleao/gruvbox.nvim"
    use "sainnhe/gruvbox-material"
    use "sainnhe/everforest"
    use "lukas-reineke/indent-blankline.nvim"
    use "nkakouros-original/numbers.nvim"
    use {
        "nvim-lualine/lualine.nvim",
        requires = {
            "nvim-tree/nvim-web-devicons",
            "arkav/lualine-lsp-progress"
        }
    }
    use "b0o/incline.nvim"
    use "nvim-treesitter/nvim-treesitter-context"

    -- Lua colors
    use "folke/lsp-colors.nvim"
    use "norcalli/nvim-colorizer.lua"
    use "uga-rosa/ccc.nvim"

    -- Snippets
    use "SirVer/ultisnips"
    use "mattn/emmet-vim"

    -- Markdown
    use { "iamcco/markdown-preview.nvim", run = "cd app && npm install" }
    use { "ellisonleao/glow.nvim" }
    use {
        "nvim-neorg/neorg",
        run = ":Neorg sync-parsers",
        requires = "nvim-lua/plenary.nvim",
    }

    -- LaTex
    use "lervag/vimtex"

    -- Git
    --use "airblade/vim-gitgutter"
    use "tpope/vim-fugitive"
    use "lewis6991/gitsigns.nvim"

    -- Explorer
    use {
        "nvim-neo-tree/neo-tree.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    }

    -- Telescope
    use "nvim-lua/popup.nvim"
    use {
        "nvim-telescope/telescope.nvim",
        requires = { {"nvim-lua/plenary.nvim"} }
    }
    use "nvim-telescope/telescope-packer.nvim"
    use "nvim-telescope/telescope-ui-select.nvim"

    -- Syntax
    use "leafOfTree/vim-vue-plugin"
    --use "sheerun/vim-polyglot"
    use "folke/todo-comments.nvim"
    --use "leafgarland/typescript-vim"
    use {
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
    }

    -- Utils
    use "folke/which-key.nvim"
    use "andweeb/presence.nvim"
    use "mbbill/undotree"
    use "lambdalisue/suda.vim"
    use "scrooloose/nerdcommenter"
    use "startup-nvim/startup.nvim"
    use "tummetott/reticle.nvim"

end)

local gruvbox_material_custom_group = vim.api.nvim_create_augroup("GruvboxMaterialCustom", {})

-- Links highlight groups to some predefined gruvbox-material highlight groups
local function gruvbox_material_custom()
    vim.api.nvim_set_hl(0, "TelescopeSelection", { link = "Visual" })
    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { link = "Red" })
    vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { link = "BlueBold" })
    vim.api.nvim_set_hl(0, "TelescopePromptTitle", { link = "BlueBold" })
    vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { link = "BlueBold" })
    vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { link = "BlueBold" })

    vim.api.nvim_set_hl(0, "CursorLineNr", { link = "YellowSign" })
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "Grey" })
    vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
    vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "Grey" })
    vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Folded" })

    vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { link = "Red" })
    vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { link = "Yellow" })
    vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { link = "Blue" })
    vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { link = "Green" })
end

vim.api.nvim_create_autocmd({"ColorScheme"}, {
  group = gruvbox_material_custom_group,
  pattern = "gruvbox-material",
  callback = gruvbox_material_custom
})

-- Restore cursor position
vim.cmd[[
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
]]

require("keymap-config")
require("options-config")

vim.cmd "colorscheme gruvbox-material"

-- vim: shiftwidth=4 tabstop=4
