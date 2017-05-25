local utility = require "i18n.utility"
local Operand = require "i18n.Layout.Operand"

local super    = Operand
local Revising = Operand{}

function Revising:initialize(fileSystem)
    super.initialize(self, fileSystem)
end

function Revising:decode(text)
    return utility.string.unquote(text)
end

return Revising
