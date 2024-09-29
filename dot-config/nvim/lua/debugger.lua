local dap = require("dap")

dap.adapters.firefox = {
    type = "executable",
    command = "node",
    args = { os.getenv("HOME") .. "/Desktop/NodeJS/vscode-firefox-debug/dist/adapter.bundle.js" },
}

dap.adapters.lldb = {
    type = "executable",
    command = "lldb-dap", -- adjust as needed, must be absolute path
    name = "lldb"
}

dap.configurations.typescript = {
    name = "Debug with Firefox",
    type = "firefox",
    request = "launch",
    reAttach = true,
    url = "http://localhost:3000",
    webRoot = "${workspaceFolder}",
    firefoxExecutable = "/Applications/Firefox.app/Contents/MacOS/firefox-bin"
}

dap.configurations.javascript = {
    dap.configurations.typescript,
}

dap.configurations.cpp = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        args = function()
            local input = vim.fn.input("Arguments: ", "file")
            return vim.split(input, ",")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
    }
}

vim.api.nvim_set_keymap("n", "<F5>", ":DapContinue<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<F10>", ":DapStepOver<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<F11>", ":DapStepInto<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<F12>", ":DapStepOut<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<Leader>bt", ":DapToggleBreakpoint<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<Leader>B",
    "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<Leader>dr", ":DapToggleRepl<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<Leader>dl", "<cmd>lua require'dap'.run_last()<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<F6>", ":DapTerminate<CR>", { silent = true })

-- vim: shiftwidth=4 tabstop=4
