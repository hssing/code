local utility = require "i18n.utility"
local Operand = require "i18n.Layout.Operand"

local super      = Operand
local Extraction = Operand{}

function Extraction:initialize(fileSystem)
    super.initialize(self, fileSystem)
end

function Extraction:encode(text)
    return utility.string.quote(text)
end

return Extraction
