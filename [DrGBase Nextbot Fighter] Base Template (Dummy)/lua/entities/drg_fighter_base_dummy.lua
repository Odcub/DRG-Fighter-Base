if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drg_fighter_base_template" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Dummy (Regular)"
ENT.Category = "DrG-Fighter Base"
ENT.Models = {"models/pipann/pipdummy_male.mdl"}
ENT.Spawnable = true

-- Relationships --
ENT.Factions = {
    "FACTION_DRGFIGHTER",
    "FACTION_DRGDUMMY"
}

ENT.SpawnHealth = 900
ENT.HealthRegen = 50

ENT.WalkSpeed = 0
ENT.RunSpeed = 0

ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 0
ENT.ReachEnemyRange = 0
ENT.AvoidEnemyRange = 0

ENT.MaxYawRate = 0

if SERVER then
    function ENT:CustomInitialize() 
        self:SetSelfClassRelationship(D_LI)
		self:SetDefaultRelationship(D_NU, 4)
		self:SetPlayersRelationship(D_NU, 4)
    end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)