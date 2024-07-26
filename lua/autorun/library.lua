LowLibrary = LowLibrary or {}

if SERVER then
    AddCSLuaFile("library.lua")
end

local Addons = {};

function LowLibrary.GetAddons()
    Addons = engine.GetAddons()
    return Addons
end

function LowLibrary.FindAddon(id)
    if #Addons < 2 then
        LowLibrary.GetAddons()
        return FindAddon(id)
    end

    for i,v in pairs(Addons) do
        if i == id then
            return v
        end
    end
end

function LowLibrary.IsAddonEnabled(id)
    local Addon = LowLibrary.FindAddon(id)
    return Addon == nil and false or Addon.Mounted
end

GetAddons()
