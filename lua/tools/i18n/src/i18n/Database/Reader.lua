local json    = require "json"
local utility = require "i18n.utility"
local Object  = require "i18n.Object"

local Reader = Object{}

function Reader:initialize(fileSystem)
    self.fileSystem = fileSystem
end

function Reader:read(path)
    return list.foldl(function(array, sheet)
        if not self:checkSheet(sheet) then
            return array
        end

        local fields = self:getFields(sheet)
        for row = 5, #sheet.data do
            local item = list.depair(list.map(function(field)
                return { field.lang, sheet.data[row][field.index], }
            end, fields))
            table.insert(array, item)
        end

        return array
    end, {}, self:readData(path))
end

--  private  --

function Reader:readData(path)
    local bin = utility.getBinPath("xlsx2json")
    local file = io.popen(string.format('%s "%s"', bin, path))
    local data = file:read("*a")
    file:close()

    local result = json.decode(data)
    if result == nil then
        return result
    end

    for _, sheet in ipairs(result) do
        sheet.data = list.map(function(row)
            return list.depair(list.map(function(col)
                return { col.index, col.value, }
            end, row))
        end, sheet.data)
    end

    return result
end

function Reader:checkSheet(sheet)
    if sheet.data[2][1] ~= "CLIENT" then
        return false
    end
    if sheet.data[4][1] ~= "SERVER" then
        return false
    end
    if sheet.data[2][3] ~= "chinese" then
        return false
    end
    return true
end

function Reader:getFields(sheet)
    return list.slice(list.map(function(field)
        local index, lang = unpack(field)
        return { index = index, lang = lang, }
    end, list.enpair(sheet.data[2])), 3, sheet.colAmount)
end

return Reader
