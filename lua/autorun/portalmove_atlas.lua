if SERVER then
    AddCSLuaFile("portalmove.lua")
end

local snd_portal2 = CreateClientConVar("portal_sound", "0", true, false)
local portal_prototype = CreateClientConVar("portal_prototype", "1", true, false)

local lastfootstep = 1
local lastfoot = 0

local function PlayFootstep(ply, level, pitch, volume)
    local sound = math.random(1, 4)
    while sound == lastfootstep do
        sound = math.random(1, 4)
    end

    lastfoot = (lastfoot == 0) and 1 or 0
    local filter = SERVER and RecipientFilter():AddPVS(ply:GetPos()) or nil

    if GAMEMODE:PlayerFootstep(ply, pos, lastfoot, "player/footsteps/concrete" .. sound .. ".wav", .6, filter) then return end
    ply:EmitSound("player/footsteps/concrete" .. sound .. ".wav", level, pitch, volume, CHAN_BODY)
end

if CLIENT then
    local function CreateMove(cmd)
        local pl = LocalPlayer()
        if IsValid(pl) and pl.InPortal and pl.InPortal:IsValid() and pl:GetMoveType() == MOVETYPE_NOCLIP then
            local right = 0
            local forward = 0
            local maxspeed = pl:GetMaxSpeed()
            if pl:Crouching() then
                maxspeed = pl:GetCrouchedWalkSpeed() * 180
            end

            if cmd:KeyDown(IN_FORWARD) then
                forward = forward + maxspeed
            end
            if cmd:KeyDown(IN_BACK) then
                forward = forward - maxspeed
            end
            if cmd:KeyDown(IN_MOVERIGHT) then
                right = right + maxspeed
            end
            if cmd:KeyDown(IN_MOVELEFT) then
                right = right - maxspeed
            end

            if cmd:KeyDown(IN_JUMP) then
                if pl.m_bSpacebarReleased and pl.InPortal:IsHorizontal() then
                    pl.m_bSpacebarReleased = false
                    if pl.InPortal:WorldToLocal(pl:GetPos()).z <= -54 then
                        GAMEMODE:DoAnimationEvent(LocalPlayer(), PLAYERANIMEVENT_JUMP)
                    end
                end
            else
                pl.m_bSpacebarReleased = true
            end

            if cmd:KeyDown(IN_DUCK) then
                pl:SetViewOffset(Vector(0, 0, 0))
            end

            cmd:SetForwardMove(forward)
            cmd:SetSideMove(right)
        end
    end

    hook.Add("CreateMove", "Noclip.CreateMove", CreateMove)
end

local function SubAxis(v, x)
    return v - (v:Dot(x) * x)
end

local function IsInFront(posA, posB, normal)
    local Vec1 = (posB - posA):GetNormalized()
    return (normal:Dot(Vec1) < 0)
end

local nextFootStepTime = CurTime()

function ipMove(ply, mv)
    local portal = ply.InPortal
    if IsValid(portal) and ply:GetMoveType() == MOVETYPE_NOCLIP then
        local deltaTime = FrameTime()
        local curTime = CurTime()
        local noclipSpeed = 1.75
        local noclipAccelerate = 5
        local pos = mv:GetOrigin()
        local pOrg = portal:GetPos()
        
        if portal:OnFloor() then
            pOrg = pOrg - Vector(0, 0, 20)
        end
        
        local pAng = portal:GetAngles()
        local ang = mv:GetMoveAngles()
        local acceleration = ang:Right() * mv:GetSideSpeed() + (ang + Angle(0, 90, 0)):Right() * mv:GetForwardSpeed()
        local accelSpeed = math.min(acceleration:Length2D(), ply:GetMaxSpeed())
        local accelDir = acceleration:GetNormal()
        acceleration = accelDir * accelSpeed * noclipSpeed
        
        if accelSpeed > 0 and pos.z <= pOrg.z - 55 and curTime > nextFootStepTime then
            nextFootStepTime = curTime + .4
            PlayFootstep(ply, 50, 100, .4)
        end

        local gravity = Vector(0, 0, 0)
        local g = GetConVarNumber("sv_gravity")
        if portal:IsHorizontal() then
            if pos.z > pOrg.z - 54 then
                gravity.z = -g
            end
        else
            gravity.z = -g
        end

        local getvel = mv:GetVelocity()
        local newVelocity = getvel + acceleration * deltaTime * noclipAccelerate + (gravity * deltaTime)
        newVelocity.z = math.max(newVelocity.z, -3000)
        newVelocity.z = newVelocity.z * .9999
        newVelocity.x = newVelocity.x * (0.98 - deltaTime * 5)
        newVelocity.y = newVelocity.y * (0.98 - deltaTime * 5)

        if mv:KeyDown(IN_JUMP) then
            if ply.m_bSpacebarReleased and portal:IsHorizontal() then
                ply.m_bSpacebarReleased = false
                if portal:WorldToLocal(pos).z <= -54 then
                    newVelocity.z = ply:GetJumpPower()
                    GAMEMODE:DoAnimationEvent(ply, PLAYERANIMEVENT_JUMP)
                    PlayFootstep(ply, 40, 100, .6)
                end
            end
        else
            ply.m_bSpacebarReleased = true
        end

        local frontDist
        if portal:IsHorizontal() then
            local OBBPos = util.ClosestPointInOBB(pOrg, ply:OBBMins(), ply:OBBMaxs(), ply:GetPos(), false)
            frontDist = OBBPos:PlaneDistance(pOrg, pAng:Forward())
        else
            frontDist = math.min(pos:PlaneDistance(pOrg, pAng:Forward()), ply:GetHeadPos():PlaneDistance(pOrg, pAng:Forward()))
        end

        local localOrigin = portal:WorldToLocal(pos + newVelocity * deltaTime)

        local minY, maxY, minZ, maxZ
        if portal:IsHorizontal() then
            minY, maxY = -20, 20
            minZ, maxZ = -55, -14
        else
            minY, maxY = -20, 20
            minZ, maxZ = -50, 44
        end

        local frontNum = portal_prototype:GetBool() and 32 or 16

        if frontDist < frontNum then
            localOrigin.z = math.Clamp(localOrigin.z, minZ, maxZ)
            localOrigin.y = math.Clamp(localOrigin.y, minY, maxY)
        else
            ply.PortalClone = nil
            ply.InPortal = nil
            ply:SetMoveType(MOVETYPE_FLY)
            timer.Create("Walk", 0.075, 1, function()
                ply:SetMoveType(MOVETYPE_WALK)
                for _, v in pairs(player.GetAll()) do
                    v:ResetHull()
                end
            end)

            local sound = snd_portal2:GetBool() and "player/portal2/portal_exit" or "player/portal_exit"
            ply:EmitSound(sound .. math.random(1, 2) .. ".wav", 80, 100 + (30 * (newVelocity:Length() - 450) / 1000))
        end

        mv:SetVelocity(newVelocity)
        mv:SetOrigin(portal:LocalToWorld(localOrigin))

        return true
    end
end

hook.Add("Move", "ipMove", ipMove)

local vec = FindMetaTable("Vector")

function vec:PlaneDistance(plane, normal)
    return normal:Dot(self - plane)
end

function math.YawBetweenPoints(a, b)
    local xDiff = a.x - b.x
    local yDiff = a.y - b.y
    return math.atan2(yDiff, xDiff) * (180 / math.pi)
end

function util.ClosestPointInOBB(point, mins, maxs, center, Debug)
    local Debug = Debug or false
    local yaw = math.rad(math.YawBetweenPoints(point, center))
    local radius
    local abs_cos_angle = math.abs(math.cos(yaw))
    local abs_sin_angle = math.abs(math.sin(yaw))
    if (16 * abs_sin_angle <= 16 * abs_cos_angle) then
        radius = 16 / abs_cos_angle
    else
        radius = 16 / abs_sin_angle
    end

    radius = math.min(radius, math.Distance(center.x, center.y, point.x, point.y))
    local x, y = math.cos(yaw) * radius, math.sin(yaw) * radius

    return Vector(x, y, 0) + center
end

if CLIENT then
    usermessage.Hook("drawOBB", function(umsg)
        local point, mins, maxs, center = umsg:ReadVector(), umsg:ReadVector(), umsg:ReadVector(), umsg:ReadVector()
        util.ClosestPointInOBB(point, mins, maxs, center, true)
    end)
end

if SERVER then
    hook.Add("PreCleanupMap", "RemovePortalsIndividually", function()
        for _, v in pairs(ents.FindByClass("prop_portal")) do
            v:CleanMeUp()
        end
    end)

    hook.Add("DoPlayerDeath", "RemovePortalsOnDeath", function(victim)
        local bluePortal = victim:GetNWEntity("Portal:Blue")
        local orangePortal = victim:GetNWEntity("Portal:Orange")

        for _, v in ipairs(ents.FindByClass("prop_portal")) do
            if (v == bluePortal or v == orangePortal) and v.CleanMeUp then
                v:CleanMeUp()
            end
        end
    end)
end
