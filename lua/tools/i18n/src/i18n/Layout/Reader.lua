require "luaxml"

local utf8   = require "i18n.utf8"
local Object = require "i18n.Object"

local Reader = Object{}

function Reader:initialize(fileSystem, path)
    self.fileSystem = fileSystem
    self.data = self:read(path)
end

function Reader:getAll()
    return self.data
end

--  private  --

function Reader:read(path)
    local function collect(node, strings)
        if type(node) == "string" then
            if utf8.check(node) then
                table.insert(strings, node)
            end
        end
        if type(node) == "table" then
            for _, child in ipairs(node) do
                collect(child, strings)
            end
        end
        return strings
    end
    return collect(xml.eval(self.fileSystem:read(path)), {})
end

return Reader
