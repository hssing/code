local Object = require "i18n.Object"
local Reader = require "i18n.Layout.Reader"

local Operand = Object{}

function Operand:initialize(fileSystem)
    self.fileSystem = fileSystem
end

function Operand:getAllFiles()
    local directory = self.fileSystem:getLocalPath("../../../ccb")
    return self.fileSystem:getAllFiles(directory, ".ccb")
end

function Operand:extract(path)
    return Reader:new(self.fileSystem, path):getAll()
end

return Operand
