TYPE_BLUE_ATLAS = 1
TYPE_ORANGE_ATLAS = 2

ENT.Type = "anim"

ENT.PrintName = "Portal"
ENT.Author = "CnicK / Bobblehead"
ENT.Contact = ""
ENT.Purpose = "A portal"
ENT.Instructions = "Spawn portals. Look through portals. Enter portals!"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end

ENT.Spawnable = false
ENT.AdminSpawnable = false

local Plymeta = FindMetaTable("Player")
function Plymeta:SetHeadPos(v)
	v.z = v.z - 64
	self:SetPos(v)
end

function Plymeta:GetHeadPos()
	return self:EyePos()
end

local function IsBehind(posA, posB, normal)
	local Vec1 = (posB - posA):GetNormalized()
	return (normal:Dot(Vec1) < 0)
end

function ENT:TransformOffset(v, a1, a2)
	return (v:Dot(a1:Right()) * a2:Right() + v:Dot(a1:Up()) * (-a2:Up()) + v:Dot(a1:Forward()) * a2:Forward())
end

function ENT:GetPortalAngleOffsets(portal, ent)
	local angles = ent:GetAngles()
	local normal = self:GetForward()
	local forward = angles:Forward()
	local up = angles:Up()

	local dot = forward:DotProduct(normal)
	forward = forward + (-2 * dot) * normal

	dot = up:DotProduct(normal)
	up = up + (-2 * dot) * normal

	angles = math.VectorAngles(forward, up)

	local LocalAngles = self:WorldToLocalAngles(angles)
	LocalAngles.y = -LocalAngles.y
	LocalAngles.r = -LocalAngles.r

	return portal:LocalToWorldAngles(LocalAngles)
end

function ENT:GetPortalPosOffsets(portal, ent)
	local pos = ent:IsPlayer() and ent:GetHeadPos() or ent:GetPos()
	local offset = self:WorldToLocal(pos)
	offset.x = -offset.x
	offset.y = -offset.y

	local output = portal:LocalToWorld(offset)
	if ent:IsPlayer() and SERVER then
		return output + self:GetFloorOffset(output)
	else
		return output
	end
end

function ENT:PlayerWithinBounds(ent, predicting)
	local offset = Vector(0, 0, 0)
	if predicting then offset = ent:GetVelocity() * FrameTime() end

	local pOrg = self:GetPos()
	if self:OnFloor() then
		self:SetPos(pOrg - Vector(0, 0, 20))
		pOrg = pOrg - Vector(0, 0, 20)
		offset = Vector(0, 0, 0)
	end

	local plyPos = self:WorldToLocal(ent:GetPos() + offset)
	local headPos = self:WorldToLocal(ent:GetHeadPos() + offset)
	local frontDist

	if self:IsHorizontal() then
		local OBBPos = util.ClosestPointInOBB(pOrg, ent:OBBMins(), ent:OBBMaxs(), ent:GetPos() + offset, false)
		frontDist = OBBPos:PlaneDistance(pOrg, self:GetForward())
	else
		frontDist = math.min((ent:GetPos() + offset):PlaneDistance(self:GetPos(), self:GetForward()), (ent:GetHeadPos() + offset):PlaneDistance(self:GetPos(), self:GetForward()))
	end

	if self:OnFloor() then
		self:SetPos(pOrg + Vector(0, 0, 20))
	end

	if frontDist > 17 then 
		return false 
	end

	local withinBounds = function(pos)
		return (pos.z <= 52 and pos.z >= -52 and pos.y <= 17 and pos.y >= -17)
	end

	if self:IsHorizontal() then
		if not withinBounds(headPos) or (ent:OnGround() and plyPos.z + ent:GetStepSize() or plyPos.z) < -52 then 
			return false 
		end
	else
		if plyPos.z > 44 or plyPos.z < -44 or plyPos.y > 20 or plyPos.y < -20 then 
			return false 
		end
	end

	return true
end

function ENT:SetType(int)
	self:SetNWInt("Potal:PortalType", int)
	self.PortalType = int
	
	if self.Activated == true and SERVER then
		self:SetUpEffects(int)
	end
end

function ENT:IsLinked()
	return self:GetNWBool("Potal:Linked", false)
end

function ENT:GetOther()
	return self:GetNWEntity("Potal:Other", NULL)
end

function ENT:SetUpEffects(int)
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Forward(), 0)
	ang:RotateAroundAxis(ang:Up(), 90)

	local pos = self:GetPos()
	if self:OnFloor() then pos.z = pos.z - 20 end

	local function createParticleEffect(effectName)
		local ent = ents.Create("info_particle_system")
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetKeyValue("effect_name", effectName)
		ent:SetKeyValue("start_active", "1")
		ent:Spawn()
		ent:Activate()
		ent:SetParent(self)
		return ent
	end

	local colorIndex = GetConVarNumber(int == TYPE_BLUE_ATLAS and "portal_color_ATLAS_1" or "portal_color_ATLAS_2")
	local effects = {
		[14] = {"portal_gray_edge", "portal_gray_vacuum"},
		[13] = {"portal_gray_edge", "portal_gray_vacuum"},
		[12] = {"portal_gray_edge", "portal_gray_vacuum"},
		[11] = {"portal_1_edge_pbody_reverse", "portal_2_vacuum_pink_green"},
		[10] = {"portal_1_edge_pink_green_reverse", "portal_2_vacuum_pink_green"},
		[9] = {"portal_1_edge_pink_green_reverse", "portal_2_vacuum_pink_green"},
		[8] = {"portal_1_edge_atlas_reverse", "portal_2_vacuum_atlas"},
		[7] = {"portal_1_edge", "portal_1_vacuum"},
		[6] = {"portal_1_edge_atlas", "portal_1_vacuum_atlas"},
		[5] = {"portal_1_edge_pink_green", "portal_1_vacuum_pink_green"},
		[4] = {"portal_1_edge_pink_green", "portal_1_vacuum_pink_green"},
		[3] = {"portal_1_edge_pink_green", "portal_1_vacuum_pink_green"},
		[2] = {"portal_1_edge_pbody", "portal_1_vacuum_pbody"},
		[1] = {"portal_1_edge_reverse", "portal_2_vacuum"},
		[0] = {"portal_1_edge_pbody_reverse", "portal_2_vacuum_pbody"}
	}

	local edgeEffect, vacuumEffect = unpack(effects[colorIndex] or effects[0])
	self.EdgeEffect = createParticleEffect(edgeEffect)
	self.VacuumEffect = createParticleEffect(vacuumEffect)
end

function ENT:GetFloorOffset(pos1)
	local offset = Vector(0, 0, 0)
	local pos = Vector(0, 0, 0)
	pos:Set(pos1)

	pos.z = pos.z - 64
	pos = self:WorldToLocal(pos)
	pos.x = pos.x + 30

	for i = 0, 54 do
		local openspace = util.IsInWorld(self:LocalToWorld(pos + Vector(0, 0, i)))
		if openspace then
			offset.z = i
			break
		end
	end
	return offset
end

function ENT:GetOpposite()
	if self.PortalType == TYPE_BLUE_ATLAS then
		return TYPE_ORANGE_ATLAS
	elseif self.PortalType == TYPE_ORANGE_ATLAS then
		return TYPE_BLUE_ATLAS
	end
end

function ENT:IsHorizontal()
	return math.Round(self:GetAngles().p) == 0
end

function ENT:OnFloor()
	local p = math.Round(self:GetAngles().p)
	return p == 0 and p == -90
end

function ENT:OnRoof()
	local p = math.Round(self:GetAngles().p)
	return p >= 0 and p <= 180
end

local function PlayerPickup(ply, ent)
	if ent:GetClass() == "prop_portal_atlas" or ent:GetModel() == "models/blackops/portal_sides.mdl" or ent:GetModel() == "models/blackops/portal_sides_new.mdl" then
		return false
	end
end

hook.Add("PhysgunPickup ATLAS", "NoPickupPortalssingleplayer ATLAS", PlayerPickup)
hook.Add("GravGunPickupAllowed ATLAS", "NoPickupPortalssingleplayer ATLAS", PlayerPickup)
hook.Add("GravGunPunt ATLAS", "NoPickupPortalssingleplayer ATLAS", PlayerPickup)
