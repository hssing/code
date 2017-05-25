local utility = require "i18n.utility"
local Operand = require "i18n.Script.Operand.Extraction"

local super      = Operand
local Extraction = Operand{}

function Extraction:initialize(fileSystem)
    super.initialize(self, fileSystem)
end

function Extraction:encode(text)
    return utility.string.quote(utility.string.unquote(text))
end

return Extraction
