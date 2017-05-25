local pl = {}
pl.path = require "pl.path"

local utility = require "i18n.utility"
local Object  = require "i18n.Object"

local Exporter = Object{}

function Exporter:initialize(fileSystem, data)
    self.fileSystem = fileSystem
    self.data = data
end

function Exporter:export(primary, directory)
    local data = table.values(list.indexValue(primary, self.data))

    table.sort(data, function(lhs, rhs)
        return lhs[primary] < rhs[primary]
    end)

    for lang in pairs(data[1] or {}) do
        local path = pl.path.join(directory, lang .. ".txt")
        self:writeFile(path, list.project(lang, data))
    end
end

function Exporter:writeFile(path, data)
    local data = list.map(utility.string.quote, data)
    self.fileSystem:writeLines(path, data)
end

return Exporter
