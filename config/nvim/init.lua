local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("keymap-config")
require("options-config")

require("lazy").setup(
    "plugins",
    {
        ui = {
            border = "rounded"
        }
    }
)

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

vim.cmd "colorscheme gruvbox-material"

-- vim: shiftwidth=4 tabstop=4
