local pl = {}
pl.path = require "pl.path"

local utility = {}

utility.getAppDir = function()
    return pl.path.dirname(arg[0])
end

utility.getBinPath = function(name)
    return pl.path.join(utility.getAppDir(), "bin", name)
end

utility.string = {}

utility.string.quote = function(s)
    return string.gsub(string.format("%q", s), "\n", "n")
end

utility.string.unquote = function(s)
    return loadstring("return " .. s)()
end

return utility
