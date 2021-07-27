return {
    Lua = {
        runtime = {
            version = "LuaJIT",
            path = {
                "./?.lua",
                "/usr/share/luajit-2.1.0-beta3/?.lua",
                "/usr/local/share/lua/5.1/?.lua",
                "/usr/local/share/lua/5.1/?/init.lua",
                "/usr/share/lua/5.1/?.lua",
                "/usr/share/lua/5.1/?/init.lua",
                "lua/?.lua",
                "lua/?/init.lua",
            },
        },
        diagnostics = {
            globals = {"awesome"}
        },
        workspace = {
            library = {
                ["/usr/share/awesome/lib/"] = true,
            }
        }
    }
}
