--[[
	Author: kritth (modified by SwordBacon)
	Date: 7.1.2015.
	Increasing stack after each hit
]]

function fury_swipes_attack( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierName = "modifier_fury_swipes_target_lod"
	local damageType = ability:GetAbilityDamageType()
	local exceptionName = "npc_dota_roshan"

	if target:IsBuilding() then return end
	
	-- Necessary value from KV
	local duration = ability:GetLevelSpecialValueFor( "bonus_reset_time", ability:GetLevel() - 1 )
	local damage_per_stack = ability:GetLevelSpecialValueFor( "damage_per_stack", ability:GetLevel() - 1 )
	if caster:IsRangedAttacker() then damage_per_stack = ability:GetLevelSpecialValueFor( "damage_per_stack_ranged", ability:GetLevel() - 1 ) end


	if target:GetName() == exceptionName then	-- Put exception here
		duration = ability:GetLevelSpecialValueFor( "bonus_reset_time_roshan", ability:GetLevel() - 1 )
	end
	
	-- Check if unit already have stack
	if target:HasModifier( modifierName ) then
		local current_stack = target:GetModifierStackCount( modifierName, ability )
		
		-- Deal damage
		local damage_table = {
			victim = target,
			attacker = caster,
			damage = damage_per_stack * current_stack,
			damage_type = damageType
		}
		ApplyDamage( damage_table )
		
		ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
		target:SetModifierStackCount( modifierName, ability, current_stack + 1 )
	else
		ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
		target:SetModifierStackCount( modifierName, ability, 1 )
		
		-- Deal damage
		local damage_table = {
			victim = target,
			attacker = caster,
			damage = damage_per_stack,
			damage_type = damageType
		}
		ApplyDamage( damage_table )
	end
end