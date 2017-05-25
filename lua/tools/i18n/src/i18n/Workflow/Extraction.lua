local Object = require "i18n.Object"

local Extraction = Object{}

function Extraction:initialize(fileSystem, operands)
    self.fileSystem = fileSystem
    self.operands = operands
end

function Extraction:run(path)
    local data = list.flatten(list.map(function(operand)
        return self:extract(operand)
    end, self.operands))

    data = table.indices(table.invert(data))
    data = table.sort(data)

    self.fileSystem:writeLines(path, data)
end

--  private  --

function Extraction:extract(operand)
    local data = list.flatten(list.map(function(path)
        return operand:extract(path)
    end, operand:getAllFiles()))

    return list.map(function(text)
        return operand:encode(text)
    end, data)
end

return Extraction
