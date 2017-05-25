local Patching = require "i18n.Workflow.Patching"

local super    = Patching
local Revising = Patching{}

function Revising:initialize(fileSystem, operands)
    super.initialize(self, fileSystem, operands)
end

--  protected  --

function Revising:getContext(original, revised)
    local original = self:read(original)
    local revised  = self:read(revised)

    local indices = table.invert(revised)
    local differences = list.map(function(text)
        return { original = original[indices[text]], revised = text, }
    end, table.indices(set.new(revised) - set.new(original)))

    local groups = list.depair(list.map(function(operand)
        local group = list.depair(list.map(function(difference)
            local key   = operand:decode(difference.original)
            local value = operand:decode(difference.revised)
            return { key, value, }
        end, differences))
        return { operand, group, }
    end, self.operands))

    local context = { groups = groups }
    function context:getReplacement(operand, text)
        return self.groups[operand][text] or text
    end
    return context
end

--  private  --

function Revising:read(path)
    return self.fileSystem:readLines(path)
end

return Revising
