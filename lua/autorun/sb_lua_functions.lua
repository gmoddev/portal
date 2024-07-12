local string = string

if not SERVER then
    AddCSLuaFile("sb_lua_functions.lua")
else
    return
end

function GetScriptPath()
    local name = debug.getinfo(debug.getinfo(2, "f").func).short_src
    local pos = 0

    while true do
        local src = string.find(name, "/", (pos or 0) + 1)
        if not src then break end
        pos = src
    end

    if pos then return string.sub(name, 1, pos - 1) end

    return ""
end

function HookStrings()
    function string.Strip(text, to_be_stripped)
        return string.Replace(text, to_be_stripped, "")
    end
end

function HookMetaVectors()
    local meta = FindMetaTable("Vector")
    if not meta then return end

    function meta:__unm(vec)
        return -1 * vec
    end

    function VectorAdd(a, b, c)
        if not a or not b then return end
        local c = c or vec3_origin
        c.x = a.x + b.x
        c.y = a.y + b.y
        c.z = a.z + b.z
        return c
    end

    function VectorSubtract(a, b, c)
        if not a or not b then return end
        local c = c or vec3_origin
        c.x = a.x - b.x
        c.y = a.y - b.y
        c.z = a.z - b.z
        return c
    end

    function VectorMultiply(a, b, c)
        if not a or not b then return end
        local c = c or vec3_origin
        if type(b) == "number" then
            c.x = a.x * b
            c.y = a.y * b
            c.z = a.z * b
        elseif type(b) == "Vector" then
            c.x = a.x * b.x
            c.y = a.y * b.y
            c.z = a.z * b.z
        end
        return c
    end

    function RandomVector(minVal, maxVal)
        return Vector(math.Rand(minVal, maxVal), math.Rand(minVal, maxVal), math.Rand(minVal, maxVal))
    end

    -- For backwards compatibility
    function VectorScale(input, scale, result)
        return VectorMultiply(input, scale, result)
    end

    function VectorNormalize(v)
        local l = v:Length()
        if l ~= 0.0 then
            v = v / l
        else
            v.x = 0.0
            v.y = 0.0
            v.z = 1.0
        end
        return v
    end

    function CrossProduct(a, b)
        return Vector(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
    end

    function RandomAngle(minVal, maxVal)
        local random = vec3_angle
        random.pitch = math.Rand(minVal, maxVal)
        random.yaw = math.Rand(minVal, maxVal)
        random.roll = math.Rand(minVal, maxVal)
        return Angle(random.pitch, random.yaw, random.roll)
    end
end

function HookVector()
    local meta = FindMetaTable("Vector")
    if not meta then return end

    function meta:__unm()
        return -1 * self
    end

    function VectorAdd(a, b, c)
        if not a or not b then return end
        local c = c or vec3_origin
        c.x = a.x + b.x
        c.y = a.y + b.y
        c.z = a.z + b.z
        return c
    end

    function VectorSubtract(a, b, c)
        if not a or not b then return end
        local c = c or vec3_origin
        c.x = a.x - b.x
        c.y = a.y - b.y
        c.z = a.z - b.z
        return c
    end

    function VectorMultiply(a, b, c)
        if not a or not b then return end
        local c = c or vec3_origin
        if type(b) == "number" then
            c.x = a.x * b
            c.y = a.y * b
            c.z = a.z * b
        elseif type(b) == "Vector" then
            c.x = a.x * b.x
            c.y = a.y * b.y
            c.z = a.z * b.z
        end
        return c
    end

    -- Get a random vector.
    function RandomVector(minVal, maxVal)
        return Vector(math.Rand(minVal, maxVal), math.Rand(minVal, maxVal), math.Rand(minVal, maxVal))
    end

    -- For backwards compatibility
    function VectorScale(input, scale, result)
        return VectorMultiply(input, scale, result)
    end

    -- Normalization
    function VectorNormalize(v)
        local l = v:Length()
        if l ~= 0.0 then
            v = v / l
        else
            -- FIXME: Just copying the existing implementation; shouldn't res.z == 0?
            v.x = 0.0
            v.y = 0.0
            v.z = 1.0
        end
        return v
    end

    function CrossProduct(a, b)
        return Vector(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
    end

    function RandomAngle(minVal, maxVal)
        local random = vec3_angle
        random.pitch = math.Rand(minVal, maxVal)
        random.yaw = math.Rand(minVal, maxVal)
        random.roll = math.Rand(minVal, maxVal)
        return Angle(random.pitch, random.yaw, random.roll)
    end
end

HookVector()


HookVector()
HookMetaVectors()
HookStrings()
