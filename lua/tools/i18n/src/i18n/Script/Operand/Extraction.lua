local Operand = require "i18n.Script.Operand"

local super      = Operand
local Extraction = Operand{}

Extraction.escapes =
{
    ["\\"] = "\\\\",
    ["\r"] = "\\r",
    ["\n"] = "\\n",
}

function Extraction:initialize(fileSystem)
    super.initialize(self, fileSystem)
end

function Extraction:encode(text)
    if text[1] == "[" then
        return string.gsub(text, ".", Extraction.escapes)
    end
    assert(string.find(text, "\n") == nil)
    return text
end

return Extraction
