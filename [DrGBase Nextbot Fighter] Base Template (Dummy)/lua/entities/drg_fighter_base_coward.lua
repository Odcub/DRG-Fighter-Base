if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drg_fighter_base_template" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Dummy (Coward)"
ENT.Category = "DrG-Fighter Base"
ENT.Models = {"models/pipann/pipdummy_male.mdl"}
ENT.Spawnable = true

-- Relationships --
ENT.Factions = {
    "FACTION_DRGFIGHTER",
    "FACTION_DRGCOWARD"
}

ENT.Flee = true

-- Stats --
ENT.SpawnHealth = 200
ENT.HealthRegen = 0
ENT.IsFrightening = true

ENT.AvoidEnemyRange = 5000

ENT.WalkAnimation = "move_foward"
ENT.WalkAnimRate = 1
ENT.RunAnimation = "move_run"
ENT.RunAnimRate = 1

ENT.RunSpeed = 500

if SERVER then
    function ENT:CustomInitialize() 
        self:SetSelfClassRelationship(D_LI)
		self:SetDefaultRelationship(D_FR)
		self:SetPlayersRelationship(D_FR)
    end

    function ENT:OnRangeAttack(enemy)
    end

    function ENT:OnMeleeAttack(enemy)
    end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)