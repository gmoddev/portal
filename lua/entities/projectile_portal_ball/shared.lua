AddCSLuaFile("shared.lua")

if CLIENT then
    game.AddParticles("particles/cleansers.pcf")
end

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Portal Ball"
ENT.Author = "Mahalis"
ENT.Spawnable = false
ENT.AdminSpawnable = false

local useInstant = CreateConVar("portal_instant", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Make portals create instantly and don't use the projectile.")
local ballEnable = CreateConVar("portal_projectile_ball", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "If the ball is enabled")

local PARTICLE_EFFECTS = {
    ball = {
        [0] = "portal_2_projectile_ball_pbody",
        [1] = "portal_2_projectile_ball",
        [2] = "portal_1_projectile_ball_pbody",
        [3] = "portal_1_projectile_ball_pink_green",
        [4] = "portal_1_projectile_ball_pink_green",
        [5] = "portal_1_projectile_ball_pink_green",
        [6] = "portal_1_projectile_ball_atlas",
        [7] = "portal_1_projectile_ball",
        [8] = "portal_2_projectile_ball_atlas",
        [9] = "portal_2_projectile_ball_pink_green",
        [10] = "portal_2_projectile_ball_pink_green",
        [11] = "portal_2_projectile_ball_pbody",
        [12] = "portal_gray_projectile_ball",
        [13] = "portal_gray_projectile_ball",
        [14] = "portal_gray_projectile_ball",
    },
    fiber = {
        [0] = "portal_2_projectile_fiber_pbody",
        [1] = "portal_2_projectile_fiber",
        [2] = "portal_1_projectile_fiber_pbody",
        [3] = "portal_1_projectile_fiber_pink_green",
        [4] = "portal_1_projectile_fiber_pink_green",
        [5] = "portal_1_projectile_fiber_pink_green",
        [6] = "portal_1_projectile_fiber_atlas",
        [7] = "portal_1_projectile_fiber",
        [8] = "portal_2_projectile_fiber_atlas",
        [9] = "portal_2_projectile_fiber_pink_green",
        [10] = "portal_2_projectile_fiber_pink_green",
        [11] = "portal_2_projectile_fiber_pbody",
        [12] = "portal_gray_projectile_fiber",
        [13] = "portal_gray_projectile_fiber",
        [14] = "portal_gray_projectile_fiber",
    }
}

function ENT:Initialize()
    self:SetModel("models/hunter/misc/sphere025x025.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:PhysicsInitSphere(1, "Metal")

    local phy = self:GetPhysicsObject()
    if IsValid(phy) then
        phy:EnableGravity(false)
        phy:EnableDrag(false)
        phy:EnableCollisions(false)
    end

    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    self:DrawShadow(false)
    self:SetNoDraw(false)

    timer.Simple(0.01, function()
        if IsValid(self) then
            self:SetNoDraw(true)
        end
    end)
end

function ENT:SetEffects(type)
    self:SetNWInt("Kind", type)

    if ballEnable:GetBool() and not useInstant:GetBool() then
        local color = type == TYPE_BLUE and GetConVarNumber("portal_color_1") or GetConVarNumber("portal_color_2")
        self:AttachParticleEffect(type, "ball", color)
        self:AttachParticleEffect(type, "fiber", color)
    end
end

function ENT:AttachParticleEffect(type, effectType, color)
    local effectName = PARTICLE_EFFECTS[effectType][color] or "portal_gray_projectile_" .. effectType
    ParticleEffectAttach(effectName, PATTACH_ABSORIGIN_FOLLOW, self, 1)
end

function ENT:GetKind()
    return self:GetNWInt("Kind", TYPE_BLUE)
end

function ENT:SetGun(ent)
    self.gun = ent
end

function ENT:GetGun()
    return self.gun
end

function ENT:PhysicsCollide(data, phy)
    -- self:Remove()
    -- print("Create Portal!")
end

function ENT:Draw()
    -- Custom draw logic (if any)
end
