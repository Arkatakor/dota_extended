-- Author: Shush
-- Date: 16/05/2017


---------------------------------
--       ASSAULT CUIRASS       --
---------------------------------
item_extended_assault = class({})
LinkLuaModifier("modifier_extended_assault_cuirass", "items/item_assault_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_extended_assault_cuirass_aura_positive", "items/item_assault_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_extended_assault_cuirass_aura_positive_effect", "items/item_assault_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_extended_assault_cuirass_aura_negative", "items/item_assault_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_extended_assault_cuirass_aura_negative_effect", "items/item_assault_cuirass.lua", LUA_MODIFIER_MOTION_NONE)

function item_extended_assault:GetIntrinsicModifierName()
    return "modifier_extended_assault_cuirass"
end



-- Stats passive modifier (stacking)
modifier_extended_assault_cuirass = class({})

function modifier_extended_assault_cuirass:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.modifier_self = "modifier_extended_assault_cuirass"
    self.modifier_aura_positive = "modifier_extended_assault_cuirass_aura_positive"
    self.modifier_aura_negative = "modifier_extended_assault_cuirass_aura_negative"

    -- Abiltiy specials
    self.bonus_as = self.ability:GetSpecialValueFor("bonus_as")
    self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")    

    if IsServer() then
        -- If it is the first Assault Cuirass in the inventory, grant the Assault Cuirass aura
        if not self.caster:HasModifier(self.modifier_aura_positive) then
            self.caster:AddNewModifier(self.caster, self.ability, self.modifier_aura_positive, {})
            self.caster:AddNewModifier(self.caster, self.ability, self.modifier_aura_negative, {})
        end
    end
end

function modifier_extended_assault_cuirass:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,                      
                      MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
    return decFuncs
end

function modifier_extended_assault_cuirass:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_as
end

function modifier_extended_assault_cuirass:GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end


function modifier_extended_assault_cuirass:IsHidden() return true end
function modifier_extended_assault_cuirass:IsPurgable() return false end
function modifier_extended_assault_cuirass:IsDebuff() return false end
function modifier_extended_assault_cuirass:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_extended_assault_cuirass:OnDestroy()
    if IsServer() then
        -- If it is the last Assault Cuirass in the inventory, remove the aura
        if not self.caster:HasModifier(self.modifier_self) then
            self.caster:RemoveModifierByName(self.modifier_aura_positive)
            self.caster:RemoveModifierByName(self.modifier_aura_negative)
        end
    end
end



-- Assault Cuirass positive aura
modifier_extended_assault_cuirass_aura_positive = class({})

function modifier_extended_assault_cuirass_aura_positive:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.modifier_assault = "modifier_extended_assault_cuirass_aura_positive_effect"

    -- Ability specials
    self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_extended_assault_cuirass_aura_positive:IsDebuff() return false end
function modifier_extended_assault_cuirass_aura_positive:AllowIllusionDuplicate() return true end
function modifier_extended_assault_cuirass_aura_positive:IsHidden() return true end
function modifier_extended_assault_cuirass_aura_positive:IsPurgable() return false end

function modifier_extended_assault_cuirass_aura_positive:GetAuraRadius()
    return self.radius
end

function modifier_extended_assault_cuirass_aura_positive:GetAuraEntityReject(target)
    -- If the target has Siege Aura from Siege Cuirass, ignore it
    if target:HasModifier("modifier_extended_siege_cuirass_aura_positive_effect") then
        return true
    end

    return false
end

function modifier_extended_assault_cuirass_aura_positive:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_extended_assault_cuirass_aura_positive:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_extended_assault_cuirass_aura_positive:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_extended_assault_cuirass_aura_positive:GetModifierAura()
    return self.modifier_assault
end

function modifier_extended_assault_cuirass_aura_positive:IsAura()
    return true
end



-- Assault Cuirass positive aura effect
modifier_extended_assault_cuirass_aura_positive_effect = class({})

function modifier_extended_assault_cuirass_aura_positive_effect:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()    

    -- Ability specials
    self.aura_as_ally = self.ability:GetSpecialValueFor("aura_as_ally")    
    self.aura_armor_ally = self.ability:GetSpecialValueFor("aura_armor_ally")    
end

function modifier_extended_assault_cuirass_aura_positive_effect:IsHidden() return false end
function modifier_extended_assault_cuirass_aura_positive_effect:IsPurgable() return false end
function modifier_extended_assault_cuirass_aura_positive_effect:IsDebuff() return false end

function modifier_extended_assault_cuirass_aura_positive_effect:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,                    
                      MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}

    return decFuncs
end

function modifier_extended_assault_cuirass_aura_positive_effect:GetModifierAttackSpeedBonus_Constant()    
    return self.aura_as_ally    
end

function modifier_extended_assault_cuirass_aura_positive_effect:GetModifierPhysicalArmorBonus()    
    return self.aura_armor_ally       
end


-- Assault Cuirass negative aura
modifier_extended_assault_cuirass_aura_negative = class({})

function modifier_extended_assault_cuirass_aura_negative:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.modifier_siege = "modifier_extended_assault_cuirass_aura_negative_effect"

    -- Ability specials
    self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_extended_assault_cuirass_aura_negative:IsDebuff() return false end
function modifier_extended_assault_cuirass_aura_negative:AllowIllusionDuplicate() return true end
function modifier_extended_assault_cuirass_aura_negative:IsHidden() return true end
function modifier_extended_assault_cuirass_aura_negative:IsPurgable() return false end

function modifier_extended_assault_cuirass_aura_negative:GetAuraRadius()
    return self.radius
end

function modifier_extended_assault_cuirass_aura_negative:GetAuraEntityReject(target)
    -- If the target has Siege Aura from Siege Cuirass, ignore it
    if target:HasModifier("modifier_extended_siege_cuirass_aura_negative_effect") then
        return true
    end

    return false
end

function modifier_extended_assault_cuirass_aura_negative:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES 
end

function modifier_extended_assault_cuirass_aura_negative:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_extended_assault_cuirass_aura_negative:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_extended_assault_cuirass_aura_negative:GetModifierAura()
    return self.modifier_siege
end

function modifier_extended_assault_cuirass_aura_negative:IsAura()
    return true
end



-- Assault Cuirass negative aura effect
modifier_extended_assault_cuirass_aura_negative_effect = class({})

function modifier_extended_assault_cuirass_aura_negative_effect:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()    

    -- Ability specials        
    self.aura_armor_reduction_enemy = self.ability:GetSpecialValueFor("aura_armor_reduction_enemy")       
end

function modifier_extended_assault_cuirass_aura_negative_effect:IsHidden() return false end
function modifier_extended_assault_cuirass_aura_negative_effect:IsPurgable() return false end
function modifier_extended_assault_cuirass_aura_negative_effect:IsDebuff() return true end

function modifier_extended_assault_cuirass_aura_negative_effect:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}

    return decFuncs
end

function modifier_extended_assault_cuirass_aura_negative_effect:GetModifierPhysicalArmorBonus()    
    return self.aura_armor_reduction_enemy * (-1)       
end
