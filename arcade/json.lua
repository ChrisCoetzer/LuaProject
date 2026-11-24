-- Small JSON codec for the arcade's result records (no executable save data).
local json = {}

function json.encode(value)
    local kind = type(value)
    if kind == "string" then
        return '"' .. value:gsub('[%z\1-\31\\"]', function(c)
            return string.format("\\u%04x", c:byte())
        end) .. '"'
    elseif kind == "boolean" then
        return tostring(value)
    elseif kind == "number" then
        assert(value == value and math.abs(value) < math.huge, "Invalid JSON number")
        return tostring(value)
    elseif kind == "table" then
        local parts = {}
        for key, item in pairs(value) do
            assert(type(key) == "string", "JSON object keys must be strings")
            parts[#parts + 1] = json.encode(key) .. ":" .. json.encode(item)
        end
        table.sort(parts)
        return "{" .. table.concat(parts, ",") .. "}"
    end
    error("Unsupported JSON value")
end

-- The save format uses objects and primitive values only.
function json.decode(source)
    local position = 1
    local function skip()
        position = source:find("%S", position) or (#source + 1)
    end
    local parse
    local function parseString()
        position = position + 1
        local parts = {}
        while position <= #source do
            local c = source:sub(position, position)
            position = position + 1
            if c == '"' then return table.concat(parts) end
            if c == "\\" then
                local escape = source:sub(position, position)
                position = position + 1
                local escapes = { ['"'] = '"', ['\\'] = '\\', ['/'] = '/',
                    b = '\b', f = '\f', n = '\n', r = '\r', t = '\t' }
                if escape == "u" then
                    local hex = source:sub(position, position + 3)
                    assert(hex:match("^%x%x%x%x$"), "Invalid JSON escape")
                    local code = tonumber(hex, 16)
                    assert(code < 128, "Unsupported Unicode escape")
                    c = string.char(code)
                    position = position + 4
                else
                    c = assert(escapes[escape], "Invalid JSON escape")
                end
            else
                assert(c:byte() >= 32, "Invalid JSON string")
            end
            parts[#parts + 1] = c
        end
        error("Unterminated JSON string")
    end
    parse = function(depth)
        assert(depth < 20, "JSON nesting too deep")
        skip()
        local c = source:sub(position, position)
        if c == '"' then return parseString() end
        if c == "{" then
            position = position + 1
            local object = {}
            skip()
            if source:sub(position, position) == "}" then
                position = position + 1
                return object
            end
            while true do
                skip()
                assert(source:sub(position, position) == '"', "Expected JSON key")
                local key = parseString()
                skip()
                assert(source:sub(position, position) == ":", "Expected colon")
                position = position + 1
                object[key] = parse(depth + 1)
                skip()
                c = source:sub(position, position)
                position = position + 1
                if c == "}" then return object end
                assert(c == ",", "Expected comma")
            end
        end
        for literal, value in pairs({ ["true"] = true, ["false"] = false }) do
            if source:sub(position, position + #literal - 1) == literal then
                position = position + #literal
                return value
            end
        end
        local token = source:sub(position):match("^-?%d+%.?%d*")
        assert(token, "Invalid JSON value")
        position = position + #token
        return assert(tonumber(token), "Invalid JSON number")
    end
    local value = parse(0)
    skip()
    assert(position > #source, "Unexpected trailing JSON data")
    return value
end

return json
