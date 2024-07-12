include( "shared.lua" )

local dlightenabled = CreateClientConVar("portal_dynamic_light", "0", true) --Pretty laggy, default it to off
-- local lightteleport = CreateClientConVar("portal_light_teleport", "0", true)
local bordersenabled = CreateClientConVar("portal_borders", "1", true)
local renderportals = CreateClientConVar("portal_render", 1, true) --Some people can't handle portals at all.
local texFSBportals = CreateClientConVar("portal_texFSB", 0, true)

local portal_1_color = CreateClientConVar("portal_color_ATLAS_1", 6, true)
local portal_1_contraste = CreateClientConVar("portal_color_ATLAS_contraste_1", 1, true)
local portal_1_saturation = CreateClientConVar("portal_color_ATLAS_saturation_1", 0, true)

local portal_2_color = CreateClientConVar("portal_color_ATLAS_2", 8, true)
local portal_2_contraste = CreateClientConVar("portal_color_ATLAS_contraste_2", 1, true)
local portal_2_saturation = CreateClientConVar("portal_color_ATLAS_saturation_2", 0, true)

local texFSB = render.GetSuperFPTex() -- I'm really not sure if I should even be using these D:
local texFSB2 = render.GetSuperFPTex2()

 -- Make our own material to use, so we aren't messing with other effects.
local PortalMaterial = CreateMaterial(
                "PortalMaterial",
                "UnlitGeneric",
                -- "GMODScreenspace",
                {
                        [ '$basetexture' ] = texFSB,
                        [ '$model' ] = "1",
                        -- [ '$basetexturetransform' ] = "center .5 .5 scale 1 1 rotate 0 translate 0 0",
                        [ '$alphatest' ] = "0",
						[ '$PortalMaskTexture' ] = "models/portals/portal-mask-dx8",
                        [ '$additive' ] = "0",
                        [ '$translucent' ] = "0",
                        [ '$ignorez' ] = "0"
                }
        )
		

// rendergroup
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize( )

        self:SetRenderBounds( self:OBBMins()*20, self:OBBMaxs()*20 )
       
        self.openpercent = 0
		self.openpercent_bordermat = 0.8
        self.openpercent_material = 0
		
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		
		if self:OnFloor() then
			self:SetRenderOrigin( self:GetPos() - Vector(0,0,20))
		else
			self:SetRenderOrigin( self:GetPos() )
		end
		
		-- self:SetRenderClipPlaneEnabled( true )
		-- self:SetRenderClipPlane( self:GetForward(), 5 )
       
end

usermessage.Hook("Portal:Moved", function(umsg)
        local ent = umsg:ReadEntity()
		local pos = umsg:ReadVector()
		local ang = umsg:ReadAngle()
        if ent and ent:IsValid() and ent.openpercent_bordermat then
                ent.openpercent_bordermat = 0.8
				
				ent:SetAngles(ang)
				if ent:OnFloor() then
					ent:SetRenderOrigin( pos - Vector(0,0,20) )
				else
					ent:SetRenderOrigin(pos)
				end
				-- ent:SetRenderClipPlane( ent:GetForward(), 5 )
        end
		
        if ent and ent:IsValid() and ent.openpercent then
                ent.openpercent = 0
				
				ent:SetAngles(ang)
				if ent:OnFloor() then
					ent:SetRenderOrigin( pos - Vector(0,0,20) )
				else
					ent:SetRenderOrigin(pos)
				end
				-- ent:SetRenderClipPlane( ent:GetForward(), 5 )
        end
		
        if ent and ent:IsValid() and ent.openpercent_material then
                ent.openpercent_material = 0
				
				ent:SetAngles(ang)
				if ent:OnFloor() then
					ent:SetRenderOrigin( pos - Vector(0,0,20) )
				else
					ent:SetRenderOrigin(pos)
				end
				-- ent:SetRenderClipPlane( ent:GetForward(), 5 )
        end
		
end)

--I think this is from sassilization..
local function IsInFront( posA, posB, normal )

        local Vec1 = ( posB - posA ):GetNormalized()

        return ( normal:Dot( Vec1 ) < 0 )
		-- return true

end

local function GetGlowColor(portalColor, saturation)
    if portalColor >= 14 then
        return Color(50, 50, 50, 255)
    elseif portalColor >= 13 then
        return Color(200, 200, 200, 255)
    elseif portalColor >= 12 then
        return Color(255, 255, 255, 255)
    elseif portalColor >= 11 then
        if saturation >= 2 then
            return Color(171, 117, 145, 255)
        elseif saturation >= 1 then
            return Color(199, 89, 146, 255)
        else
            return Color(255, 32, 150, 255)
        end
    elseif portalColor >= 10 then
        if saturation >= 2 then
            return Color(171, 117, 171, 255)
        elseif saturation >= 1 then
            return Color(198, 89, 199, 255)
        else
            return Color(250, 32, 255, 255)
        end
    elseif portalColor >= 9 then
        if saturation >= 2 then
            return Color(156, 137, 183, 255)
        elseif saturation >= 1 then
            return Color(153, 113, 207, 255)
        else
            return Color(145, 64, 255, 255)
        end
    elseif portalColor >= 8 then
        if saturation >= 2 then
            return Color(117, 124, 171, 255)
        elseif saturation >= 1 then
            return Color(89, 104, 199, 255)
        else
            return Color(0, 32, 255, 255)
        end
    elseif portalColor >= 7 then
        if saturation >= 2 then
            return Color(137, 150, 183, 255)
        elseif saturation >= 1 then
            return Color(113, 139, 207, 255)
        else
            return Color(0, 80, 255, 255)
        end
    elseif portalColor >= 6 then
        if saturation >= 2 then
            return Color(117, 171, 171, 255)
        elseif saturation >= 1 then
            return Color(89, 198, 198, 255)
        else
            return Color(32, 250, 255, 255)
        end
    elseif portalColor >= 5 then
        if saturation >= 2 then
            return Color(114, 164, 143, 255)
        elseif saturation >= 1 then
            return Color(87, 195, 145, 255)
        else
            return Color(32, 250, 150, 255)
        end
    elseif portalColor >= 4 then
        if saturation >= 2 then
            return Color(114, 164, 114, 255)
        elseif saturation >= 1 then
            return Color(87, 195, 87, 255)
        else
            return Color(32, 250, 32, 255)
        end
    elseif portalColor >= 3 then
        if saturation >= 2 then
            return Color(132, 156, 94, 255)
        elseif saturation >= 1 then
            return Color(139, 188, 62, 255)
        else
            return Color(150, 250, 0, 255)
        end
    elseif portalColor >= 2 then
        if saturation >= 2 then
            return Color(171, 171, 117, 255)
        elseif saturation >= 1 then
            return Color(199, 198, 89, 255)
        else
            return Color(255, 250, 32, 255)
        end
    elseif portalColor >= 1 then
        if saturation >= 2 then
            return Color(171, 144, 117, 255)
        elseif saturation >= 1 then
            return Color(199, 143, 83, 255)
        else
            return Color(255, 107, 0, 255)
        end
    else
        if saturation >= 2 then
            return Color(171, 117, 117, 255)
        elseif saturation >= 1 then
            return Color(199, 89, 89, 255)
        else
            return Color(255, 16, 16, 255)
        end
    end
end

local function GetBrightness(contrast)
    if contrast >= 2 then
        return 7
    elseif contrast >= 1 then
        return 5
    else
        return 3
    end
end

function ENT:Think()
    if not self:GetNWBool("Potal:Activated", false) then return end

    self.openpercent = math.Approach(self.openpercent, 1, FrameTime() * 3.4 * (0.75 + self.openpercent - 0.49))
    self.openpercent_bordermat = math.Approach(self.openpercent_bordermat, 0, FrameTime() * 1.5)
    self.openpercent_material = math.Approach(self.openpercent_material, 1, FrameTime() * 0.75)

    if not dlightenabled:GetBool() then return end

    local portaltype = self:GetNWInt("Potal:PortalType", TYPE_BLUE_ATLAS)
    local glowcolor, brightness

    local portalColor1 = GetConVarNumber("portal_color_ATLAS_1")
    local portalSaturation1 = GetConVarNumber("portal_color_ATLAS_saturation_1")
    glowcolor = GetGlowColor(portalColor1, portalSaturation1)

    local portalContrast1 = GetConVarNumber("portal_color_ATLAS_contraste_1")
    brightness = GetBrightness(portalContrast1)

    if portaltype == TYPE_ORANGE_ATLAS then
        local portalColor2 = GetConVarNumber("portal_color_ATLAS_2")
        local portalSaturation2 = GetConVarNumber("portal_color_ATLAS_saturation_2")
        glowcolor = GetGlowColor(portalColor2, portalSaturation2)

        local portalContrast2 = GetConVarNumber("portal_color_ATLAS_contraste_2")
        brightness = GetBrightness(portalContrast2)
    end

    local dlight = DynamicLight(self:EntIndex())
    if dlight then
        dlight.Pos = self:GetRenderOrigin() + self:GetAngles():Forward()
        dlight.r = glowcolor.r
        dlight.g = glowcolor.g
        dlight.b = glowcolor.b
        dlight.brightness = brightness
        dlight.Decay = 9999
        dlight.Size = 50
        dlight.DieTime = CurTime() + .9
        dlight.Style = 5
    end
end


-- Define the base colors and their variations
local colors = {
    "red", "orange", "yellow", "green1", "green", "green2", "blue_light", "blue", "blue_dark", "purple", "pink", "pink2", "gray1", "gray", "gray2"
}

local variations = {
    "", "_light", "_dark", "_saturation", "_saturation_light", "_saturation_dark", "_saturation_low", "_saturation_low_light", "_saturation_low_dark"
}

local prefix_variations = {
    "", "light/", "dark/", "saturation/", "saturation_light/", "saturation_dark/", "saturation_low/", "saturation_low_light/", "saturation_low_dark/"
}

local materials = {}
local textureIDs = {}

-- Function to generate material paths
local function generateMaterialPath(base, variation, prefix)
    if prefix then
        return string.format("models/portals/color_%s/portalstaticoverlay_%s", prefix, base) .. variation
    else
        return string.format("models/portals/color/portalstaticoverlay_%s", base) .. variation
    end
end

-- Function to generate surface texture IDs
local function generateTextureIDPath(base, variation, prefix)
    if prefix then
        return string.format("models/portals/color_%s/portalstaticoverlay_%s", prefix, base) .. variation
    else
        return string.format("models/portals/color/portalstaticoverlay_%s", base) .. variation
    end
end

-- Generate materials and texture IDs for normal colors
for _, color in ipairs(colors) do
    for i, variation in ipairs(variations) do
        local materialName = "color_" .. color .. variation:gsub("_", "")
        materials[materialName] = Material(generateMaterialPath(color, variation), "PortalRefract")
        textureIDs[materialName] = surface.GetTextureID(generateTextureIDPath(color, variation, prefix_variations[i]))
    end
end

-- Generate materials and texture IDs for "color_(2)" colors
for _, color in ipairs(colors) do
    for i, variation in ipairs(variations) do
        local materialName = "two_color_" .. color .. variation:gsub("_", "")
        materials[materialName] = Material(generateMaterialPath(color, variation, "(2)"), "PortalRefract")
        textureIDs[materialName] = surface.GetTextureID(generateTextureIDPath(color, variation, "(2)/" .. prefix_variations[i]))
        
        local textureIDName = "two_portals_" .. color .. variation:gsub("_", "")
        textureIDs[textureIDName] = surface.GetTextureID(generateTextureIDPath(color, variation, "(2)/" .. prefix_variations[i]))
    end
end

-- Example usage:
-- local color_red = materials.color_red
-- local two_color_red_saturation = materials.two_color_redsaturation
-- local portals_red = textureIDs.color_red
-- local two_portals_red_saturation = textureIDs.two_portals_redsaturation


function ENT:DrawPortalEffects( portaltype )

        local ang = self:GetAngles()
       
        local res = 0.1
       
        local percentopen = 1
       
        local width = ( percentopen ) * 65
        local height = ( percentopen ) * 112
		
       
        ang:RotateAroundAxis( ang:Right(), -90 )
        ang:RotateAroundAxis( ang:Up(), 90 )
       
        local origin = self:GetRenderOrigin() + ( self:GetForward() * 0.1 ) - ( self:GetUp() * height / -2 ) - ( self:GetRight() * width / -2 )
       
        cam.Start3D2D( origin, ang, res )
       
                surface.SetDrawColor( 255, 255, 255, 255 )
 
color_red:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_orange:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_yellow:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_green1:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_green:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_green2:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_blue_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_blue:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_light_blue:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_dark_blue:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_blue_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))


color_purple:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_pink:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_pink2:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_gray1:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_gray:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_gray2:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_red:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_orange:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_yellow:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_green1:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_green:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_green2:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_blue_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_blue:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_light_blue:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_dark_blue:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_blue_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))


two_color_purple:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_pink:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_pink2:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_gray1:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_gray:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_gray2:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
 
                if ( RENDERING_PORTAL or !self:GetNWBool( "Potal:Linked", false ) or !self:GetNWBool( "Potal:Activated", false )) then
     
color_red:SetFloat("$PortalStatic", 1)
color_red_light:SetFloat("$PortalStatic", 1)
color_red_dark:SetFloat("$PortalStatic", 1)
color_red_saturation:SetFloat("$PortalStatic", 1)
color_red_saturation_light:SetFloat("$PortalStatic", 1)
color_red_saturation_dark:SetFloat("$PortalStatic", 1)
color_red_saturation_low:SetFloat("$PortalStatic", 1)
color_red_saturation_low_light:SetFloat("$PortalStatic", 1)
color_red_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_orange:SetFloat("$PortalStatic", 1)
color_orange_light:SetFloat("$PortalStatic", 1)
color_orange_dark:SetFloat("$PortalStatic", 1)
color_orange_saturation:SetFloat("$PortalStatic", 1)
color_orange_saturation_light:SetFloat("$PortalStatic", 1)
color_orange_saturation_dark:SetFloat("$PortalStatic", 1)
color_orange_saturation_low:SetFloat("$PortalStatic", 1)
color_orange_saturation_low_light:SetFloat("$PortalStatic", 1)
color_orange_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_yellow:SetFloat("$PortalStatic", 1)
color_yellow_light:SetFloat("$PortalStatic", 1)
color_yellow_dark:SetFloat("$PortalStatic", 1)
color_yellow_saturation:SetFloat("$PortalStatic", 1)
color_yellow_saturation_light:SetFloat("$PortalStatic", 1)
color_yellow_saturation_dark:SetFloat("$PortalStatic", 1)
color_yellow_saturation_low:SetFloat("$PortalStatic", 1)
color_yellow_saturation_low_light:SetFloat("$PortalStatic", 1)
color_yellow_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_green1:SetFloat("$PortalStatic", 1)
color_green1_light:SetFloat("$PortalStatic", 1)
color_green1_dark:SetFloat("$PortalStatic", 1)
color_green1_saturation:SetFloat("$PortalStatic", 1)
color_green1_saturation_light:SetFloat("$PortalStatic", 1)
color_green1_saturation_dark:SetFloat("$PortalStatic", 1)
color_green1_saturation_low:SetFloat("$PortalStatic", 1)
color_green1_saturation_low_light:SetFloat("$PortalStatic", 1)
color_green1_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_green:SetFloat("$PortalStatic", 1)
color_green_light:SetFloat("$PortalStatic", 1)
color_green_dark:SetFloat("$PortalStatic", 1)
color_green_saturation:SetFloat("$PortalStatic", 1)
color_green_saturation_light:SetFloat("$PortalStatic", 1)
color_green_saturation_dark:SetFloat("$PortalStatic", 1)
color_green_saturation_low:SetFloat("$PortalStatic", 1)
color_green_saturation_low_light:SetFloat("$PortalStatic", 1)
color_green_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_green2:SetFloat("$PortalStatic", 1)
color_green2_light:SetFloat("$PortalStatic", 1)
color_green2_dark:SetFloat("$PortalStatic", 1)
color_green2_saturation:SetFloat("$PortalStatic", 1)
color_green2_saturation_light:SetFloat("$PortalStatic", 1)
color_green2_saturation_dark:SetFloat("$PortalStatic", 1)
color_green2_saturation_low:SetFloat("$PortalStatic", 1)
color_green2_saturation_low_light:SetFloat("$PortalStatic", 1)
color_green2_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_blue_light:SetFloat("$PortalStatic", 1)
color_blue_light_light:SetFloat("$PortalStatic", 1)
color_blue_light_dark:SetFloat("$PortalStatic", 1)
color_blue_light_saturation:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_light:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_dark:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_low:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_low_light:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_blue:SetFloat("$PortalStatic", 1)
color_light_blue:SetFloat("$PortalStatic", 1)
color_dark_blue:SetFloat("$PortalStatic", 1)
color_blue_saturation:SetFloat("$PortalStatic", 1)
color_blue_saturation_light:SetFloat("$PortalStatic", 1)
color_blue_saturation_dark:SetFloat("$PortalStatic", 1)
color_blue_saturation_low:SetFloat("$PortalStatic", 1)
color_blue_saturation_low_light:SetFloat("$PortalStatic", 1)
color_blue_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_blue_dark:SetFloat("$PortalStatic", 1)
color_blue_dark_light:SetFloat("$PortalStatic", 1)
color_blue_dark_dark:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_light:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_dark:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_low:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_low_light:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_low_dark:SetFloat("$PortalStatic", 1)


color_purple:SetFloat("$PortalStatic", 1)
color_purple_light:SetFloat("$PortalStatic", 1)
color_purple_dark:SetFloat("$PortalStatic", 1)
color_purple_saturation:SetFloat("$PortalStatic", 1)
color_purple_saturation_light:SetFloat("$PortalStatic", 1)
color_purple_saturation_dark:SetFloat("$PortalStatic", 1)
color_purple_saturation_low:SetFloat("$PortalStatic", 1)
color_purple_saturation_low_light:SetFloat("$PortalStatic", 1)
color_purple_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_pink:SetFloat("$PortalStatic", 1)
color_pink_light:SetFloat("$PortalStatic", 1)
color_pink_dark:SetFloat("$PortalStatic", 1)
color_pink_saturation:SetFloat("$PortalStatic", 1)
color_pink_saturation_light:SetFloat("$PortalStatic", 1)
color_pink_saturation_dark:SetFloat("$PortalStatic", 1)
color_pink_saturation_low:SetFloat("$PortalStatic", 1)
color_pink_saturation_low_light:SetFloat("$PortalStatic", 1)
color_pink_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_pink2:SetFloat("$PortalStatic", 1)
color_pink2_light:SetFloat("$PortalStatic", 1)
color_pink2_dark:SetFloat("$PortalStatic", 1)
color_pink2_saturation:SetFloat("$PortalStatic", 1)
color_pink2_saturation_light:SetFloat("$PortalStatic", 1)
color_pink2_saturation_dark:SetFloat("$PortalStatic", 1)
color_pink2_saturation_low:SetFloat("$PortalStatic", 1)
color_pink2_saturation_low_light:SetFloat("$PortalStatic", 1)
color_pink2_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_gray1:SetFloat("$PortalStatic", 1)
color_gray:SetFloat("$PortalStatic", 1)
color_gray2:SetFloat("$PortalStatic", 1)

two_color_red:SetFloat("$PortalStatic", 1)
two_color_red_light:SetFloat("$PortalStatic", 1)
two_color_red_dark:SetFloat("$PortalStatic", 1)
two_color_red_saturation:SetFloat("$PortalStatic", 1)
two_color_red_saturation_light:SetFloat("$PortalStatic", 1)
two_color_red_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_red_saturation_low:SetFloat("$PortalStatic", 1)
two_color_red_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_red_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_orange:SetFloat("$PortalStatic", 1)
two_color_orange_light:SetFloat("$PortalStatic", 1)
two_color_orange_dark:SetFloat("$PortalStatic", 1)
two_color_orange_saturation:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_light:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_low:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_yellow:SetFloat("$PortalStatic", 1)
two_color_yellow_light:SetFloat("$PortalStatic", 1)
two_color_yellow_dark:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_light:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_low:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_green1:SetFloat("$PortalStatic", 1)
two_color_green1_light:SetFloat("$PortalStatic", 1)
two_color_green1_dark:SetFloat("$PortalStatic", 1)
two_color_green1_saturation:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_light:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_low:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_green:SetFloat("$PortalStatic", 1)
two_color_green_light:SetFloat("$PortalStatic", 1)
two_color_green_dark:SetFloat("$PortalStatic", 1)
two_color_green_saturation:SetFloat("$PortalStatic", 1)
two_color_green_saturation_light:SetFloat("$PortalStatic", 1)
two_color_green_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_green_saturation_low:SetFloat("$PortalStatic", 1)
two_color_green_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_green_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_green2:SetFloat("$PortalStatic", 1)
two_color_green2_light:SetFloat("$PortalStatic", 1)
two_color_green2_dark:SetFloat("$PortalStatic", 1)
two_color_green2_saturation:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_light:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_low:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_blue_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_dark:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_low:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_blue:SetFloat("$PortalStatic", 1)
two_color_light_blue:SetFloat("$PortalStatic", 1)
two_color_dark_blue:SetFloat("$PortalStatic", 1)
two_color_blue_saturation:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_light:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_low:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_blue_dark:SetFloat("$PortalStatic", 1)
two_color_blue_dark_light:SetFloat("$PortalStatic", 1)
two_color_blue_dark_dark:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_light:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_low:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_low_dark:SetFloat("$PortalStatic", 1)


two_color_purple:SetFloat("$PortalStatic", 1)
two_color_purple_light:SetFloat("$PortalStatic", 1)
two_color_purple_dark:SetFloat("$PortalStatic", 1)
two_color_purple_saturation:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_light:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_low:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_pink:SetFloat("$PortalStatic", 1)
two_color_pink_light:SetFloat("$PortalStatic", 1)
two_color_pink_dark:SetFloat("$PortalStatic", 1)
two_color_pink_saturation:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_light:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_low:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_pink2:SetFloat("$PortalStatic", 1)
two_color_pink2_light:SetFloat("$PortalStatic", 1)
two_color_pink2_dark:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_light:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_low:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_gray1:SetFloat("$PortalStatic", 1)
two_color_gray:SetFloat("$PortalStatic", 1)
two_color_gray2:SetFloat("$PortalStatic", 1)

			   
                        if portaltype == TYPE_BLUE_ATLAS then
						if GetConVarNumber("portal_color_ATLAS_1") >=14 then
                                        surface.SetTexture( portals_gray2 )
								elseif GetConVarNumber("portal_color_ATLAS_1") >=13 then
                                        surface.SetTexture( portals_gray )
								elseif GetConVarNumber("portal_color_ATLAS_1") >=12 then
                                        surface.SetTexture( portals_gray1 )
								elseif GetConVarNumber("portal_color_ATLAS_1") >=11 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_pink2_saturation_light )
									else surface.SetTexture( portals_pink2_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_pink2_saturation )
									else surface.SetTexture( portals_pink2 ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_pink2_saturation_dark )
									else surface.SetTexture( portals_pink2_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=10 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_pink_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_pink_saturation_light )
									else surface.SetTexture( portals_pink_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_pink_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_pink_saturation )
									else surface.SetTexture( portals_pink ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_pink_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_pink_saturation_dark )
									else surface.SetTexture( portals_pink_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=9 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_purple_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_purple_saturation_light )
									else surface.SetTexture( portals_purple_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_purple_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_purple_saturation )
									else surface.SetTexture( portals_purple ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_purple_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_purple_saturation_dark )
									else surface.SetTexture( portals_purple_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=8 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation_light )
									else surface.SetTexture( portals_blue_dark_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation )
									else surface.SetTexture( portals_blue_dark ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation_dark )
									else surface.SetTexture( portals_blue_dark_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=7 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_saturation_light )
									else surface.SetTexture( portals_light_blue ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_saturation )
									else surface.SetTexture( portals_blue ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_saturation_dark )
									else surface.SetTexture( portals_dark_blue ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=6 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_light_saturation_light )
									else surface.SetTexture( portals_blue_light_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_light_saturation )
									else surface.SetTexture( portals_blue_light ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_light_saturation_dark )
									else surface.SetTexture( portals_blue_light_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=5 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green2_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green2_saturation_light )
									else surface.SetTexture( portals_green2_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green2_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green2_saturation )
									else surface.SetTexture( portals_green2 ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green2_saturation_dark )
									else surface.SetTexture( portals_green2_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=4 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green_saturation_light )
									else surface.SetTexture( portals_green_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green_saturation )
									else surface.SetTexture( portals_green ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green_saturation_dark )
									else surface.SetTexture( portals_green_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=3 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green1_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green1_saturation_light )
									else surface.SetTexture( portals_green1_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green1_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green1_saturation )
									else surface.SetTexture( portals_green1 ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green1_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green1_saturation_dark )
									else surface.SetTexture( portals_green1_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=2 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_yellow_saturation_light )
									else surface.SetTexture( portals_yellow_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_yellow_saturation )
									else surface.SetTexture( portals_yellow ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_yellow_saturation_dark )
									else surface.SetTexture( portals_yellow_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=1 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_orange_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_orange_saturation_light )
									else surface.SetTexture( portals_orange_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_orange_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_orange_saturation )
									else surface.SetTexture( portals_orange ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_orange_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_orange_saturation_dark )
									else surface.SetTexture( portals_orange_dark ) end
							end
								else
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_red_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_red_saturation_light )
									else surface.SetTexture( portals_red_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_red_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_red_saturation )
									else surface.SetTexture( portals_red ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_red_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_red_saturation_dark )
									else surface.SetTexture( portals_red_dark ) end
							end
				end
								
                        elseif portaltype == TYPE_ORANGE_ATLAS then
						
						if GetConVarNumber("portal_color_ATLAS_2") >=14 then
                                        surface.SetTexture( portals_gray2 )
								elseif GetConVarNumber("portal_color_ATLAS_2") >=13 then
                                        surface.SetTexture( portals_gray )
								elseif GetConVarNumber("portal_color_ATLAS_2") >=12 then
                                        surface.SetTexture( portals_gray1 )
								elseif GetConVarNumber("portal_color_ATLAS_2") >=11 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_pink2_saturation_light )
									else surface.SetTexture( portals_pink2_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_pink2_saturation )
									else surface.SetTexture( portals_pink2 ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_pink2_saturation_dark )
									else surface.SetTexture( portals_pink2_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=10 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_pink_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_pink_saturation_light )
									else surface.SetTexture( portals_pink_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_pink_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_pink_saturation )
									else surface.SetTexture( portals_pink ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_pink_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_pink_saturation_dark )
									else surface.SetTexture( portals_pink_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=9 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_purple_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_purple_saturation_light )
									else surface.SetTexture( portals_purple_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_purple_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_purple_saturation )
									else surface.SetTexture( portals_purple ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_purple_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_purple_saturation_dark )
									else surface.SetTexture( portals_purple_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=8 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation_light )
									else surface.SetTexture( portals_blue_dark_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation )
									else surface.SetTexture( portals_blue_dark ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation_dark )
									else surface.SetTexture( portals_blue_dark_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=7 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_saturation_light )
									else surface.SetTexture( portals_light_blue ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_saturation )
									else surface.SetTexture( portals_blue ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_saturation_dark )
									else surface.SetTexture( portals_dark_blue ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=6 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_light_saturation_light )
									else surface.SetTexture( portals_blue_light_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_light_saturation )
									else surface.SetTexture( portals_blue_light ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_light_saturation_dark )
									else surface.SetTexture( portals_blue_light_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=5 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_green2_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_green2_saturation_light )
									else surface.SetTexture( portals_green2_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_green2_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_green2_saturation )
									else surface.SetTexture( portals_green2 ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_green2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_green2_saturation_dark )
									else surface.SetTexture( portals_green2_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=4 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_green_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_green_saturation_light )
									else surface.SetTexture( portals_green_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_green_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_green_saturation )
									else surface.SetTexture( portals_green ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_green_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_green_saturation_dark )
									else surface.SetTexture( portals_green_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=3 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_green1_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_green1_saturation_light )
									else surface.SetTexture( portals_green1_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_green1_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_green1_saturation )
									else surface.SetTexture( portals_green1 ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_green1_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_green1_saturation_dark )
									else surface.SetTexture( portals_green1_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=2 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_yellow_saturation_light )
									else surface.SetTexture( portals_yellow_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_yellow_saturation )
									else surface.SetTexture( portals_yellow ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_yellow_saturation_dark )
									else surface.SetTexture( portals_yellow_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=1 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_orange_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_orange_saturation_light )
									else surface.SetTexture( portals_orange_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_orange_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_orange_saturation )
									else surface.SetTexture( portals_orange ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_orange_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_orange_saturation_dark )
									else surface.SetTexture( portals_orange_dark ) end
							end
								else
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_red_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_red_saturation_light )
									else surface.SetTexture( portals_red_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_red_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_red_saturation )
									else surface.SetTexture( portals_red ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( portals_red_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( portals_red_saturation_dark )
									else surface.SetTexture( portals_red_dark ) end
							end
				end

						end
                       
                        surface.DrawTexturedRect( 0, 0, width / res , height / res )
                       
                end
				
                if bordersenabled:GetBool() == true then                    
                        if portaltype == TYPE_BLUE_ATLAS then
						   if ( self:GetNWBool( "Potal:Linked", false ) or !self:GetNWBool( "Potal:Activated", false )) then

						if GetConVarNumber("portal_color_ATLAS_1") >=14 then
                                        surface.SetTexture( portals_gray2 )
								elseif GetConVarNumber("portal_color_ATLAS_1") >=13 then
                                        surface.SetTexture( portals_gray )
								elseif GetConVarNumber("portal_color_ATLAS_1") >=12 then
                                        surface.SetTexture( portals_gray1 )
								elseif GetConVarNumber("portal_color_ATLAS_1") >=11 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_pink2_saturation_light )
									else surface.SetTexture( portals_pink2_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_pink2_saturation )
									else surface.SetTexture( portals_pink2 ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_pink2_saturation_dark )
									else surface.SetTexture( portals_pink2_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=10 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_pink_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_pink_saturation_light )
									else surface.SetTexture( portals_pink_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_pink_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_pink_saturation )
									else surface.SetTexture( portals_pink ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_pink_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_pink_saturation_dark )
									else surface.SetTexture( portals_pink_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=9 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_purple_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_purple_saturation_light )
									else surface.SetTexture( portals_purple_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_purple_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_purple_saturation )
									else surface.SetTexture( portals_purple ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_purple_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_purple_saturation_dark )
									else surface.SetTexture( portals_purple_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=8 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation_light )
									else surface.SetTexture( portals_blue_dark_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation )
									else surface.SetTexture( portals_blue_dark ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation_dark )
									else surface.SetTexture( portals_blue_dark_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=7 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_saturation_light )
									else surface.SetTexture( portals_light_blue ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_saturation )
									else surface.SetTexture( portals_blue ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_saturation_dark )
									else surface.SetTexture( portals_dark_blue ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=6 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_light_saturation_light )
									else surface.SetTexture( portals_blue_light_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_light_saturation )
									else surface.SetTexture( portals_blue_light ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_light_saturation_dark )
									else surface.SetTexture( portals_blue_light_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=5 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green2_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green2_saturation_light )
									else surface.SetTexture( portals_green2_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green2_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green2_saturation )
									else surface.SetTexture( portals_green2 ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green2_saturation_dark )
									else surface.SetTexture( portals_green2_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=4 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green_saturation_light )
									else surface.SetTexture( portals_green_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green_saturation )
									else surface.SetTexture( portals_green ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green_saturation_dark )
									else surface.SetTexture( portals_green_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=3 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green1_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green1_saturation_light )
									else surface.SetTexture( portals_green1_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green1_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green1_saturation )
									else surface.SetTexture( portals_green1 ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_green1_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_green1_saturation_dark )
									else surface.SetTexture( portals_green1_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=2 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_yellow_saturation_light )
									else surface.SetTexture( portals_yellow_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_yellow_saturation )
									else surface.SetTexture( portals_yellow ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_yellow_saturation_dark )
									else surface.SetTexture( portals_yellow_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_1") >=1 then
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_orange_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_orange_saturation_light )
									else surface.SetTexture( portals_orange_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_orange_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_orange_saturation )
									else surface.SetTexture( portals_orange ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_orange_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_orange_saturation_dark )
									else surface.SetTexture( portals_orange_dark ) end
							end
								else
							if GetConVarNumber("portal_color_ATLAS_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_red_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_red_saturation_light )
									else surface.SetTexture( portals_red_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_red_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_red_saturation )
									else surface.SetTexture( portals_red ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_1") >=2 then 
										surface.SetTexture( portals_red_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_1") >=1 then 
											surface.SetTexture( portals_red_saturation_dark )
									else surface.SetTexture( portals_red_dark ) end
							end
				end

                    end
                               
                                surface.DrawTexturedRect( 0, 0, width / res , height / res )
                               
                        elseif portaltype == TYPE_ORANGE_ATLAS then
                             if ( self:GetNWBool( "Potal:Linked", false ) or !self:GetNWBool( "Potal:Activated", false )) then

						if GetConVarNumber("portal_color_ATLAS_2") >=14 then
                                        surface.SetTexture( two_portals_gray2 )
								elseif GetConVarNumber("portal_color_ATLAS_2") >=13 then
                                        surface.SetTexture( two_portals_gray )
								elseif GetConVarNumber("portal_color_ATLAS_2") >=12 then
                                        surface.SetTexture( two_portals_gray1 )
								elseif GetConVarNumber("portal_color_ATLAS_2") >=11 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_pink2_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_pink2_saturation_light )
									else surface.SetTexture( two_portals_pink2_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_pink2_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_pink2_saturation )
									else surface.SetTexture( two_portals_pink2 ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_pink2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_pink2_saturation_dark )
									else surface.SetTexture( two_portals_pink2_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=10 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_pink_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_pink_saturation_light )
									else surface.SetTexture( two_portals_pink_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_pink_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_pink_saturation )
									else surface.SetTexture( two_portals_pink ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_pink_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_pink_saturation_dark )
									else surface.SetTexture( two_portals_pink_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=9 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_purple_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_purple_saturation_light )
									else surface.SetTexture( two_portals_purple_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_purple_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_purple_saturation )
									else surface.SetTexture( two_portals_purple ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_purple_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_purple_saturation_dark )
									else surface.SetTexture( two_portals_purple_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=8 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_dark_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_dark_saturation_light )
									else surface.SetTexture( two_portals_blue_dark_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_dark_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_dark_saturation )
									else surface.SetTexture( two_portals_blue_dark ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_dark_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_dark_saturation_dark )
									else surface.SetTexture( two_portals_blue_dark_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=7 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_saturation_light )
									else surface.SetTexture( two_portals_light_blue ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_saturation )
									else surface.SetTexture( two_portals_blue ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_saturation_dark )
									else surface.SetTexture( two_portals_dark_blue ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=6 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_light_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_light_saturation_light )
									else surface.SetTexture( two_portals_blue_light_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_light_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_light_saturation )
									else surface.SetTexture( two_portals_blue_light ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_light_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_light_saturation_dark )
									else surface.SetTexture( two_portals_blue_light_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=5 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green2_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green2_saturation_light )
									else surface.SetTexture( two_portals_green2_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green2_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green2_saturation )
									else surface.SetTexture( two_portals_green2 ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green2_saturation_dark )
									else surface.SetTexture( two_portals_green2_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=4 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green_saturation_light )
									else surface.SetTexture( two_portals_green_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green_saturation )
									else surface.SetTexture( two_portals_green ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green_saturation_dark )
									else surface.SetTexture( two_portals_green_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=3 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green1_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green1_saturation_light )
									else surface.SetTexture( two_portals_green1_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green1_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green1_saturation )
									else surface.SetTexture( two_portals_green1 ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green1_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green1_saturation_dark )
									else surface.SetTexture( two_portals_green1_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=2 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_yellow_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_yellow_saturation_light )
									else surface.SetTexture( two_portals_yellow_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_yellow_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_yellow_saturation )
									else surface.SetTexture( two_portals_yellow ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_yellow_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_yellow_saturation_dark )
									else surface.SetTexture( two_portals_yellow_dark ) end
							end
								elseif GetConVarNumber("portal_color_ATLAS_2") >=1 then
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_orange_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_orange_saturation_light )
									else surface.SetTexture( two_portals_orange_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_orange_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_orange_saturation )
									else surface.SetTexture( two_portals_orange ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_orange_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_orange_saturation_dark )
									else surface.SetTexture( two_portals_orange_dark ) end
							end
								else
							if GetConVarNumber("portal_color_ATLAS_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_red_saturation_low_light )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_red_saturation_light )
									else surface.SetTexture( two_portals_red_light ) end
							elseif GetConVarNumber("portal_color_ATLAS_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_red_saturation_low )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_red_saturation )
									else surface.SetTexture( two_portals_red ) end
							else
									if GetConVarNumber("portal_color_ATLAS_saturation_2") >=2 then 
										surface.SetTexture( two_portals_red_saturation_low_dark )
									elseif GetConVarNumber("portal_color_ATLAS_saturation_2") >=1 then 
											surface.SetTexture( two_portals_red_saturation_dark )
									else surface.SetTexture( two_portals_red_dark ) end
							end
				end

                             end
                                surface.DrawTexturedRect( 0, 0, width / res , height / res )
                               
                        end
                       
                end
               
        cam.End3D2D()
       
end

function ENT:Draw()
	self:SetModelScale( self.openpercent,0 )
	self:DrawModel()
	self:SetColor(Color(255,255,255,0))
	
end
function ENT:DrawPortal()
	local viewent = GetViewEntity()
	local pos = ( IsValid( viewent ) and viewent != LocalPlayer() ) and GetViewEntity():GetPos() or EyePos()

	if IsInFront( pos, self:GetRenderOrigin(), self:GetForward() ) and self:GetNWBool("Potal:Activated",false) then
		
		render.ClearStencil() -- Make sure the stencil buffer is all zeroes before we begin
		render.SetStencilEnable( true )
		
			cam.Start3D2D(self:GetRenderOrigin(),self:GetAngles(),1)
				
				render.SetStencilWriteMask(3)
				render.SetStencilTestMask(3)
				render.SetStencilFailOperation( STENCILOPERATION_KEEP )
				render.SetStencilZFailOperation( STENCILOPERATION_KEEP )  -- Don't change anything if the pixel is occoludded (so we don't see things thru walls)
				render.SetStencilPassOperation( STENCILOPERATION_REPLACE ) -- Replace the value of the buffer's pixel with the reference value
				render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS) -- Always replace regardless of whatever is in the stencil buffer currently

				render.SetStencilReferenceValue( 1 )
			   
				local percentopen = self.openpercent
				self:SetModelScale( percentopen,0 )
				self:DrawModel()
				
				render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
				
				--Draw portal.
				local portaltype = self:GetNWInt( "Potal:PortalType",TYPE_BLUE_ATLAS )
				if renderportals:GetBool() then
				local ToRT = portaltype == TYPE_BLUE_ATLAS and texFSB or texFSB2
				local no_RT = Material ("effects/tvscreen_noise002a")
				if GetConVarNumber("portal_texFSB") >=2 then
					PortalMaterial:SetTexture( "$basetexture", ToRT )
					render.SetMaterial( no_RT )
					render.DrawScreenQuad()
	
				elseif GetConVarNumber("portal_texFSB") >=1 then
					PortalMaterial:SetTexture( "$basetexture", ToRT )
					render.SetMaterial( PortalMaterial )
					render.DrawScreenQuad()
					
				else
					PortalMaterial:SetTexture( "$basetexture", ToRT )
					render.SetMaterial( no_RT )
					render.DrawScreenQuad()

				end
				end
				
				--Draw colored overlay.

				if portaltype == TYPE_ORANGE_ATLAS then

				end
				local other = self:GetNWEntity("Potal:Other")
				if other and other:IsValid() and other.openpercent_material then
					if renderportals:GetBool() then
					
color_red:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_orange:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_yellow:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_green1:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_green:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_green2:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_blue_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_blue:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_light_blue:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_dark_blue:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_blue_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))


color_purple:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_pink:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_pink2:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_gray1:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_gray:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_gray2:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_red:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_orange:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_yellow:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_green1:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_green:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_green2:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_blue_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_blue:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_light_blue:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_dark_blue:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_blue_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))


two_color_purple:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_pink:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_pink2:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_gray1:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_gray:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_gray2:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
					
					else
					
color_red:SetFloat("$PortalStatic", 1)
color_red_light:SetFloat("$PortalStatic", 1)
color_red_dark:SetFloat("$PortalStatic", 1)
color_red_saturation:SetFloat("$PortalStatic", 1)
color_red_saturation_light:SetFloat("$PortalStatic", 1)
color_red_saturation_dark:SetFloat("$PortalStatic", 1)
color_red_saturation_low:SetFloat("$PortalStatic", 1)
color_red_saturation_low_light:SetFloat("$PortalStatic", 1)
color_red_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_orange:SetFloat("$PortalStatic", 1)
color_orange_light:SetFloat("$PortalStatic", 1)
color_orange_dark:SetFloat("$PortalStatic", 1)
color_orange_saturation:SetFloat("$PortalStatic", 1)
color_orange_saturation_light:SetFloat("$PortalStatic", 1)
color_orange_saturation_dark:SetFloat("$PortalStatic", 1)
color_orange_saturation_low:SetFloat("$PortalStatic", 1)
color_orange_saturation_low_light:SetFloat("$PortalStatic", 1)
color_orange_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_yellow:SetFloat("$PortalStatic", 1)
color_yellow_light:SetFloat("$PortalStatic", 1)
color_yellow_dark:SetFloat("$PortalStatic", 1)
color_yellow_saturation:SetFloat("$PortalStatic", 1)
color_yellow_saturation_light:SetFloat("$PortalStatic", 1)
color_yellow_saturation_dark:SetFloat("$PortalStatic", 1)
color_yellow_saturation_low:SetFloat("$PortalStatic", 1)
color_yellow_saturation_low_light:SetFloat("$PortalStatic", 1)
color_yellow_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_green1:SetFloat("$PortalStatic", 1)
color_green1_light:SetFloat("$PortalStatic", 1)
color_green1_dark:SetFloat("$PortalStatic", 1)
color_green1_saturation:SetFloat("$PortalStatic", 1)
color_green1_saturation_light:SetFloat("$PortalStatic", 1)
color_green1_saturation_dark:SetFloat("$PortalStatic", 1)
color_green1_saturation_low:SetFloat("$PortalStatic", 1)
color_green1_saturation_low_light:SetFloat("$PortalStatic", 1)
color_green1_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_green:SetFloat("$PortalStatic", 1)
color_green_light:SetFloat("$PortalStatic", 1)
color_green_dark:SetFloat("$PortalStatic", 1)
color_green_saturation:SetFloat("$PortalStatic", 1)
color_green_saturation_light:SetFloat("$PortalStatic", 1)
color_green_saturation_dark:SetFloat("$PortalStatic", 1)
color_green_saturation_low:SetFloat("$PortalStatic", 1)
color_green_saturation_low_light:SetFloat("$PortalStatic", 1)
color_green_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_green2:SetFloat("$PortalStatic", 1)
color_green2_light:SetFloat("$PortalStatic", 1)
color_green2_dark:SetFloat("$PortalStatic", 1)
color_green2_saturation:SetFloat("$PortalStatic", 1)
color_green2_saturation_light:SetFloat("$PortalStatic", 1)
color_green2_saturation_dark:SetFloat("$PortalStatic", 1)
color_green2_saturation_low:SetFloat("$PortalStatic", 1)
color_green2_saturation_low_light:SetFloat("$PortalStatic", 1)
color_green2_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_blue_light:SetFloat("$PortalStatic", 1)
color_blue_light_light:SetFloat("$PortalStatic", 1)
color_blue_light_dark:SetFloat("$PortalStatic", 1)
color_blue_light_saturation:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_light:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_dark:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_low:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_low_light:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_blue:SetFloat("$PortalStatic", 1)
color_light_blue:SetFloat("$PortalStatic", 1)
color_dark_blue:SetFloat("$PortalStatic", 1)
color_blue_saturation:SetFloat("$PortalStatic", 1)
color_blue_saturation_light:SetFloat("$PortalStatic", 1)
color_blue_saturation_dark:SetFloat("$PortalStatic", 1)
color_blue_saturation_low:SetFloat("$PortalStatic", 1)
color_blue_saturation_low_light:SetFloat("$PortalStatic", 1)
color_blue_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_blue_dark:SetFloat("$PortalStatic", 1)
color_blue_dark_light:SetFloat("$PortalStatic", 1)
color_blue_dark_dark:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_light:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_dark:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_low:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_low_light:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_low_dark:SetFloat("$PortalStatic", 1)


color_purple:SetFloat("$PortalStatic", 1)
color_purple_light:SetFloat("$PortalStatic", 1)
color_purple_dark:SetFloat("$PortalStatic", 1)
color_purple_saturation:SetFloat("$PortalStatic", 1)
color_purple_saturation_light:SetFloat("$PortalStatic", 1)
color_purple_saturation_dark:SetFloat("$PortalStatic", 1)
color_purple_saturation_low:SetFloat("$PortalStatic", 1)
color_purple_saturation_low_light:SetFloat("$PortalStatic", 1)
color_purple_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_pink:SetFloat("$PortalStatic", 1)
color_pink_light:SetFloat("$PortalStatic", 1)
color_pink_dark:SetFloat("$PortalStatic", 1)
color_pink_saturation:SetFloat("$PortalStatic", 1)
color_pink_saturation_light:SetFloat("$PortalStatic", 1)
color_pink_saturation_dark:SetFloat("$PortalStatic", 1)
color_pink_saturation_low:SetFloat("$PortalStatic", 1)
color_pink_saturation_low_light:SetFloat("$PortalStatic", 1)
color_pink_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_pink2:SetFloat("$PortalStatic", 1)
color_pink2_light:SetFloat("$PortalStatic", 1)
color_pink2_dark:SetFloat("$PortalStatic", 1)
color_pink2_saturation:SetFloat("$PortalStatic", 1)
color_pink2_saturation_light:SetFloat("$PortalStatic", 1)
color_pink2_saturation_dark:SetFloat("$PortalStatic", 1)
color_pink2_saturation_low:SetFloat("$PortalStatic", 1)
color_pink2_saturation_low_light:SetFloat("$PortalStatic", 1)
color_pink2_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_gray1:SetFloat("$PortalStatic", 1)
color_gray:SetFloat("$PortalStatic", 1)
color_gray2:SetFloat("$PortalStatic", 1)

two_color_red:SetFloat("$PortalStatic", 1)
two_color_red_light:SetFloat("$PortalStatic", 1)
two_color_red_dark:SetFloat("$PortalStatic", 1)
two_color_red_saturation:SetFloat("$PortalStatic", 1)
two_color_red_saturation_light:SetFloat("$PortalStatic", 1)
two_color_red_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_red_saturation_low:SetFloat("$PortalStatic", 1)
two_color_red_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_red_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_orange:SetFloat("$PortalStatic", 1)
two_color_orange_light:SetFloat("$PortalStatic", 1)
two_color_orange_dark:SetFloat("$PortalStatic", 1)
two_color_orange_saturation:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_light:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_low:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_yellow:SetFloat("$PortalStatic", 1)
two_color_yellow_light:SetFloat("$PortalStatic", 1)
two_color_yellow_dark:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_light:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_low:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_green1:SetFloat("$PortalStatic", 1)
two_color_green1_light:SetFloat("$PortalStatic", 1)
two_color_green1_dark:SetFloat("$PortalStatic", 1)
two_color_green1_saturation:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_light:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_low:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_green:SetFloat("$PortalStatic", 1)
two_color_green_light:SetFloat("$PortalStatic", 1)
two_color_green_dark:SetFloat("$PortalStatic", 1)
two_color_green_saturation:SetFloat("$PortalStatic", 1)
two_color_green_saturation_light:SetFloat("$PortalStatic", 1)
two_color_green_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_green_saturation_low:SetFloat("$PortalStatic", 1)
two_color_green_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_green_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_green2:SetFloat("$PortalStatic", 1)
two_color_green2_light:SetFloat("$PortalStatic", 1)
two_color_green2_dark:SetFloat("$PortalStatic", 1)
two_color_green2_saturation:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_light:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_low:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_blue_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_dark:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_low:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_blue:SetFloat("$PortalStatic", 1)
two_color_light_blue:SetFloat("$PortalStatic", 1)
two_color_dark_blue:SetFloat("$PortalStatic", 1)
two_color_blue_saturation:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_light:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_low:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_blue_dark:SetFloat("$PortalStatic", 1)
two_color_blue_dark_light:SetFloat("$PortalStatic", 1)
two_color_blue_dark_dark:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_light:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_low:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_low_dark:SetFloat("$PortalStatic", 1)


two_color_purple:SetFloat("$PortalStatic", 1)
two_color_purple_light:SetFloat("$PortalStatic", 1)
two_color_purple_dark:SetFloat("$PortalStatic", 1)
two_color_purple_saturation:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_light:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_low:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_pink:SetFloat("$PortalStatic", 1)
two_color_pink_light:SetFloat("$PortalStatic", 1)
two_color_pink_dark:SetFloat("$PortalStatic", 1)
two_color_pink_saturation:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_light:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_low:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_pink2:SetFloat("$PortalStatic", 1)
two_color_pink2_light:SetFloat("$PortalStatic", 1)
two_color_pink2_dark:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_light:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_low:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_gray1:SetFloat("$PortalStatic", 1)
two_color_gray:SetFloat("$PortalStatic", 1)
two_color_gray2:SetFloat("$PortalStatic", 1)
						
					end
				end
			
			cam.End3D2D()
		
		render.SetStencilEnable( false )
		
		self:DrawPortalEffects( portaltype )
	end
end
hook.Add("PostDrawOpaqueRenderables","DrawPortals ATLAS", function()
	for k,v in pairs(ents.FindByClass("prop_portal_atlas"))do
		v:DrawPortal()
	end
end)

function ENT:RenderPortal( origin, angles)
	if renderportals:GetBool() then
		local portal = self:GetNWEntity( "Potal:Other", nil )
		if IsValid( portal ) and self:GetNWBool( "Potal:Linked", false ) and self:GetNWBool( "Potal:Activated", false ) then
   
			local portaltype = self:GetNWInt( "Potal:PortalType", TYPE_BLUE_ATLAS )
		   
			local normal = self:GetForward()
			local distance = normal:Dot( self:GetRenderOrigin() )
		   
			othernormal = portal:GetForward()
			otherdistance = othernormal:Dot( portal:GetRenderOrigin() )
		   
			// quick access
			local forward = angles:Forward()
			local up = angles:Up()
		   
			// reflect origin
			local dot = origin:DotProduct( normal ) - distance
			origin = origin + ( -2 * dot ) * normal
		   
			// reflect forward
			local dot = forward:DotProduct( normal )
			forward = forward + ( -2 * dot ) * normal
		   
			// reflect up          
			local dot = up:DotProduct( normal )
			up = up + ( -2 * dot ) * normal
		   
			// convert to angles
			angles = math.VectorAngles( forward, up )
		   
			local LocalOrigin = self:WorldToLocal( origin )
			local LocalAngles = self:WorldToLocalAngles( angles )
		   
			// repair
			if self:OnFloor() and not portal:OnFloor() then
				LocalOrigin.x = LocalOrigin.x + 20
			end
			
-- Fixed ViewRender Portals
			
			if portal:OnFloor() and  self:IsHorizontal() then
				LocalOrigin.x = LocalOrigin.x - 20
			end
			
			LocalOrigin.y = -LocalOrigin.y
			LocalAngles.y = -LocalAngles.y
			LocalAngles.r = -LocalAngles.r
		   
			view = {}
			view.x = 0
			view.y = 0
			view.w = ScrW()
			view.h = ScrH()
			view.origin = portal:LocalToWorld( LocalOrigin )
			view.angles = portal:LocalToWorldAngles( LocalAngles )
			view.drawhud = false
			view.drawviewmodel = false
			
			local oldrt = render.GetRenderTarget()
		   
			local ToRT = portaltype == TYPE_BLUE_ATLAS and texFSB or texFSB2
		   
			render.SetRenderTarget( ToRT )
				render.PushCustomClipPlane( othernormal, otherdistance )
				local b = render.EnableClipping(true)
					render.Clear( 0, 0, 0, 255 )
					render.ClearDepth()
					render.ClearStencil()
					
					portal:SetNoDraw( true )
						RENDERING_PORTAL = self
							render.RenderView( view )
							render.UpdateScreenEffectTexture()
						RENDERING_PORTAL = false
					portal:SetNoDraw( false )
					
				render.PopCustomClipPlane()
				render.EnableClipping(b)
			render.SetRenderTarget( oldrt ) 
		end
	end
end

/*------------------------------------
        ShouldDrawLocalPlayer()
------------------------------------*/
-- Draw yourself into the portal (Bug? Can't see your weapons)
hook.Add("ShouldDrawLocalPlayer ATLAS", "Portal.ShouldDrawLocalPlayer ATLAS", function()
    local ply = LocalPlayer()
    local portal = ply.InPortal
    if RENDERING_PORTAL then
        return true
    end
    -- Uncomment and adjust the code below if needed for additional functionality
    -- elseif IsValid(portal) then
    --     local pos, ang = portal:GetPortalPosOffsets(portal:GetOther(), ply), portal:GetPortalAngleOffsets(portal:GetOther(), ply)
    --     pos.z = pos.z - 64
    --     ply:SetRenderOrigin(pos)
    --     ply:SetRenderAngles(ang)
    --     return true
end)

hook.Add("PostDrawEffects ATLAS", "PortalSimulation_PlayerRenderFix ATLAS", function()
    cam.Start3D(EyePos(), EyeAngles())
    cam.End3D()
end)

hook.Add("RenderScene ATLAS", "Portal.RenderScene ATLAS", function(Origin, Angles)
    local portalType = GetConVarNumber("portal_texFSB")
    local class = "prop_portal"
    
    if portalType >= 2 then
        class = "prop_portal_pbody"
    elseif portalType >= 1 then
        class = "prop_portal_atlas"
    end
    
    for _, v in ipairs(ents.FindByClass(class)) do
        local viewent = GetViewEntity()
        local pos = (IsValid(viewent) and viewent != LocalPlayer()) and viewent:GetPos() or Origin
        if IsInFront(Origin, v:GetRenderOrigin(), v:GetForward()) then
            v:RenderPortal(Origin, Angles)
        end
    end
end)

CreateClientConVar("portal_debugmonitor", 0, false, false)
hook.Add("HUDPaint ATLAS", "Portal.BlueMonitor ATLAS", function(w, h)
    if GetConVarNumber("portal_debugmonitor") == 1 and GetConVarNumber("sv_cheats") == 1 then
        for _, v in ipairs(ents.FindByClass("prop_portal_atlas")) do
            if view and v:GetNWInt("Potal:PortalType", TYPE_BLUE_ATLAS) == TYPE_BLUE_ATLAS then
                surface.DrawLine(ScrW() / 2 - 10, ScrH() / 2, ScrW() / 2 + 10, ScrH() / 2)
                surface.DrawLine(ScrW() / 2, ScrH() / 2 - 10, ScrW() / 2, ScrH() / 2 + 10)

                local b = render.EnableClipping(true)
                render.PushCustomClipPlane(othernormal, otherdistance)
                view.w = 500
                view.h = 280
                RENDERING_PORTAL = true
                render.RenderView(view)
                RENDERING_PORTAL = false
                render.PopCustomClipPlane()
                render.EnableClipping(b)
            end
        end
    end
end)

/*------------------------------------
        GetMotionBlurValues()
------------------------------------*/
hook.Add("GetMotionBlurValues ATLAS", "Portal.GetMotionBlurValues ATLAS", function(x, y, fwd, spin)
    if RENDERING_PORTAL then
        return 0, 0, 0, 0
    end
end)

hook.Add("PostProcessPermitted ATLAS", "Portal.PostProcessPermitted ATLAS", function(element)
    if element == "bloom" and RENDERING_PORTAL then
        return false
    end
end)

usermessage.Hook("Portal:ObjectInPortal", function(umsg)
    local portal = umsg:ReadEntity()
    local ent = umsg:ReadEntity()
    if IsValid(ent) and IsValid(portal) then
        ent.InPortal = portal
        -- Uncomment and adjust the code below if needed for additional functionality
        -- if ent:IsPlayer() then
        --     portal:SetupPlayerClone(ent)
        -- end
        ent:SetRenderClipPlaneEnabled(true)
        ent:SetGroundEntity(portal)
    end
end)

usermessage.Hook("Portal:ObjectLeftPortal", function(umsg)
    local ent = umsg:ReadEntity()
    if IsValid(ent) then
        -- Uncomment and adjust the code below if needed for additional functionality
        -- if ent:IsPlayer() and IsValid(ent.PortalClone) then
        --     ent.PortalClone:Remove()
        -- end
        ent.InPortal = false
        ent:SetRenderClipPlaneEnabled(false)
    end
end)

hook.Add("RenderScreenspaceEffects ATLAS", "Portal.RenderScreenspaceEffects ATLAS", function()
    for _, v in pairs(ents.GetAll()) do
        if IsValid(v.InPortal) then
            local normal = v.InPortal:GetForward()
            local distance = normal:Dot(v.InPortal:GetRenderOrigin())

            v:SetRenderClipPlaneEnabled(true)
            v:SetRenderClipPlane(normal, distance)
        end
    end
end)

/*------------------------------------
        VectorAngles()
------------------------------------*/
function math.VectorAngles(forward, up)
    local angles = Angle(0, 0, 0)

    local left = up:Cross(forward)
    left:Normalize()

    local xydist = math.sqrt(forward.x * forward.x + forward.y * forward.y)

    if xydist > 0.001 then
        angles.y = math.deg(math.atan2(forward.y, forward.x))
        angles.p = math.deg(math.atan2(-forward.z, xydist))
        angles.r = math.deg(math.atan2(left.z, (left.y * forward.x) - (left.x * forward.y)))
    else
        angles.y = math.deg(math.atan2(-left.x, left.y))
        angles.p = math.deg(math.atan2(-forward.z, xydist))
        angles.r = 0
    end

    return angles
end

-- Red = in, Blue = out
usermessage.Hook("DebugOverlay_LineTrace", function(umsg)
    local p1, p2, b = umsg:ReadVector(), umsg:ReadVector(), umsg:ReadBool()
    local col = b and Color(255, 0, 0, 255) or Color(0, 0, 255, 255)
    debugoverlay.Line(p1, p2, 5, col)
end)

usermessage.Hook("DebugOverlay_Cross", function(umsg)
    local point = umsg:ReadVector()
    local b = umsg:ReadBool()
    local color = b and Color(0, 255, 0) or Color(255, 0, 0)
    debugoverlay.Cross(point, 5, 5, color, true)
end)

hook.Add("Think ATLAS", "Reset Camera Roll ATLAS", function()
    local ply = LocalPlayer()
    if not ply:InVehicle() then
        local a = ply:EyeAngles()
        if a.r != 0 then
            a.r = math.ApproachAngle(a.r, 0, FrameTime() * 160)
            ply:SetEyeAngles(a)
        end
    end
end)
