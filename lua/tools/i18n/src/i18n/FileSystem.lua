local utility = require "i18n.utility"
local Object  = require "i18n.Object"

local pl = {}
pl.path = require "pl.path"
pl.dir  = require "pl.dir"
pl.file = require "pl.file"

local FileSystem = Object{}

function FileSystem:initialize()
end

function FileSystem:getBaseName(path)
    return pl.path.basename(path)
end

function FileSystem:replaceExtension(path, extension)
    return pl.path.splitext(path) .. extension
end

function FileSystem:getLocalPath(path)
    return pl.path.join(utility.getAppDir(), path)
end

function FileSystem:read(path, isBinary)
    return pl.file.read(path, isBinary)
end

function FileSystem:write(path, isBinary, data)
    if data == nil then
        isBinary, data = false, isBinary
    end

    pl.dir.makepath(pl.path.dirname(path))

    local options = (not isBinary and "w" or "wb")
    local file = io.open(path, options)
    file:write(data)
    file:close()
end

function FileSystem:readLines(path)
    return string.split(string.trim(self:read(path)), "\n")
end

function FileSystem:writeLines(path, data)
    self:write(path, table.concat(data, "\n"))
end

function FileSystem:getAllFiles(directory, pattern)
    return pl.dir.getallfiles(directory, pattern)
end

return FileSystem
