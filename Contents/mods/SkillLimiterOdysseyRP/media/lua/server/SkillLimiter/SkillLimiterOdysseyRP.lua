-----
--- FILE NAME : SkillLimiterOdysseyRP
--- AUTHOR : TRNEEDANAME
--- DATE OF CREATION : 2024-11-10
--- DATE OF MODIFICATION : 2024-12-19
--- PURPOSE : Limit skills
-----

-- Mod info class
---@class SkillLimiterOdysseyRP
SkillLimiterOdysseyRP = {}

-- Mod info
SkillLimiterOdysseyRP.modName = "Skill Limiter : The Odyssey's limit"
SkillLimiterOdysseyRP.modVersion = "1.0"
SkillLimiterOdysseyRP.modAuthor = "TRNEEDANAME"
SkillLimiterOdysseyRP.modDescription = "Limits the maximum skill level of a character based on their traits and profession, and allow for surpassing it"

SkillLimiterOdysseyRP.allTraits = getTraits()

---@return boolean[]
---@param perk PerkFactory.Perk
--- We get the array
SkillLimiterOdysseyRP.getActivePerk = function(perk)
    local perk_name_sandbox = {
        SkillLimiterOdysseyRP.SkillLimiter_EnableStrengthLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableFitnessLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableSprintingLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableLightfootedLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableNimbleLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableSneakingLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableAxeLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableLongBluntLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableShortBluntLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableLongBladeLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableShortBladeLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableSpearLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableMaintenanceLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableCarpentryLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableCookingLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableFarmingLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableFirstAidLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableElectricalLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableMetalWorkingLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableTailoringLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableAimingLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableReloadingLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableFishingLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableTrappingLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableForagingLimit,
        SkillLimiterOdysseyRP.SkillLimiter_EnableMechanicLimit,
    }

    local res = {}

    for i = 1, #perk_name_sandbox do
        if perk_name_sandbox[i] == true then
            table.insert(res, true)
        else
            table.insert(res, false)
        end
    end
    return res
end

---@return integer
---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
function SkillLimiterOdysseyRP.checkSkillLimits(character, perk)
    local limits = {}
    local list_perk = {
        "Strength",
        "Fitness",
        "Sprinting",
        "Sneak",
        "Lightfoot",
        "Nimble",
        "Fishing",
        "Farming",
        "PlantScavenging",
        "Trapping",
        "Doctor",
        "Tailoring",
        "Cooking",
        "Maintenance",
        "Woodwork",
        "Electricity",
        "Mechanics",
        "MetalWelding",
        "Blunt",
        "SmallBlade",
        "SmallBlunt",
        "Axe",
        "Spear",
        "LongBlade",
        "Aiming",
        "Reloading",
        "Woodcutting",
    }

    local

    for i, skillTraits in ipairs(SkillLimiterOdysseyRP.skillLimitingTraits) do
        if SkillLimiterOdysseyRP.getActivePerk(perk)[i] then
            local limit = 0

            -- Check for limiting traits
            if skillTraits then
                for item in string.gmatch(skillTraits, "[^;]+") do
                    item = item:match("^%s*(.-)%s*$")
                    local trait = SkillLimiterOdysseyRPCheckTraits(SkillLimiterOdysseyRP.allTraits, item)
                    if trait then
                        print("Skill Limiter : Found ", item)
                        limit = limit + 1
                    else
                        print("Skill Limiter : Trait not found! ", item)
                        -- Found no limiting traits, so we set it to 4
                        limit = 4
                    end
                end
            end

            -- Check for XP boost trait, if found, increase limit by 2
            if character:getTraits():contains(SkillLimiterOdysseyRP.traitXPBoosts[i]) then
                print("Skill Limiter : Found ", SkillLimiterOdysseyRP.traitXPBoosts[i], "XP boosting trait")
                limit = limit + SandboxVars.SkillLimiterOdysseyRP_SkillLimitIncrease
            end

            limits[i] = limit
        else
            limits[i] = 4  -- Skill check is disabled, so we set the limit to 4
        end
    end

    return limits
end

function SkillLimiterOdysseyRPCheckTraits(traits, item)
    for i=0, traits:size()-1 do
        local trait = traits:get(i)
        if trait:getLabel() == item then
            return trait:getType()
        end
    end
    return false
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
    local perk_active = SkillLimiter.getActivePerk(perk)
    local list_perk = {
        "Strength",
        "Fitness",
        "Sprinting",
        "Sneak",
        "Lightfoot",
        "Nimble",
        "Fishing",
        "Farming",
        "PlantScavenging",
        "Trapping",
        "Doctor",
        "Tailoring",
        "Cooking",
        "Maintenance",
        "Woodwork",
        "Electricity",
        "Mechanics",
        "MetalWelding",
        "Blunt",
        "SmallBlade",
        "SmallBlunt",
        "Axe",
        "Spear",
        "LongBlade",
        "Aiming",
        "Reloading",
        "Woodcutting",
    }

    -- Check if the perk is active
    for i = 1, #list_perk do
        if list_perk[i] == perk:getId() and not perk_active[i] then
            print("SkillLimiter: the perk" .. perk:getId() .. " is not active, and therefore will not be limited.")
            return SandboxVars.SkillLimiter.PerkLvl3Cap
        end
    end
    
    local bonus = SkillLimiterOdysseyRP.checkSkillLimits(character_traits)

    if not bonus then
        print("SkillLimiterOdysseyRP: Limiting to max cap since perk was not found: " .. perk:getId() .. ".")
        return SandboxVars.SkillLimiterOdysseyRP.PerkLvl10Cap
    end

    -- If bonus is 10, we do not need to check whether or not we should cap the skill. Return.
    if bonus >= 10 then
        print("SkillLimiterOdysseyRP: Limiting to max cap since bonus >= 10: (" .. bonus .. ")")
        return SandboxVars.SkillLimiterOdysseyRP.PerkLvl10Cap
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
        trait_perk_level = trait_perk_level + bonus
    end

    if trait_perk_level <= 0 then
        return SandboxVars.SkillLimiterOdysseyRP.PerkLvl0Cap
    end
    if trait_perk_level == 1 then
        return SandboxVars.SkillLimiterOdysseyRP.PerkLvl1Cap
    end
    if trait_perk_level == 2 then
        return SandboxVars.SkillLimiterOdysseyRP.PerkLvl2Cap
    end
    if trait_perk_level == 3 then
        return SandboxVars.SkillLimiterOdysseyRP.PerkLvl3Cap
    end
    if trait_perk_level == 4 then
        return SandboxVars.SkillLimiterOdysseyRP.PerkLvl4Cap
    end
    if trait_perk_level == 5 then
        return SandboxVars.SkillLimiterOdysseyRP.PerkLvl5Cap
    end
    if trait_perk_level == 6 then
        return SandboxVars.SkillLimiterOdysseyRP.PerkLvl6Cap
    end
    if trait_perk_level == 7 then
        return SandboxVars.SkillLimiterOdysseyRP.PerkLvl7Cap
    end
    if trait_perk_level == 8 then
        return SandboxVars.SkillLimiterOdysseyRP.PerkLvl8Cap
    end
    if trait_perk_level == 9 then
        return SandboxVars.SkillLimiterOdysseyRP.PerkLvl9Cap
    end
    return SandboxVars.SkillLimiterOdysseyRP.PerkLvl10Cap
end

---@param character IsoGameCharacter
---@param perk PerkFactory.Perk
---@param level Integer
SkillLimiterOdysseyRP.limitSkill = function(character, perk, level)
    -- Get the maximum skill level for this perk, based on the character's traits & profession.
    local max_skill = SkillLimiterOdysseyRP.getMaxSkill(character, perk)
    if max_skill == nil then
        print("SkillLimiterOdysseyRP: Error. Max Skill is nil.")
        return
    end

    if level > max_skill then
        -- Cap the skill level.
        character:getXp():setXPToLevel(perk, max_skill)
        character:setPerkLevelDebug(perk, max_skill)
        SyncXp(character)

        print("SkillLimiterOdysseyRP: " .. character:getFullName() .. " leveled up " .. perk:getId() .. " and was capped to level " .. max_skill .. ".")
        HaloTextHelper.addText(character, "The " .. perk:getId() .. " skill was capped to level " .. max_skill .. ".", HaloTextHelper.getColorWhite())
    end
end

-- Mod event variables

SkillLimiterOdysseyRP.ticks_since_check = 0
SkillLimiterOdysseyRP.perks_leveled_up = {}

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

    table.insert(SkillLimiterOdysseyRP.perks_leveled_up, {
        character = character,
        perk = perk,
        level = level
    })
end


local function check_table()
    if (SkillLimiterOdysseyRP.ticks_since_check < 30) then
        SkillLimiterOdysseyRP.ticks_since_check = SkillLimiterOdysseyRP.ticks_since_check + 1
        return
    end

    SkillLimiterOdysseyRP.ticks_since_check = 0

    for i, v in ipairs(SkillLimiterOdysseyRP.perks_leveled_up) do
        SkillLimiterOdysseyRP.limitSkill(v.character, v.perk, v.level)
    end
    SkillLimiterOdysseyRP.perks_leveled_up = {}
end

local function isSkillCheckEnabled(skillIndex)
    return SkillLimiterOdysseyRP.skillCheckEnabled[skillIndex]
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledStrength(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.STRENGTH)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledFitness(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.FITNESS)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledSprint(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.SPRINTING)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledLightfoot(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.LIGHTFOOTED)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledNimble(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.NIMBLE)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledSneak(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.SNEAKING)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledAxe(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.AXE)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledLongBlunt(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.LONG_BLUNT)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledShortBlunt(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.SHORT_BLUNT)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledLongBlade(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.LONG_BLADE)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledShortBlade(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.SHORT_BLADE)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledSpear(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.SPEAR)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledMaintenance(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.MAINTENANCE)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledCarpentry(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.CARPENTRY)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledCook(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.COOKING)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledFarm(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.FARMING)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledFirstAid(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.FIRST_AID)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledElectrical(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.ELECTRICAL)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledMetalWorker(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.METALWORKING)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledTailor(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.TAILORING)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledAim(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.AIMING)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledReload(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.RELOADING)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledFish(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.FISHING)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledTrap(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.TRAPPING)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledForage(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.FORAGING)
end

---@param player IsoGameCharacter | IsoPlayer
function OnCanPerformCheckSkillEnabledMechanic(recipe, player)
    return isSkillCheckEnabled(SkillLimiterOdysseyRP.SKILL_INDICES.MECHANIC)
end



-------
--- BOOKS
-------



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

local function init_check()
    local character = getPlayer()

    if character then
        for j = 0, Perks.getMaxIndex() - 1 do
            local perk = PerkFactory.getPerk(Perks.fromIndex(j))
            local level = character:getPerkLevel(perk)
            SkillLimiterOdysseyRP.limitSkill(character, perk, level)
        end
    end
end

local function init()
    Events.OnTick.Remove(init)

    print(SkillLimiterOdysseyRP.modName .. " " .. SkillLimiterOdysseyRP.modVersion .. " initialized.")

    init_check()
end

Events.LevelPerk.Add(add_to_table)
Events.OnTick.Add(check_table)
Events.OnTick.Add(init)