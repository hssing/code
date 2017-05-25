local utility = require "i18n.utility"
local Object  = require "i18n.Object"

local Language = Object{}

function Language:initialize(fileSystem)
    self.fileSystem = fileSystem
end

function Language:read(path)
    return list.map(utility.string.unquote, self.fileSystem:readLines(path))
end

function Language:write(path, data)
    self.fileSystem:writeLines(path, list.map(utility.string.quote, data))
end

function Language:update(primary, data, group)
    local difference = table.indices(set.new(data) - set.new(group[primary]))
    return list.depair(list.map(function(language)
        local name, data = unpack(language)
        return { name, list.concat(data, difference), }
    end, list.enpair(group)))
end

function Language:merge(primary, src, dst)
    assert(set.equal(set.new(table.indices(dst)), set.new(table.indices(src))))

    local sp = src[primary]
    local dp = dst[primary]

    local indices = list.map(bind(function(indices, text)
        return indices[text]
    end, table.invert(sp)), table.indices(set.new(sp) - set.new(dp)))

    return list.depair(list.map(function(language)
        local name, data = unpack(language)
        local difference = list.map(function(index)
            return data[index]
        end, indices)
        return { name, list.concat(dst[name], difference), }
    end, list.enpair(src)))
end

function Language:export(path, data)
    local template = {}
    table.insert(template, "translation =")
    table.insert(template, "{")
    table.insert(template, "%s")
    table.insert(template, "}")
    template = table.concat(template, "\n")

    local content = table.concat(list.map(function(text)
        return "    " .. utility.string.quote(text) .. ","
    end, data), "\n")

    self.fileSystem:write(path, string.format(template, content))
end

return Language
