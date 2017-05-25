local Patching = require "i18n.Workflow.Patching"

local super       = Patching
local Translating = Patching{}

function Translating:initialize(fileSystem, operands)
    super.initialize(self, fileSystem, operands)
end

--  protected  --

function Translating:getContext(original, revised)
    local context = {}
    function context:getReplacement(operand, text)
        return operand:getReplacement(text)
    end
    return context
end

return Translating
