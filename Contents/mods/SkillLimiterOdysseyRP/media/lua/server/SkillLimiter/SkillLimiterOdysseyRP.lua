---
--- Created by Max
--- Initial help from: Konijima#9279
--- Profession bugfix by: ladyinkateing
--- Created on: 10/07/2022 21:23
---

-- Mod info class
---@class SkillLimiter
SkillLimiter = {}

-- Mod info
SkillLimiter.modName = "SkillLimiter"
SkillLimiter.modVersion = "1.1.1"
SkillLimiter.modAuthor = "Max"
SkillLimiter.modDescription = "Limits the maximum skill level of a character based on their traits and profession."

-- Fetch sandbox vars

---@return number
local function getAgilityBonus()
    local bonus = SandboxVars.SkillLimiter.AgilityBonus
    if bonus == nil then
        bonus = 0
    end
    return bonus
end

---@return number
local function getCombatBonus()
    local bonus = SandboxVars.SkillLimiter.CombatBonus
    if bonus == nil then
        bonus = 0
    end
    return bonus
end

---@return number
local function getCraftingBonus()
    local bonus = SandboxVars.SkillLimiter.CraftingBonus
    if bonus == nil then
        bonus = 0
    end
    return bonus
end

---@return number
local function getFirearmBonus()
    local bonus = SandboxVars.SkillLimiter.FirearmBonus
    if bonus == nil then
        bonus = 0
    end
    return bonus
end

---@return number
local function getSurvivalistBonus()
    local bonus = SandboxVars.SkillLimiter.SurvivalistBonus
    if bonus == nil then
        bonus = 0
    end
    return bonus
end

---@return number
local function getPassivesBonus()
    local bonus = SandboxVars.SkillLimiter.PassivesBonus
    if bonus == nil then
        bonus = 0
    end
    return bonus
end

--- Get the custom bonus for a perk from the SandboxVars.SkillLimiter.PerkBonuses setting.
---@return number
---@param perk PerkFactory.Perk
local function getCustomPerkBonus(perk)
    local perkBonuses = SandboxVars.SkillLimiter.PerkBonuses
    if perkBonuses == nil then
        perkBonuses = ""
    end
    -- parse perk bonuses. Semicolon separated list of perk id:bonus pairs
    for perkBonus in perkBonuses:gmatch("[^;]+") do

        local split_perk_bonus = {}

        for perk_bonus_value in perkBonus:gmatch("[^:]+") do
            table.insert(split_perk_bonus, perk_bonus_value)
        end

        -- The first value is the perk id, the second is the bonus
        local perk_name = split_perk_bonus[1]:lower()
        local perk_bonus_value = tonumber(split_perk_bonus[2])

        if perk_name == perk:getId():lower() then
            if perk_bonus_value == nil then
                print("SkillLimiter: Invalid perk bonus value for perk " .. perk:getId() .. ". Please check your sandbox settings.")
                return 0
            end

            return perk_bonus_value
        end
    end

    return 0
end

-- Mod methods

--- Get the bonus for a perk based on the SandboxVars settings.
---@return number
---@param perk PerkFactory.Perk
SkillLimiter.getPerkBonus = function(perk)
    local perk_category = perk:getParent():getId():lower()
    local perk_found = false
    local bonus = 0

    -- If perk is part of the Agility category, add the relevant bonus.
    if perk_category == "agility" then
        bonus = getAgilityBonus()
        perk_found = true
    end

    -- If perk is part of the Combat category, add the relevant bonus.
    if perk_category == "combat" then
        bonus = getCombatBonus()
        perk_found = true
    end

    -- If perk is part of the Crafting category, add the relevant bonus.
    if perk_category == "crafting" then
        bonus = getCraftingBonus()
        perk_found = true
    end

    -- If perk is part of the Firearm category, add the relevant bonus.
    if perk_category == "firearm" then
        bonus = getFirearmBonus()
        perk_found = true
    end

    -- If perk is part of the Survivalist category, add the relevant bonus.
    if perk_category == "survivalist" then
        bonus = getSurvivalistBonus()
        perk_found = true
    end

    -- If perk is part of the Passiv category, add the relevant bonus.
    if perk_category == "passiv" then
        bonus = getPassivesBonus()
        perk_found = true
    end

    -- If perk is not found, then we do not need to limit the skill. This is to provide compatibility (aka: don't cause errors) with other mods that add skills.
    if not perk_found then
        return nil
    end

    -- If the perk is in the perk bonus list, add the bonus to the total.
    local success, perk_bonus = pcall(getCustomPerkBonus, perk)
    if success then
        bonus = bonus + perk_bonus
    else
        print("SkillLimiter: Error. Could not get custom perk bonus for perk " .. perk:getId() .. ". Please check your sandbox settings.")
    end

    return bonus
end

SkilLimiter.getTraitBonus = function (character_traits, perk)
    local xp_trait_perk_list = {
        TR_SprintingXP = "Sprinting",
        TR_LightfootedXP = "Lightfooted",
        TR_NimbleXP = "Nimble",
        TR_SneakingXP = "Sneaking",
        TR_AxeXP = "Axe",
        TR_LongBluntXP = "LongBlunt",
        TR_ShortBluntXP = "SmallBlunt",
        TR_LongBladeXP = "LongBlade",
        TR_ShortBladeXP = "SmallBlade",
        TR_SpearXP = "Spear",
        TR_MaintenanceXP = "Maintenance",
        TR_CarpentryXP = "Woodwork",
        TR_CookingXP = "Cooking",
        TR_FarmingXP = "Farming",
        TR_FirstAidXP = "Doctor",
        TR_ElectricalXP = "Electricial",
        TR_MetalWorkingXP = "MetalWelding",
        TR_TailoringXP = "Tailoring",
        TR_MechanicXP = "Mechanic",
        TR_AimingXP = "Aiming",
        TR_ReloadingXP = "Reloading",
        TR_FishingXP = "Fishing",
        TR_TrappingXP = "Trapping",
        TR_ForagingXP = "PlantScavenging"
    }

    local bonus = 0

    for i = 0, character_traits:size() - 1 do
        local trait_str = character_traits:get(i)
        if xp_trait_perk_list[trait_str] and xp_trait_perk_list[trait_str] == perk:getName() then
            print("SkillLimiter: Trait bonus for " .. trait_str .. " and " .. perk:getName() .. " found. Adding +2")
            bonus = bonus + 2
        end
    end

    return bonus
end
--- Get the maximum skill level for a character based on their traits and profession.
---@return number
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
SkillLimiter.getMaxSkill = function(character, perk)
    local character_traits = character:getTraits()
    local character_profession_str = character:getDescriptor():getProfession()
    local trait_perk_level = 0

    local bonus = SkillLimiter.getPerkBonus(perk)
    local XP_bonus = SkillLimiter.getTraitBonus(character_traits, perk)

    if not bonus then
        print("SkillLimiter: Limiting to max cap since perk was not found: " .. perk:getId() .. ".")
        return SandboxVars.SkillLimiter.PerkLvl10Cap
    end

    -- If bonus is 3 or more, we do not need to check whether or not we should cap the skill. Return.
    if bonus >= 3 then
        print("SkillLimiter: Limiting to max cap since bonus >= 10: (" .. bonus .. ")")
        return SandboxVars.SkillLimiter.PerkLvl10Cap
    end

    -- Go through all traits and add their relevant perk level to the total
    for i=0, character_traits:size()-1 do
        local trait_str = character_traits:get(i);
        local trait = TraitFactory.getTrait(trait_str)
        local map = trait:getXPBoostMap();
        if map then
            local mapTable = transformIntoKahluaTable(map)
            for trait_perk, level in pairs(mapTable) do
                if trait_perk:getId() == perk:getId() then
                    trait_perk_level = trait_perk_level + level:intValue()
                end
            end
        end
    end

    local character_profession = ProfessionFactory.getProfession(character_profession_str)

    -- Go through the XPBoostMap of the profession and add the relevant perk level to the total
    if character_profession then
        local profession_xp_boost_map = character_profession:getXPBoostMap()
        if profession_xp_boost_map then
            local mapTable = transformIntoKahluaTable(profession_xp_boost_map)
            for prof_perk, level in pairs(mapTable) do
                if prof_perk:getId() == perk:getId() then
                    trait_perk_level = trait_perk_level + level:intValue()
                end
            end
        end
    end

    if bonus then
        trait_perk_level = trait_perk_level + bonus + XP_bonus
    end

    if trait_perk_level <= 0 then
        return SandboxVars.SkillLimiter.PerkLvl0Cap
    end
    if trait_perk_level == 1 then
        return SandboxVars.SkillLimiter.PerkLvl1Cap
    end
    if trait_perk_level == 2 then
        return SandboxVars.SkillLimiter.PerkLvl2Cap
    end
    if trait_perk_level == 3 then
        return SandboxVars.SkillLimiter.PerkLvl3Cap
    end
    if trait_perk_level >= 4 then
        return SandboxVars.SkillLimiter.PerkLvl4Cap
    end
    if trait_perk_level == 5 then
        return SandboxVars.SkillLimiter.PerkLvl5Cap
    end
    if trait_perk_level == 6 then
        return SandboxVars.SkillLimiter.PerkLvl6Cap
    end
    if trait_perk_level == 7 then
        return SandboxVars.SkillLimiter.PerkLvl7Cap
    end
    if trait_perk_level == 8 then
        return SandboxVars.SkillLimiter.PerkLvl8Cap
    end
    if trait_perk_level == 9 then
        return SandboxVars.SkillLimiter.PerkLvl9Cap
    end
    if trait_perk_level >= 10 then
        return SandboxVars.SkillLimiter.PerkLvl10Cap
    end
end

---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@param level Integer
SkillLimiter.limitSkill = function(character, perk, level)
    -- Get the maximum skill level for this perk, based on the character's traits & profession.
    local max_skill = SkillLimiter.getMaxSkill(character, perk)
    if max_skill == nil then
        print("SkillLimiter: Error. Max Skill is nil.")
        return
    end

    if level > max_skill then
        -- Cap the skill level.
        character:getXp():setXPToLevel(perk, max_skill)
        character:setPerkLevelDebug(perk, max_skill)
        SyncXp(character)

        print("SkillLimiter: " .. character:getFullName() .. " leveled up " .. perk:getId() .. " and was capped to level " .. max_skill .. ".")
        HaloTextHelper.addText(character, "The " .. perk:getId() .. " skill was capped to level " .. max_skill .. ".", HaloTextHelper.getColorWhite())
    end
end

-- Mod event variables

SkillLimiter.ticks_since_check = 0
SkillLimiter.perks_leveled_up = {}

-- Mod events

---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@param level Integer
---@param levelUp Boolean
local function add_to_table(character, perk, level, levelUp)
    -- If not levelUp, then we do not need to check whether or not we should cap the skill.
    -- This also prevents some infinite loops, since this function can cause a LevelPerk event to be fired.
    if not levelUp then
        return
    end

    table.insert(SkillLimiter.perks_leveled_up, {
        character = character,
        perk = perk,
        level = level
    })
end


local function check_table()
    if (SkillLimiter.ticks_since_check < 30) then
        SkillLimiter.ticks_since_check = SkillLimiter.ticks_since_check + 1
        return
    end

    SkillLimiter.ticks_since_check = 0

    for i, v in ipairs(SkillLimiter.perks_leveled_up) do
        SkillLimiter.limitSkill(v.character, v.perk, v.level)
    end
    SkillLimiter.perks_leveled_up = {}
end

local function init_check()
    local character = getPlayer()

    if character then
        for j=0, Perks.getMaxIndex() - 1 do
            local perk = PerkFactory.getPerk(Perks.fromIndex(j))
            local level = character:getPerkLevel(perk)
            SkillLimiter.limitSkill(character, perk, level)
        end
    end
end

local function init()
    Events.OnTick.Remove(init)

    print(SkillLimiter.modName .. " " .. SkillLimiter.modVersion .. " initialized.")

    init_check()
end



function ISReadABook:perform(...)

    -- Sprinting Trait
    if self.item:getFullType() == "Base.TR_SprintingXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_SprintingXP") then
            traits:add("TR_SprintingXP")
        end
    end
    
    -- Lightfooted Trait
    if self.item:getFullType() == "Base.TR_LightfootedXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_LightfootedXP") then
            traits:add("TR_LightfootedXP")
        end
    end
    
    -- Nimble Trait
    if self.item:getFullType() == "Base.TR_NimbleXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_NimbleXP") then
            traits:add("TR_NimbleXP")
        end
    end
    
    -- Sneaking Trait
    if self.item:getFullType() == "Base.TR_SneakingXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_SneakingXP") then
            traits:add("TR_SneakingXP")
        end
    end
    
    -- Axe Trait
    if self.item:getFullType() == "Base.TR_AxeXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_AxeXP") then
            traits:add("TR_AxeXP")
        end
    end
    
    -- LongBlunt Trait
    if self.item:getFullType() == "Base.TR_LongBluntXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_LongBluntXP") then
            traits:add("TR_LongBluntXP")
        end
    end
    
    -- ShortBlunt Trait
    if self.item:getFullType() == "Base.TR_ShortBluntXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_ShortBluntXP") then
            traits:add("TR_ShortBluntXP")
        end
    end
    
    -- LongBlade Trait
    if self.item:getFullType() == "Base.TR_LongBladeXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_LongBladeXP") then
            traits:add("TR_LongBladeXP")
        end
    end
    
    -- ShortBlade Trait
    if self.item:getFullType() == "Base.TR_ShortBladeXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_ShortBladeXP") then
            traits:add("TR_ShortBladeXP")
        end
    end
    
    -- Spear Trait
    if self.item:getFullType() == "Base.TR_SpearXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_SpearXP") then
            traits:add("TR_SpearXP")
        end
    end
    
    -- Maintenance Trait
    if self.item:getFullType() == "Base.TR_MaintenanceXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_MaintenanceXP") then
            traits:add("TR_MaintenanceXP")
        end
    end
    
    -- Carpentry Trait
    if self.item:getFullType() == "Base.TR_CarpentryXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_CarpentryXP") then
            traits:add("TR_CarpentryXP")
        end
    end
    
    -- Cooking Trait
    if self.item:getFullType() == "Base.TR_CookingXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_CookingXP") then
            traits:add("TR_CookingXP")
        end
    end
    
    -- Farming Trait
    if self.item:getFullType() == "Base.TR_FarmingXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_FarmingXP") then
            traits:add("TR_FarmingXP")
        end
    end
    
    -- FirstAid Trait
    if self.item:getFullType() == "Base.TR_FirstAidXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_FirstAidXP") then
            traits:add("TR_FirstAidXP")
        end
    end
    
    -- Electrical Trait
    if self.item:getFullType() == "Base.TR_ElectricalXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_ElectricalXP") then
            traits:add("TR_ElectricalXP")
        end
    end
    
    -- MetalWorking Trait
    if self.item:getFullType() == "Base.TR_MetalWorkingXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_MetalWorkingXP") then
            traits:add("TR_MetalWorkingXP")
        end
    end
    
    -- Tailoring Trait
    if self.item:getFullType() == "Base.TR_TailoringXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_TailoringXP") then
            traits:add("TR_TailoringXP")
    end
    
    -- Aiming Trait
    if self.item:getFullType() == "Base.TR_AimingXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_AimingXP") then
            traits:add("TR_AimingXP")
        end
    end
    
    -- Reloading Trait
    if self.item:getFullType() == "Base.TR_ReloadingXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_ReloadingXP") then
            traits:add("TR_ReloadingXP")
        end
    end
    
    -- Fishing Trait
    if self.item:getFullType() == "Base.TR_FishingXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_FishingXP") then
            traits:add("TR_FishingXP")
        end
    end
    
    -- Trapping Trait
    if self.item:getFullType() == "Base.TR_TrappingXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_TrappingXP") then
            traits:add("TR_TrappingXP")
        end
    end
    
    -- Foraging Trait
    if self.item:getFullType() == "Base.TR_ForagingXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_ForagingXP") then
            traits:add("TR_ForagingXP")
        end
    end -- Add this end to close the Foraging Trait if statement
    
    -- Mechanic Trait
    if self.item:getFullType() == "Base.TR_MechanicXPMag" then
        local traits = self.character:getTraits()
    
        if not traits:contains("TR_MechanicXP") then
            traits:add("TR_MechanicXP")
        end
    end
    
    
    return old_ISReadABookPerform(self, ...)
    end
    end

Events.LevelPerk.Add(add_to_table)
Events.OnTick.Add(check_table)
Events.OnTick.Add(init);
