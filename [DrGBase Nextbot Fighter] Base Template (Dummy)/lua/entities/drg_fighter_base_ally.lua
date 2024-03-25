if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drg_fighter_base_template" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Dummy (Ally)"
ENT.Category = "DrG-Fighter Base"
ENT.Models = {"models/pipann/pipdummy_male.mdl"}
ENT.Spawnable = true

-- Relationships --
ENT.Factions = {
    "FACTION_DRGFIGHTER",
    "FACTION_DRGALLY"
}

ENT.SpawnHealth = 200
ENT.HealthRegen = 0

if SERVER then
    function ENT:CustomInitialize() 
        self:SetSelfClassRelationship(D_LI)
		self:SetDefaultRelationship(D_HT, 4)
		self:SetPlayersRelationship(D_LI, 4)
    end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)