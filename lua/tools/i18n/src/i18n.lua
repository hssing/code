local cli = require "cliargs"

local pl = {}
pl.path = require "pl.path"

local FileSystem  = require "i18n.FileSystem"
local fileSystem = FileSystem:new()

local script = arg[0]
local command = fileSystem:getBaseName(script)
cli:set_name(command)

if command == "i18n-revise-extract" then
    cli:add_arg("output", "path to output file")

    local args = cli:parse()
    if args == nil then
        os.exit(1)
    end

    local Script = require "i18n.Script.Operand.Extraction"
    local Layout = require "i18n.Layout.Operand.Extraction"
    local Extraction = require "i18n.Workflow.Extraction"
    local operands = { Script:new(fileSystem), Layout:new(fileSystem), }
    local extraction = Extraction:new(fileSystem, operands)
    extraction:run(args.output)
    os.exit(0)
end

if command == "i18n-revise-apply" then
    cli:add_arg("original", "path to original file")
    cli:add_arg("revise",   "path to revise file")

    local args = cli:parse()
    if args == nil then
        os.exit(1)
    end

    local Script = require "i18n.Script.Operand.Revising"
    local Layout = require "i18n.Layout.Operand.Revising"
    local Revising = require "i18n.Workflow.Revising"
    local operands = { Script:new(fileSystem), Layout:new(fileSystem), }
    local revising = Revising:new(fileSystem, operands)
    revising:run(args.original, args.revise)
    os.exit(0)
end

if command == "i18n-translation-extract" then
    cli:add_arg("output", "path to output file")

    local args = cli:parse()
    if args == nil then
        os.exit(1)
    end

    local Script = require "i18n.Script.Operand.Translating.Extraction"
    local Layout = require "i18n.Layout.Operand.Extraction"
    local Extraction = require "i18n.Workflow.Extraction"
    local operands = { Script:new(fileSystem), Layout:new(fileSystem), }
    local extraction = Extraction:new(fileSystem, operands)
    extraction:run(args.output)
    os.exit(0)
end

if command == "i18n-translation-patch" then
    local args = cli:parse()
    if args == nil then
        os.exit(1)
    end

    local Script = require "i18n.Script.Operand.Translating.Patching"
    local Translating = require "i18n.Workflow.Translating"
    local operands = { Script:new(fileSystem) }
    local translating = Translating:new(fileSystem, operands)
    translating:run()
    os.exit(0)
end

if command == "i18n-database-export" then
    cli:add_arg("xlsx",      "path to translation file, must be an xlsx")
    cli:add_arg("primary",   "the primary language")
    cli:add_arg("directory", "path to output directory")

    local args = cli:parse()
    if args == nil then
        os.exit(1)
    end

    local Reader = require "i18n.Database.Reader"
    local Exporter = require "i18n.Database.Exporter"
    local reader = Reader:new(fileSystem)
    local exporter = Exporter:new(fileSystem, reader:read(args.xlsx))
    exporter:export(args.primary, args.directory)
    os.exit(0)
end

if command == "i18n-language-update" then
    cli:add_arg("source",   "path to source file")
    cli:add_arg("primary",  "path to the primary language file")
    cli:optarg("languages", "path to other language files", "", 64)

    local args = cli:parse()
    if args == nil then
        os.exit(1)
    end

    if args.languages[1] == "" then
        table.remove(args.languages, 1)
    end

    local Language = require "i18n.Language"
    local language = Language:new(fileSystem)

    local source = language:read(args.source)
    local languages = list.depair(list.map(function(path)
        return { path, language:read(path), }
    end, list.append(args.languages, args.primary)))

    local result = language:update(args.primary, source, languages)
    for path, data in pairs(result) do
        language:write(path, data)
    end
    os.exit(0)
end

if command == "i18n-language-merge" then
    cli:add_arg("source",      "path to source directory")
    cli:add_arg("destination", "path to destination directory")
    cli:add_arg("primary",     "the primary language name")
    cli:optarg("languages",    "other language names", "", 64)

    local args = cli:parse()
    if args == nil then
        os.exit(1)
    end

    if args.languages[1] == "" then
        table.remove(args.languages, 1)
    end

    local Language = require "i18n.Language"
    local language = Language:new(fileSystem)

    local languages = list.append(args.languages, args.primary)
    local source = list.depair(list.map(function(name)
        local path = pl.path.join(args.source, name .. ".txt")
        return { name, language:read(path), }
    end, languages))
    local destination = list.depair(list.map(function(name)
        local path = pl.path.join(args.destination, name .. ".txt")
        return { name, language:read(path), }
    end, languages))

    local result = language:merge(args.primary, source, destination)
    for name, data in pairs(result) do
        local path = pl.path.join(args.destination, name .. ".txt")
        language:write(path, data)
    end
    os.exit(0)
end

if command == "i18n-language-export" then
    cli:add_arg("input",  "path to input file")
    cli:add_arg("output", "path to output file")

    local args = cli:parse()
    if args == nil then
        os.exit(1)
    end

    local Language = require "i18n.Language"
    local language = Language:new(fileSystem)
    language:export(args.output, language:read(args.input))
    os.exit(0)
end

print([[
Usage:
  Use following commands to complete your task:

    i18n-revise-extract
      Extract strings for revising from lua and ccb files

    i18n-revise-apply
      Apply revise to lua and ccb files

    i18n-translation-extract
      Extract strings for translating from lua and ccb files

    i18n-translation-patch
      Patch lua files for translating

    i18n-database-export
      Export languages from an xlsx file

    i18n-language-export
      Convert a language file to a data file

    i18n-language-merge
      Merge languages files

    i18n-language-update
      Update languages files
]])

os.exit(1)
