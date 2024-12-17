-- Mod info class
---@class SkillLimiterOdysseyRP
SkillLimiterOdysseyRP = {}

-- Mod info
SkillLimiterOdysseyRP.modName = "Skill Limiter : The Odyssey's limit"
SkillLimiterOdysseyRP.modVersion = "1.0"
SkillLimiterOdysseyRP.modAuthor = "TRNEEDANAME"
SkillLimiterOdysseyRP.modDescription = "Limits the maximum skill level of a character based on their traits and profession."

SkillLimiterOdysseyRP.allTraits = TraitFactory.getTraits()
SkillLimiterOdysseyRP.skillLimitingTraits = {
    SandboxVars.SkillLimiterOdysseyRP.SprintingLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.LightfootedLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.NimbleLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.SneakingLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.AxeLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.LongBluntLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.ShortBluntLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.LongBladeLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.ShortBladeLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.SpearLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.MaintenanceLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.CarpentryLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.CookingLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.FarmingLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.FirstAidLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.ElectricalLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.MetalWorkingLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.TailoringLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.AimingLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.ReloadingLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.FishingLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.TrappingLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.ForagingLimitingTrait,
    SandboxVars.SkillLimiterOdysseyRP.MechanicLimitingTrait,
}

SkillLimiterOdysseyRP.skillCheckEnabled = {
    true,  -- Sprinting
    true,  -- Lightfooted
    true,  -- Nimble
    true,  -- Sneaking
    false,  -- Axe
    false,  -- Long Blunt
    false,  -- Short Blunt
    false,  -- Long Blade
    false,  -- Short Blade
    false,  -- Spear
    true,  -- Maintenance
    true,  -- Carpentry
    true,  -- Cooking
    true,  -- Farming
    true,  -- First Aid
    true,  -- Electrical
    true,  -- Metal Working
    true,  -- Tailoring
    true,  -- Aiming
    true,  -- Reloading
    true,  -- Fishing
    true,  -- Trapping
    true,  -- Foraging
    true,  -- Mechanic
}

--- They give +2 upon being gained
SkillLimiterOdysseyRP.traitXPBoosts = {
    "TR_SprintingXP",
    "TR_LightfootedXP",
    "TR_NimbleXP",
    "TR_SneakingXP",
    "TR_AxeXP",
    "TR_LongBluntXP",
    "TR_ShortBluntXP",
    "TR_LongBladeXP",
    "TR_ShortBladeXP",
    "TR_SpearXP",
    "TR_MaintenanceXP",
    "TR_CarpentryXP",
    "TR_CookingXP",
    "TR_FarmingXP",
    "TR_FirstAidXP",
    "TR_ElectricalXP",
    "TR_MetalWorkingXP",
    "TR_TailoringXP",
    "TR_AimingXP",
    "TR_ReloadingXP",
    "TR_FishingXP",
    "TR_TrappingXP",
    "TR_ForagingXP",
    "TR_MechanicXP",
    "TR_LifeStyleXP"
}

-- Add this function to your file
function SkillLimiterOdysseyRP.checkSkillLimits(player)
    local limits = {}

    for i, skillTraits in ipairs(SkillLimiterOdysseyRP.skillLimitingTraits) do
        if SkillLimiterOdysseyRP.skillCheckEnabled[i] then
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
                        -- Found no limiting traits, so we set it to 10
                        limit = 10
                    end
                end
            end

            -- Check for XP boost trait
            if player:getTraits():contains(SkillLimiterOdysseyRP.traitXPBoosts[i]) then
                print("Skill Limiter : Found ", SkillLimiterOdysseyRP.traitXPBoosts[i], "XP boosting trait")
                limit = limit + 1
            end

            limits[i] = limit
        else
            limits[i] = 10  -- Skill check is disabled, so we set the limit to 10
        end
    end

    return limits
end

-- Update the existing SkillLimiterOdysseyRPCheckTraits function
function SkillLimiterOdysseyRPCheckTraits(traits, item)
    for i=0, traits:size()-1 do
        local trait = traits:get(i)
        if trait:getLabel() == item then
            return trait:getType()
        end
    end
    return false
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
end

-- Mechanic Trait
if self.item:getFullType() == "Base.TR_MechanicXPMag" then
    local traits = self.character:getTraits()

    if not traits:contains("TR_MechanicXP") then
        traits:add("TR_MechanicXP")
    end
end


	-- -- Dextrous Trait
	-- if self.item:getFullType() == "Base.DextrousMag" then
	-- 	local traits = self.character:getTraits()
	-- 	local modData = self.character:getModData()

	-- 	-- Reading should always remove negative trait if it exists.
	-- 	if traits:contains("AllThumbs") then
	-- 		modData.StartedWithAllThumbs = true
	-- 		traits:remove("AllThumbs")
	-- 		-- Check if sandbox option to replace is enabled.
	-- 		if sBvars.ReplaceTraits == true and not traits:contains("Dextrous") then
	-- 			traits:add("Dextrous")
	-- 		end

	-- 	-- If no negative trait, check if player already has the positive trait, add it if not.
	-- 	elseif not traits:contains("Dextrous") then
	-- 		if not modData.StartedWithAllThumbs or sBvars.ReplaceTraits == true then
	-- 			traits:add("Dextrous")
	-- 		end

	-- 	-- If sandbox option to remove trait is enabled, remove the trait.
	-- 	elseif sBvars.ReadRemove == true then
	-- 		traits:remove("Dextrous")
	-- 	end
	-- end

	return old_ISReadABookPerform(self, ...)
end

local function init_check()
    local character = getPlayer()

    if character then
        for j=0, Perks.getMaxIndex() - 1 do
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
Events.OnTick.Add(init);
