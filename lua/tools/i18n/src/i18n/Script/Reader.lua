local lexers = require "lexers"
local utf8   = require "i18n.utf8"
local Object = require "i18n.Object"

local Reader = Object{}

function Reader:initialize(fs, path)
    self.fs = fs
    self.values = self:read(path)
end

function Reader:getAll()
    return self.values
end

--  private  --

function Reader:read(path)
    local s = self.fs:read(path)
    if s == nil then
        return {}
    end

    local tokens = lexers(s)
    if table.empty(tokens) then
        return {}
    end

    local data = {}
    for _, token in pairs(tokens) do
        local t, v = unpack(token)
        if t == "string" and utf8.check(v) then
            table.insert(data, v)
        end
    end
    return data
end

return Reader
