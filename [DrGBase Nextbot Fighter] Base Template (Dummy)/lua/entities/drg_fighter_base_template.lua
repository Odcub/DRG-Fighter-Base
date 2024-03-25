if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "BASE TEMPLATE"
ENT.Category = "DrG-Fighter Base"
ENT.Models = {"models/pipann/pipdummy_male.mdl"}
ENT.Skins = {0}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 72)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = false
ENT.Spawnable = false

-- Stats --
ENT.SpawnHealth = 200
ENT.HealthRegen = 5
ENT.MinPhysDamage = 10
ENT.MinFallDamage = 10

-- AI --
ENT.Omniscient = false
ENT.SpotDuration = 30
ENT.RangeAttackRange = 40
ENT.MeleeAttackRange = 40
ENT.ReachEnemyRange = 40
ENT.AvoidEnemyRange = 40

-- Relationships --
ENT.Factions = {
    "FACTION_DRGFIGHTER"
}
ENT.Frightening = false
ENT.AllyDamageTolerance = 0
ENT.AfraidDamageTolerance = 0
ENT.NeutralDamageTolerance = 0

-- Locomotion --
ENT.Acceleration = 1000
ENT.Deceleration = 1000
ENT.JumpHeight = 10
ENT.StepHeight = 20
ENT.MaxYawRate = 250
ENT.DeathDropHeight = 0

-- Animations --
ENT.WalkAnimation = "move_foward"
ENT.WalkAnimRate = 1
ENT.RunAnimation = "move_foward"
ENT.RunAnimRate = 1
ENT.IdleAnimation = "idle"
ENT.IdleAnimRate = 1
ENT.JumpAnimation = "jump1_fall"
ENT.JumpAnimRate = 1
ENT.SetSequenceLoop = false

-- Movements --
ENT.UseWalkframes = false
ENT.WalkSpeed = 100
ENT.RunSpeed = 100

-- Other Functions --
ENT.Flee = false
ENT.DoNothing = false
ENT.AttackEnemy = false
ENT.IsAllies = false
ENT.TakeTurn = false
ENT.GiveTurn = false

-- Detection --
ENT.EyeBone = "bip_head"
ENT.EyeOffset = Vector(0, 0, 20)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.SightFOV = 150
ENT.SightRange = 15000
ENT.HearingCoefficient = 1

-- Weapons --
ENT.UseWeapons = false
ENT.AcceptPlayerWeapons = false


if SERVER then

    function ENT:CustomInitialize() 
        self:SetSelfClassRelationship(D_LI)
		self:SetDefaultRelationship(D_NU, 4)
		self:SetPlayersRelationship(D_NU, 4)
    end
    function ENT:CustomThink() 
    end
    --- Damage Apply ---
    function ApplyDamage(attacker, target, damage)
        if IsValid(target) then
            local dmginfo = DamageInfo()
            dmginfo:SetAttacker(attacker)
            dmginfo:SetInflictor(attacker) -- Assuming the inflictor is the same as the attacker
            dmginfo:SetDamage(damage)
            target:TakeDamageInfo(dmginfo)
        end
    end    
    ----==== Moves ====----
    ----=== Jab ===----
    local JAB_DAMAGE = 10 -- Example jab damage
    local KICK_DAMAGE = 20 -- Example kick damage
    local JAB_PUSH_FORCE = 100 -- Example jab push force
    local KICK_PUSH_FORCE = 120 -- Example kick push force
    local HIT_SOUND_JAB = "physics/body/body_medium_impact_soft1.wav" -- Example jab hit sound
    local HIT_SOUND_KICK = "physics/body/body_medium_impact_hard1.wav" -- Example kick hit sound
    
    function ENT:Jab()
        local target = self:GetEnemy()
        if IsValid(target) then
            ApplyDamage(self, target, JAB_DAMAGE)
            local direction = (target:GetPos() - self:GetPos()):GetNormalized()
            local phys = target:GetPhysicsObject()
            if IsValid(phys) then
                phys:ApplyForceCenter(direction * JAB_PUSH_FORCE)
            end
            target:EmitSound(HIT_SOUND_JAB)
        end
        self:PlaySequenceAndWait("attackmove_Jab")
    end
    
    function ENT:Kick()
        local target = self:GetEnemy()
        if IsValid(target) then
            ApplyDamage(self, target, KICK_DAMAGE)
            local direction = (target:GetPos() - self:GetPos()):GetNormalized()
            local phys = target:GetPhysicsObject()
            if IsValid(phys) then
                phys:ApplyForceCenter(direction * KICK_PUSH_FORCE)
            end
            target:EmitSound(HIT_SOUND_KICK)
        end
        self:PlaySequenceAndWait("attackmove_kick")
    end
    ----=== Jump 1 ===----
    function ENT:JumpForward_A()
        self.JumpAnimation = "jump1_fall"
        self:Timer(0.5,self.Jump,690)
        self:Timer(0.51,self.SetVelocity,(self:GetUp()*200+(self:GetForward()*200)))
        self:PlaySequenceAndMove("jump1_intro")
        self:SetCooldown("NextJump",10)
    end
    function ENT:JumpBackward_A()
        self.JumpAnimation = "jump1_fall"
        self:Timer(0.5,self.Jump,690)
        self:Timer(0.54,self.SetVelocity,(self:GetUp()*200+(self:GetForward()*-200)))
        self:PlaySequenceAndMove("jump1_intro")
        self:SetCooldown("NextJump",10)
    end
    ----=== Jump 2 ===----
    function ENT:JumpForward_B()
        self.JumpAnimation = "jump2_fall"
        self:Timer(0.5,self.Jump,690)
        self:Timer(0.51,self.SetVelocity,(self:GetUp()*200+(self:GetForward()*200)))
        self:PlaySequenceAndMove("jump2_intro")
        self:SetCooldown("NextJump",10)
    end
    function ENT:JumpBackward_B()
        self.JumpAnimation = "jump2_fall"
        self:Timer(0.5,self.Jump,690)
        self:Timer(0.54,self.SetVelocity,(self:GetUp()*200+(self:GetForward()*-200)))
        self:PlaySequenceAndMove("jump2_intro")
        self:SetCooldown("NextJump",10)
    end
    ----=== Double Jump ===----
    function ENT:Double_JumpForward()
        self.JumpAnimation = "jump2_fall"
        self:Timer(0.5,self.Jump,690)
        self:Timer(0.51,self.SetVelocity,(self:GetUp()*200+(self:GetForward()*200)))
        self:PlaySequence("jump2_intro")
        self:PlaySequenceAndMove("jump2_fall")
        self:SetCooldown("NextJump",3)
        self:Timer(0.65,self.Jump,690)
        self:Timer(0.66,self.SetVelocity,(self:GetUp()*200+(self:GetForward()*200)))
        self:PlaySequenceAndMove("jump2_doublejump_forward")
        self:SetCooldown("NextJump",3)
    end
    function ENT:Double_JumpBackward()
        self.JumpAnimation = "jump2_fall"
        self:Timer(0.5,self.Jump,690)
        self:Timer(0.51,self.SetVelocity,(self:GetUp()*200+(self:GetForward()*-200)))
        self:PlaySequenceAndMove("jump2_intro")
        self:SetCooldown("NextJump",3)
        self:Timer(0.65,self.Jump,690)
        self:Timer(0.66,self.SetVelocity,(self:GetUp()*200+(self:GetForward()*200)))
        self:PlaySequenceAndMove("jump2_doublejump_backward")
        self:SetCooldown("NextJump",3)
    end
    ----=== Double Jump  ===----
    function ENT:Double_JumpToBack()
        self.JumpAnimation = "jump2_fall"
        self:Timer(0.5,self.Jump,690)
        self:Timer(0.51,self.SetVelocity,(self:GetUp()*200+(self:GetForward()*200)))
        self:PlaySequenceAndMove("jump2_intro")
        self:SetCooldown("NextJump",3)
        self:Timer(0.65,self.Jump,690)
        self:Timer(0.66,self.SetVelocity,(self:GetUp()*200+(self:GetForward()*200)))
        self:PlaySequenceAndMove("jump2_doublejump_backward")
        self:SetCooldown("NextJump",3)
    end
    function ENT:Double_JumpToBack()
        self.JumpAnimation = "jump2_fall"
        self:Timer(0.5,self.Jump,690)
        self:Timer(0.51,self.SetVelocity,(self:GetUp()*200+(self:GetForward()*-200)))
        self:PlaySequenceAndMove("jump2_intro")
        self:SetCooldown("NextJump",3)
        self:Timer(0.65,self.Jump,690)
        self:Timer(0.66,self.SetVelocity,(self:GetUp()*200+(self:GetForward()*200)))
        self:PlaySequenceAndMove("jump2_doublejump_forward")
        self:SetCooldown("NextJump",3)
    end

    function ENT:OnMeleeAttack(enemy)
        -- Determine which attack move to execute
        local attackMove = math.random(1, 2) -- Assuming you have two melee attack moves
        
        if attackMove == 1 then
            self:Jab() -- Call the Jab function
        elseif attackMove == 2 then
            self:Kick() -- Call the Kick function
        end
        local shouldDoubleJump = math.random(1, 10) > 5 -- Example condition for double jump
        
        if shouldDoubleJump then
            local shouldJumpForward = math.random(1, 10) > 5 -- Example condition for jump direction
            if shouldJumpForward then
                self:Double_JumpForward()
            else
                self:Double_JumpBackward()
            end
            self:SetCooldown("NextJump",25) -- Set cooldown for double jump
        else
            local shouldJump2 = math.random(1, 10) > 5 -- Example condition for choosing jump 1 or 2
            if shouldJump2 then
                local shouldJumpForward = math.random(1, 10) > 5 -- Example condition for jump direction
                if shouldJumpForward then
                    local shouldUseJumpA = math.random(1, 10) > 5 -- Example condition for choosing Jump A or B
                    if shouldUseJumpA then
                        self:JumpForward_A()
                    else
                        self:JumpForward_B()
                    end
                else
                    local shouldUseJumpA = math.random(1, 10) > 5 -- Example condition for choosing Jump A or B
                    if shouldUseJumpA then
                        self:JumpBackward_A()
                    else
                        self:JumpBackward_B()
                    end
                end
                self:SetCooldown("NextJump",25)
            end
        end
    end    
    function ENT:OnRangeAttack(enemy)
    end
    
    function ENT:OnChaseEnemy(enemy) end

    function ENT:FleeAway()
        if self.Flee == true then
            self.RunSpeed = 200 
            self.RunAnimation = "move_run"
            self:SetDefaultRelationship(D_FR, 4)
            self:SetPlayersRelationship(D_FR, 4)
        end
    end

    function ENT:OnAvoidEnemy(enemy) 
        self:FleeAway()
    end
    
    function ENT:OnReachedPatrol(pos)
        self:Wait(math.random(3, 7))
    end 
    function ENT:OnPatrolUnreachable(pos) end
    function ENT:OnPatrolling(pos) end
    
    function ENT:OnNewEnemy(enemy) end
    function ENT:OnEnemyChange(oldEnemy, newEnemy) end
    function ENT:OnLastEnemy(enemy) end

    function ENT:PlaySequenceAndLoop(sequence)
        if not sequence then return end -- Ensure a sequence is provided
    
        -- Play the sequence and set it to loop
        self:ResetSequence(self:LookupSequence(sequence))
        self:SetCycle(0)
        self:SetPlaybackRate(1)
        self.SetSequenceLoop = true
    end
    
    function ENT:OnSpawn() end
    function ENT:OnIdle()
        self:AddPatrolPos(self:RandomPos(1500))
    end
    function ENT:Stunned(duration)
        duration = duration or 5
        self.WalkSpeed = 0
        self.RunSpeed = 0
        -- Play the stunned sequence and set it to loop
        self:PlaySequenceAndLoop("stunned")
    
        -- After the specified duration, stop the stun effect
        timer.Simple(duration, function()
            if IsValid(self) then
                self.SetSequenceLoop = false
                self:SetCycle(0) -- Reset cycle to the beginning
                self:ResetSequence(self:LookupSequence("idle"))
                self.WalkSpeed = 100
                self.RunSpeed = 100
            end
        end)
    end    
    function ENT:OnTakeDamage(dmg, hitgroup)
        self:SpotEntity(dmg:GetAttacker())
    
        -- Check if the damage is significant enough to trigger a stun (adjust the threshold as needed)
        if dmg:GetDamage() >= math.random(10, 100) then
            self:Stunned() -- Call the Stunned function
        end
    end
    function ENT:OnFatalDamage(dmg, hitgroup) 
        -- Optionally, call the Stunned function even on fatal damage
        if dmg:GetDamage() >= math.random(10, 100) then
            self:Stunned() -- Call the Stunned function
        end
    end
    
    function ENT:OnTookDamage(dmg, hitgroup) end
    function ENT:OnDeath(dmg, hitgroup) end
    function ENT:OnDowned(dmg, hitgroup) end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)