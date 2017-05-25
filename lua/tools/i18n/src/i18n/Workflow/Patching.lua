local Object = require "i18n.Object"

local Patching = Object{}

function Patching:initialize(fileSystem, operands)
    self.fileSystem = fileSystem
    self.operands = operands
end

function Patching:run(...)
    local context = self:getContext(...)
    for _, operand in ipairs(self.operands) do
        self:patch(operand, context)
    end
end

--  protected  --

function Patching:getContext(...)
    error("unimplemented")
end

--  private  --

function Patching:patch(operand, context)
    for _, path in ipairs(operand:getAllFiles()) do
        local strings = operand:extract(path)
        table.sort(strings, function(lhs, rhs)
            return #lhs > #rhs
        end)

        local content = self.fileSystem:read(path, true)
        for i, text in ipairs(strings) do
            content = string.gsub(content,
                                  string.escapePattern(text),
                                  "\255\255" .. i .. "\255\255")
        end
        for i, text in ipairs(strings) do
            local replacement = context:getReplacement(operand, text)
            content = string.gsub(content,
                                  "\255\255" .. i .. "\255\255",
                                  string.escapePattern(replacement))
        end
        self.fileSystem:write(path, true, content)
    end
end

return Patching
