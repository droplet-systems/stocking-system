-- Log.lua
-- Nicklaus_s
-- Jan 30, 2022

return function(Content: string)
    if not Content then return end

    warn(string.format('[droplet] [Stocking System] [%s]\n\n%s', debug.info(2, 's'), Content))
end