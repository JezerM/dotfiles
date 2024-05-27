local path = require("plenary.path")

local pid = vim.fn.getpid()

local omnisharp_mono_bin = path:new(os.getenv("HOME") .. "/.local/bin/OmniSharpMono/OmniSharp.exe")
local omnisharp_net_bin = path:new(os.getenv("HOME") .. "/.local/bin/OmniSharp/OmniSharp.dll")

local omnisharp_bin = {}
if omnisharp_net_bin:exists() then
    omnisharp_bin = { "dotnet", omnisharp_net_bin:__tostring() }
elseif omnisharp_mono_bin:exists() then
    omnisharp_bin = { "mono", omnisharp_mono_bin:__tostring() }
end

return {
    use_mono = true,
    cmd = vim.tbl_extend(
        "keep",
        omnisharp_bin,
        { "--languageserver", "--hostPID", tostring(pid) }
    ),
}
