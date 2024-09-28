local Serializer = {}

local function isList(tbl)
    local count = 0
    for key, _ in pairs(tbl) do
        if type(key) ~= "number" or key < 1 or math.floor(key) ~= key then
            return false
        end
        count = count + 1
    end

    for i = 1, count do
        if tbl[i] == nil then
            return false
        end
    end

    return true
end

function Serializer.decode(str)
    local func, err = load('return ' .. str, nil, "t", {})
    if not func then
        error("Error loading string: " .. err)
    end
    return func()
end

function Serializer.encode(tbl, indent)
    indent = indent or 0
    local result = "{"
    local first = true
    local is_list = isList(tbl)

    local indentStr = indent > 0 and string.rep("  ", indent + 1) or ""
    local newline = indent > 0 and "\n" or ""
    local spacer = indent > 0 and " " or ""

    for key, value in pairs(tbl) do
        if not first then
            result = result .. "," .. spacer
        end
        first = false

        result = result .. newline .. indentStr

        if not is_list then
            if type(key) == "string" then
                result = result .. key .. " = "
            else
                result = result .. "[" .. tostring(key) .. "] = "
            end
        end

        if type(value) == "table" then
            result = result .. Serializer.encode(value, indent > 0 and indent + 2 or 0)
        elseif type(value) == "string" then
            result = result .. '"' .. value .. '"'
        elseif type(value) == "number" or type(value) == "boolean" then
            result = result .. tostring(value)
        else
            error("Tipo de dado não suportado: " .. type(value))
        end
    end
    result = result .. (indent and "\n" .. string.rep("  ", indent - 1) .. "}" or "}")
    return result
end

function Serializer.load(path)
    local file, err = io.open(path, 'r')
    if not file then
        error("Erro ao abrir arquivo: " .. err)
    end
    local content = file:read("*a")
    file:close()
    return Serializer.decode(content)
end

function Serializer.dump(tbl, path, ident)
    local file, err = io.open(path, 'w')
    if not file then
        error("Error opening file for writing: " .. err)
    end
    file:write(Serializer.encode(tbl, ident))
    file:close()
end

return Serializer
