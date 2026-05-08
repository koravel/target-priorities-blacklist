-- lib/serializer.lua
local serializer = {}

function serializer.serialize_list(list)
    return table.concat(list, ",")
end

function serializer.deserialize_list(str)
    local t = {}
    for name in string.gmatch(str, "([^,]+)") do
        table.insert(t, name)
    end
    return t
end

return serializer
