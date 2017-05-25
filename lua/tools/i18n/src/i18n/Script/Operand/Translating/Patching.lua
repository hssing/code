local Operand = require "i18n.Script.Operand"

local super    = Operand
local Patching = Operand{}

function Patching:initialize(fileSystem)
    super.initialize(self, fileSystem)
end

function Patching:getReplacement(text)
    return 'translate("lua", ' .. text .. ')'
end

return Patching
