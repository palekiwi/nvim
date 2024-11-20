local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local clipboard = function()
    return vim.fn.getreg("+") .. "";
end

local hex_to_char = function(x)
    return string.char(tonumber(x, 16))
end

local unescape = function(url)
    return url:gsub("%%(%x%x)", hex_to_char)
end

local paste_url = function()
    return unescape(clipboard())
end

local get_date = function()
    return os.date('%Y-%m-%d %a')
end

return {
    s("url", { f(paste_url) }),
    s("journal", fmt(
        [[
        [{}](journal/{}.md)
        ]],
        {
            f(function() return os.date('%Y-%m-%d %a') end),
            f(function() return os.date('%Y/%m/%d') end)
        }
    ))
}
