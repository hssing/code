local Operand    = require "i18n.Script.Operand"
local Extraction = require "i18n.Script.Operand.Extraction"

local super    = Operand
local Revising = Operand{}

Revising.escapes = table.invert(Extraction.escapes)

function Revising:initialize(fileSystem)
    super.initialize(self, fileSystem)
end

function Revising:decode(text)
    if text[1] == "[" then
        return string.gsub(text, "..", Revising.escapes)
    end
    return text
end

return Revising
