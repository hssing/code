require "std"

local prototype = Object{}

function prototype:new(...)
    local instance = self{}
    instance:initialize(...)
    return instance
end

function prototype:initialize()
end

return prototype
