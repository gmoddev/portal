SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_grenade.mdl"
SWEP.AnimPrefix = "Grenade"
SWEP.HoldType = "grenade"
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.Category = "Half-Life 2"
SWEP.EnableIdle = false
SWEP.AdminSpawnable = false

SWEP.m_bFiresUnderwater = false
SWEP.m_flNextPrimaryAttack = CurTime()
SWEP.m_flNextSecondaryAttack = CurTime()
SWEP.m_flSequenceDuration = 0.0

GRENADE_TIMER = 2.5
GRENADE_PAUSED_NO = 0
GRENADE_PAUSED_PRIMARY = 1
GRENADE_PAUSED_SECONDARY = 2
GRENADE_RADIUS = 4.0
GRENADE_DAMAGE_RADIUS = 250.0

SWEP.Primary = {
    Special1 = Sound("weapons/slam/throw.wav"),
    Sound = Sound("common/null.wav"),
    Damage = 150,
    NumShots = 1,
    NumAmmo = 1,
    Cone = vec3_origin,
    ClipSize = -1,
    Delay = 0.5,
    DefaultClip = 1,
    Automatic = false,
    Ammo = "grenade",
    AmmoType = "sent_grenade_frag"
}

SWEP.Secondary = {
    Sound = Sound("common/null.wav"),
    ClipSize = -1,
    DefaultClip = -1,
    Automatic = false,
    Ammo = "None"
}

function SWEP:Precache()
    self.BaseClass:Precache()
end

function SWEP:Operator_HandleAnimEvent(pEvent, pOperator)
    if self.fThrewGrenade then return end

    local pOwner = self.Owner
    self.fThrewGrenade = false

    if pEvent then
        if pEvent == "EVENT_WEAPON_SEQUENCE_FINISHED" then
            self.m_fDrawbackFinished = true
        elseif pEvent == "EVENT_WEAPON_THROW" then
            self:ThrowGrenade(pOwner)
            self:DecrementAmmo(pOwner)
            self.fThrewGrenade = true
        elseif pEvent == "EVENT_WEAPON_THROW2" then
            self:RollGrenade(pOwner)
            self:DecrementAmmo(pOwner)
            self.fThrewGrenade = true
        elseif pEvent == "EVENT_WEAPON_THROW3" then
            self:LobGrenade(pOwner)
            self:DecrementAmmo(pOwner)
            self.fThrewGrenade = true
        end
    end

    if self.fThrewGrenade then
        local delay = self.Primary.Delay
        self.Weapon:SetNextPrimaryFire(CurTime() + delay)
        self.Weapon:SetNextSecondaryFire(CurTime() + delay)
        self.m_flNextPrimaryAttack = CurTime() + delay
        self.m_flNextSecondaryAttack = CurTime() + delay
        self.m_flTimeWeaponIdle = FLT_MAX
    end
end

function SWEP:Initialize()
    if SERVER then
        self:SetNPCMinBurst(0)
        self:SetNPCMaxBurst(0)
        self:SetNPCFireRate(self.Primary.Delay)
    end
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() or self.m_bRedraw then return end

    local pOwner = self.Owner
    if not IsValid(pOwner) then return end

    if self.m_bIsUnderwater and not self.m_bFiresUnderwater then
        self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
        return
    end

    self.m_AttackPaused = GRENADE_PAUSED_PRIMARY
    self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
    self.m_flSequenceDuration = CurTime() + self.Weapon:SequenceDuration()
    self:SetNextPrimaryFire(FLT_MAX)
end

function SWEP:SecondaryAttack()
    if not self:CanSecondaryAttack() or self.m_bRedraw or self:Ammo1() <= 0 then return end

    local pOwner = self.Owner
    if not IsValid(pOwner) then return end

    if self.m_bIsUnderwater and not self.m_bFiresUnderwater then
        self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
        return
    end

    self.m_AttackPaused = GRENADE_PAUSED_SECONDARY
    self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
    self.m_flSequenceDuration = CurTime() + self.Weapon:SequenceDuration()
    self:SetNextSecondaryFire(FLT_MAX)
end

function SWEP:DecrementAmmo(pOwner)
    pOwner:RemoveAmmo(self.Primary.NumAmmo, self.Primary.Ammo)
end

function SWEP:Reload()
    if self:Ammo1() <= 0 then
        self.Weapon:Remove()
        self.Owner:StripWeapon(self:GetClass())
        return false
    end

    if self.m_bRedraw and CurTime() >= self.m_flNextPrimaryAttack and CurTime() >= self.m_flNextSecondaryAttack then
        self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
        self:SetNextPrimaryFire(CurTime() + self.Weapon:SequenceDuration())
        self:SetNextSecondaryFire(CurTime() + self.Weapon:SequenceDuration())
        self.m_flTimeWeaponIdle = CurTime() + self.Weapon:SequenceDuration()
        self.m_bRedraw = false
    end

    self:IdleStuff()
    return true
end

function SWEP:Think()
    if CLIENT and self.EnableIdle then return end

    if self.idledelay and CurTime() > self.idledelay then
        self.idledelay = nil
        self:SendWeaponAnim(ACT_VM_IDLE)
    end

    self:PreThink()

    if self.fThrewGrenade and CurTime() > self.Primary.Delay then
        self.fThrewGrenade = false
        local delay = self.Primary.Delay
        self:SetNextPrimaryFire(CurTime() + delay)
        self:SetNextSecondaryFire(CurTime() + delay)
        self.m_flTimeWeaponIdle = CurTime() + delay
    end

    if self.m_flSequenceDuration > CurTime() then
        self:Operator_HandleAnimEvent("EVENT_WEAPON_SEQUENCE_FINISHED")
        self.m_flSequenceDuration = CurTime()
    end

    if self.m_fDrawbackFinished then
        local pOwner = self.Owner
        if IsValid(pOwner) and self.m_AttackPaused then
            if self.m_AttackPaused == GRENADE_PAUSED_PRIMARY and not pOwner:KeyDown(IN_ATTACK) then
                self:ThrowGrenade(pOwner)
                self.m_fDrawbackFinished = false
            elseif self.m_AttackPaused == GRENADE_PAUSED_SECONDARY and not pOwner:KeyDown(IN_ATTACK2) then
                if pOwner:KeyDown(IN_DUCK) then
                    self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
                    self:RollGrenade(pOwner)
                else
                    self.Weapon:SendWeaponAnim(ACT_VM_HAULBACK)
                    self:LobGrenade(pOwner)
                end
                self.m_fDrawbackFinished = false
            end
        end
    end

    local pPlayer = self.Owner
    if IsValid(pPlayer) then
        self.m_bIsUnderwater = pPlayer:WaterLevel() >= 3
        if self.m_bRedraw then
            self:Reload()
            self:IdleStuff()
        end
    end
end

function SWEP:Deploy()
    self.m_bRedraw = false
    self.Weapon:SendWeaponAnim(ACT_VM_DEPLOY)
    self:IdleStuff()
    return true
end

function SWEP:CheckThrowPosition(pPlayer, vecEye, vecSrc)
    local tr = util.TraceHull({
        start = vecEye,
        endpos = vecSrc,
        mins = Vector(-GRENADE_RADIUS-2, -GRENADE_RADIUS-2, -GRENADE_RADIUS-2),
        maxs = Vector(GRENADE_RADIUS+2, GRENADE_RADIUS+2, GRENADE_RADIUS+2),
        mask = MASK_PLAYERSOLID,
        filter = pPlayer,
        collision = pPlayer:GetCollisionGroup()
    })
    return tr.Hit and tr.endpos or vecSrc
end

function SWEP:DropPrimedFragGrenade(pPlayer, pGrenade)
    if IsValid(pGrenade) then
        self:ThrowGrenade(pPlayer)
        self:DecrementAmmo(pPlayer)
    end
end

function SWEP:ThrowGrenade(pPlayer)
    if self.m_bRedraw then return end

    if SERVER then
        local vecEye = pPlayer:EyePos()
        local vForward, vRight = pPlayer:GetForward(), pPlayer:GetRight()
        local vecSrc = vecEye + vForward * 18 + vRight * 8
        vecSrc = self:CheckThrowPosition(pPlayer, vecEye, vecSrc)
        local vecThrow = pPlayer:GetVelocity() + vForward * 1200

        local pGrenade = ents.Create(self.Primary.AmmoType)
        if IsValid(pGrenade) then
            pGrenade:SetPos(vecSrc)
            pGrenade:SetAngles(vec3_angle)
            pGrenade:SetOwner(pPlayer)
            pGrenade:Fire("SetTimer", GRENADE_TIMER)
            pGrenade:Spawn()
            pGrenade:Initialize()
            local phys = pGrenade:GetPhysicsObject()
            if IsValid(phys) then
                phys:SetVelocity(vecThrow)
                phys:AddAngleVelocity(Vector(600, math.random(-1200, 1200), 0))
            end
            pGrenade.m_flDamage = self.Primary.Damage
            pGrenade.m_DmgRadius = GRENADE_DAMAGE_RADIUS
        end
    end

    self.m_bRedraw = true
    self.Weapon:EmitSound(self.Primary.Sound)
    pPlayer:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:LobGrenade(pPlayer)
    if self.m_bRedraw then return end

    if SERVER then
        local vecEye = pPlayer:EyePos()
        local vForward, vRight = pPlayer:GetForward(), pPlayer:GetRight()
        local vecSrc = vecEye + vForward * 18 + vRight * 8 + Vector(0, 0, -8)
        vecSrc = self:CheckThrowPosition(pPlayer, vecEye, vecSrc)
        local vecThrow = pPlayer:GetVelocity() + vForward * 350 + Vector(0, 0, 50)

        local pGrenade = ents.Create(self.Primary.AmmoType)
        if IsValid(pGrenade) then
            pGrenade:SetPos(vecSrc)
            pGrenade:SetUseType(SIMPLE_USE)
            pGrenade:SetAngles(vec3_angle)
            pGrenade:SetOwner(pPlayer)
            pGrenade:Fire("SetTimer", GRENADE_TIMER)
            pGrenade:Spawn()
            local phys = pGrenade:GetPhysicsObject()
            if IsValid(phys) then
                phys:SetVelocity(vecThrow)
                phys:AddAngleVelocity(Vector(200, math.random(-600, 600), 0))
            end
            pGrenade.m_flDamage = self.Primary.Damage
            pGrenade.m_DmgRadius = GRENADE_DAMAGE_RADIUS
        end
    end

    self.Weapon:EmitSound(self.Secondary.Sound)
    pPlayer:SetAnimation(PLAYER_ATTACK1)
    self.m_bRedraw = true
end

function SWEP:RollGrenade(pPlayer)
    if self.m_bRedraw then return end

    if SERVER then
        local vecSrc = pPlayer:GetPos()
        vecSrc.z = vecSrc.z + GRENADE_RADIUS

        local vecFacing = pPlayer:GetAimVector()
        vecFacing.z = 0
        vecFacing:Normalize()
        local tr = util.TraceLine({
            start = vecSrc,
            endpos = vecSrc - Vector(0, 0, 16),
            mask = MASK_PLAYERSOLID,
            filter = pPlayer
        })
        if tr.Fraction ~= 1.0 then
            local tangent = vecFacing:Cross(tr.HitNormal)
            vecFacing = tr.HitNormal:Cross(tangent)
        end
        vecSrc = vecSrc + vecFacing * 18
        vecSrc = self:CheckThrowPosition(pPlayer, pPlayer:GetPos(), vecSrc)

        local vecThrow = pPlayer:GetVelocity() + vecFacing * 700
        local orientation = Angle(0, pPlayer:GetLocalAngles().y, -90)
        local rotSpeed = Vector(0, 0, 720)
        local pGrenade = ents.Create(self.Primary.AmmoType)
        if IsValid(pGrenade) then
            pGrenade:SetPos(vecSrc)
            pGrenade:SetUseType(SIMPLE_USE)
            pGrenade:SetAngles(orientation)
            pGrenade:SetOwner(pPlayer)
            pGrenade:Fire("SetTimer", GRENADE_TIMER)
            pGrenade:Spawn()
            local phys = pGrenade:GetPhysicsObject()
            if IsValid(phys) then
                phys:SetVelocity(vecThrow)
                phys:AddAngleVelocity(rotSpeed)
            end
            pGrenade.m_flDamage = self.Primary.Damage
            pGrenade.m_DmgRadius = GRENADE_DAMAGE_RADIUS
        end
    end

    self.Weapon:EmitSound(self.Primary.Special1)
    pPlayer:SetAnimation(PLAYER_ATTACK1)
    self.m_bRedraw = true
end

function SWEP:CanPrimaryAttack()
    return true
end

function SWEP:CanSecondaryAttack()
    return true
end

function SWEP:SetDeploySpeed(speed)
    self.m_WeaponDeploySpeed = tonumber(speed / GetConVarNumber("phys_timescale"))
    self.Weapon:SetNextPrimaryFire(CurTime() + speed)
    self.Weapon:SetNextSecondaryFire(CurTime() + speed)
end

function SWEP:IdleStuff()
    if self.EnableIdle then return end
    self.idledelay = CurTime() + self:SequenceDuration()
end
